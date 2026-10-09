%% Q13: covariance participation ratio during stimulus-to-outcome.
q00_prepare
[t,~,valid]=qutil.trials(data,qcfg); t=t(valid,:);
stream=RandStream('mt19937ar','Seed',qcfg.seed);
m=min([qcfg.matched_units;arrayfun(@(a)sum(qctx.area==a),(1:3)')]);
assert(m>=2,'Dimensionality requires >=2 units per area.');
point=nan(3,1); ci=nan(3,2); repeats=cell(3,1); retained=zeros(3,1);
for a=1:3
    units=find(qctx.area==a); trials=cell(size(t,1),1);
    for k=1:size(t,1)
        edges=t(k,2):.1:t(k,3);
        if numel(edges)>=3, trials{k}=qutil.bins(qctx.spikes(units),edges); end
    end
    trials=trials(~cellfun(@isempty,trials)); retained(a)=numel(trials);
    if numel(trials)<2, continue; end
    allx=vertcat(trials{:}); subs=nan(100,1);
    for b=1:100
        cols=randperm(stream,numel(units),m); subs(b)=participation(allx(:,cols));
    end
    point(a)=mean(subs,'omitnan'); boot=nan(qcfg.bootstrap,1);
    for b=1:qcfg.bootstrap
        ix=randi(stream,numel(trials),numel(trials),1);
        x=vertcat(trials{ix}); cols=randperm(stream,numel(units),m);
        boot(b)=participation(x(:,cols));
    end
    repeats{a}=boot; boot=sort(boot(isfinite(boot)));
    if numel(boot)>=2, ci(a,:)=boot(max(1,ceil([.025 .975]*numel(boot)))); end
end
q13=struct('summary',table(qctx.labels,point,ci(:,1),ci(:,2),retained, ...
    'VariableNames',{'group','mean','ci95_low','ci95_high','trials'}), ...
    'units','effective dimensions','config',qcfg,'matched_units',m,'bootstrap',{repeats}, ...
    'method','100 ms counts within stim-outcome only; covariance PR=(trace C)^2/trace(C^2); matched unit subsampling and trial bootstrap.', ...
    'answer','Pending across-animal comparison','limitations','CI includes random unit-subset variability. Raw covariance weights high-variance units; task and noise both contribute.');
q13.provenance=qctx.provenance;
disp(q13.summary)

function d=participation(x)
    d=nan; if size(x,1)<3, return; end
    c=cov(x); denom=sum(c(:).^2);
    if denom>0, d=trace(c)^2/denom; end
end
