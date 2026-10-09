%% Shared SCRIPT preparation for q01:q15; run a01_probing first.
% Optional qcfg overrides persist. No data reload, clear, or figures.
assert(exist('data','var')==1 && isstruct(data),'Run a01_probing first.');
if ~exist('qcfg','var'), qcfg = struct(); end
qdefaults = struct('seed',42,'bootstrap',1000,'block_seconds',30, ...
    'waveform_srate',30000,'narrow_ms',0.4,'minimum_spikes',50, ...
    'matched_units',5,'trial_columns',[],'lfp_channels',[1 1 1]);
qnames = fieldnames(qdefaults);
for qi = 1:numel(qnames)
    if ~isfield(qcfg,qnames{qi}), qcfg.(qnames{qi}) = qdefaults.(qnames{qi}); end
end
validateattributes(qcfg.bootstrap,{'numeric'},{'scalar','integer','>=',20});
validateattributes(qcfg.block_seconds,{'numeric'},{'scalar','finite','>=',4});
validateattributes(qcfg.matched_units,{'numeric'},{'scalar','integer','positive'});
validateattributes(qcfg.waveform_srate,{'numeric'},{'scalar','finite','positive'});
validateattributes(qcfg.lfp_channels,{'numeric'},{'vector','numel',3,'integer','positive'});
qctx = struct();
qctx.fs = double(data.srate);
assert(isscalar(qctx.fs) && isfinite(qctx.fs) && qctx.fs>0);
qctx.n = size(data.lfp_1,2);
assert(size(data.lfp_2,2)==qctx.n && size(data.lfp_3,2)==qctx.n, ...
    'LFP recordings must share a time axis.');
qctx.duration = qctx.n/qctx.fs; % samples represent [0,T)
qctx.ids = double(data.waveform_cluster(:));
qctx.area = double(data.waveform_area(:));
assert(numel(unique(qctx.ids))==numel(qctx.ids),'Duplicate cluster IDs.');
assert(numel(qctx.area)==numel(qctx.ids) && all(ismember(qctx.area,1:3)));
assert(size(data.waveform,1)==numel(qctx.ids),'Waveform rows must match IDs.');
qst = double(data.spike_timestamp(:)); qsc = double(data.spike_cluster(:));
assert(numel(qst)==numel(qsc));
[qknown,qunit] = ismember(qsc,qctx.ids);
qvalid = qknown & isfinite(qst) & qst>=0 & qst<qctx.duration;
qctx.excluded_spikes = sum(~qvalid);
qctx.spikes = cell(numel(qctx.ids),1);
for qi = 1:numel(qctx.ids), qctx.spikes{qi} = sort(qst(qvalid & qunit==qi)); end
qctx.rate = cellfun(@numel,qctx.spikes)/qctx.duration;
qctx.labels = {'Area 1';'Area 2';'Area 3'};
qctx.config = qcfg;
qctx.provenance = struct('duration_seconds',qctx.duration,'lfp_samples',qctx.n, ...
    'lfp_srate',qctx.fs,'cluster_ids',qctx.ids,'excluded_spikes',qctx.excluded_spikes);
if isfield(data,'source'), qctx.provenance.source=data.source; end
if isfield(data,'trial_columns'), qctx.provenance.trial_columns=data.trial_columns; end
if ~isempty(qcfg.trial_columns), qctx.provenance.trial_columns=qcfg.trial_columns; end
% Function handles keep entry points scripts with local functions.
qutil = struct('summary',@summarize,'bins',@spike_bins,'trials',@trial_times, ...
    'features',@trial_features,'decode',@decode_trials,'waveform',@waveform_class);
clear qst qsc qknown qunit qvalid qi qnames qdefaults

function out = summarize(values,labels,units,method,cfg)
    n = numel(values); mu = nan(n,1); ci = nan(n,2); count = zeros(n,1);
    stream = RandStream('mt19937ar','Seed',cfg.seed);
    for k=1:n
        x=values{k}(:); x=x(isfinite(x)); count(k)=numel(x);
        if isempty(x), continue; end
        mu(k)=mean(x);
        if numel(x)<2, continue; end
        boot=mean(x(randi(stream,numel(x),numel(x),cfg.bootstrap)),1);
        boot=sort(boot); ci(k,:)=boot(max(1,ceil([.025 .975]*numel(boot))));
    end
    out=struct('summary',table(labels(:),mu,ci(:,1),ci(:,2),count, ...
        'VariableNames',{'group','mean','ci95_low','ci95_high','n'}), ...
        'values',{values},'units',units,'method',method,'config',cfg, ...
        'scope','Single loaded recording; descriptive resampling CI, not across-animal inference', ...
        'answer','Pending across-animal paired analysis and diagnostic review');
