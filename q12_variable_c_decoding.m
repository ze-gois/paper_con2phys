%% Q12: compare C decoding in three trial segments using identical trial folds.
q00_prepare
[t,labels,valid]=qutil.trials(data,qcfg);
valid=valid & isfinite(labels(:,2)); t=t(valid,:); y=labels(valid,2);
assert(all(ismember(unique(y),[1 2 3])),'Variable C must be categorical 1-3.');
score=nan(3,1); ci=nan(3,2); detail=cell(3,1); null=nan(3,100);
stream=RandStream('mt19937ar','Seed',qcfg.seed);
for segment=1:3
    x=qutil.features(qctx.spikes,t(:,segment:segment+1));
    [score(segment),d]=qutil.decode(x,y,qcfg.seed); detail{segment}=d;
    if ~isfinite(score(segment)), continue; end
    boot=nan(qcfg.bootstrap,1); classes=unique(y);
    for b=1:qcfg.bootstrap
        recall=nan(numel(classes),1);
        for k=1:numel(classes)
            ix=find(d.observed==classes(k) & isfinite(d.predicted));
            if isempty(ix), continue; end
            take=ix(randi(stream,numel(ix),numel(ix),1));
            recall(k)=mean(d.predicted(take)==d.observed(take));
        end
        boot(b)=mean(recall);
    end
    boot=sort(boot); ci(segment,:)=boot(max(1,ceil([.025 .975]*numel(boot))));
    for b=1:100
        yy=circshift(y,randi(stream,numel(y)-1));
        null(segment,b)=qutil.decode(x,yy,qcfg.seed);
    end
end
q12=struct('summary',table({'Trial start -> Stim';'Stim -> Outcome';'Outcome -> End'}, ...
    score,ci(:,1),ci(:,2),'VariableNames',{'group','mean','ci95_low','ci95_high'}), ...
    'units','balanced accuracy','config',qcfg,'decoding',{detail},'null_accuracy',null, ...
    'method','All units, segment mean rates, identical contiguous 5-fold splits, training-only standardization, fixed ridge decoder; stratified held-out bootstrap.', ...
    'answer','Pending paired segment contrasts across animals', ...
    'limitations','Variable segment duration changes count precision; duration-matched sensitivity needed. CI conditions on fitted models.');
q12.retained_trials=find(valid);
q12.provenance=qctx.provenance;
disp(q12.summary)