end

function counts = spike_bins(spikes,edges)
    counts=zeros(numel(edges)-1,numel(spikes));
    for u=1:numel(spikes)
        t=spikes{u}; t=t(t>=edges(1) & t<edges(end));
        counts(:,u)=histcounts(t,edges)';
    end
end

function [t,labels,valid] = trial_times(data,cfg)
    % Explicit map avoids guessing whether column 1 is a spreadsheet index.
    c=cfg.trial_columns;
    if isempty(c) && isfield(data,'trial_columns'), c=data.trial_columns; end
    assert(isstruct(c),'Set qcfg.trial_columns (see README), or rerun updated a01_probing.');
    keys={'trial_start','stim_start','outcome','trial_end','A','C'};
    for k=1:numel(keys)
        assert(isfield(c,keys{k}),'Missing trial column: %s',keys{k});
        validateattributes(c.(keys{k}),{'numeric'},{'scalar','integer','positive','<=',size(data.trial,2)});
    end
    t=double(data.trial(:,[c.trial_start c.stim_start c.outcome c.trial_end]));
    labels=double(data.trial(:,[c.A c.C]));
    valid=all(isfinite(t),2) & all(diff(t,1,2)>0,2) & t(:,1)>=0 ...
        & t(:,4)<=size(data.lfp_1,2)/data.srate;
    % Overlap would double count observation time; reject affected trials.
    [~,order]=sort(t(:,1));
    for k=2:numel(order)
        if t(order(k),1)<t(order(k-1),4), valid(order(k-1:k))=false; end
    end
end

function x = trial_features(spikes,windows)
    x=nan(size(windows,1),numel(spikes));
    for k=1:size(windows,1)
        if any(~isfinite(windows(k,:))) || diff(windows(k,:))<=0, continue; end
        for u=1:numel(spikes)
            x(k,u)=sum(spikes{u}>=windows(k,1) & spikes{u}<windows(k,2))/diff(windows(k,:));
        end
    end
end

function [score,detail] = decode_trials(x,y,seed)
    % Five contiguous held-out folds; preprocessing learned on training only.
    % Fixed ridge one-vs-rest model, no tuned hyperparameters.
    keep=all(isfinite(x),2) & isfinite(y); x=x(keep,:); y=y(keep);
    classes=unique(y); n=numel(y); pred=nan(n,1); prob=nan(n,numel(classes));
    score=nan; detail=struct('observed',y,'predicted',pred,'probability',prob);
    if numel(classes)<2 || n<25 || isempty(x), return; end
    fold=min(5,ceil((1:n)'*5/n));
    for f=1:5
        test=fold==f; train=~test;
        if any(arrayfun(@(c)sum(y(train)==c)<2,classes)), continue; end
        mu=mean(x(train,:),1); sd=std(x(train,:),0,1); sd(sd==0)=1;
        a=[ones(sum(train),1) (x(train,:)-mu)./sd];
        b=[ones(sum(test),1) (x(test,:)-mu)./sd];
        target=double(y(train)==classes');
        penalty=eye(size(a,2)); penalty(1,1)=0;
        w=(a'*a+penalty)\(a'*target);
        z=b*w; z=exp(z-max(z,[],2)); z=z./sum(z,2);
        prob(test,:)=z; [~,ii]=max(z,[],2); pred(test)=classes(ii);
    end
    recalls=nan(numel(classes),1);
    for k=1:numel(classes)
        ix=y==classes(k) & isfinite(pred);
        if any(ix), recalls(k)=mean(pred(ix)==y(ix)); end
    end
    if all(isfinite(recalls)), score=mean(recalls); end
    detail=struct('observed',y,'predicted',pred,'probability',prob, ...
        'classes',classes,'fold',fold,'retained_rows',find(keep),'seed',seed);
end

function [narrow,width] = waveform_class(data,cfg)
    width=nan(size(data.waveform,1),1);
    for u=1:numel(width)
        w=double(data.waveform(u,:));
        if any(~isfinite(w)) || range(w)==0, continue; end
        w=w-mean(w(1:min(10,numel(w))));
        [trough,j]=min(w);
        if trough>=0 || j==1 || j>=numel(w)-1, continue; end
        [peak,k]=max(w(j+1:end));
        if peak<=0 || j+k==numel(w), continue; end
        width(u)=1000*k/cfg.waveform_srate;
    end
    narrow=nan(size(width)); ok=isfinite(width); narrow(ok)=double(width(ok)<cfg.narrow_ms);
end
