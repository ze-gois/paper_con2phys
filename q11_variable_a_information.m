%% Q11: held-out decoded information about A over the WHOLE trial (no ITI).
q00_prepare
[t,labels,valid]=qutil.trials(data,qcfg); labels(~valid,:)=nan;
stream=RandStream('mt19937ar','Seed',qcfg.seed);
m=min([qcfg.matched_units;arrayfun(@(a)sum(qctx.area==a),(1:3)')]);
assert(m>=1,'Each area needs at least one mapped unit.');
score=nan(3,1); ci=nan(3,2); null=nan(3,100); details=cell(3,1); selected=cell(3,1);
for a=1:3
    units=find(qctx.area==a); units=units(randperm(stream,numel(units),m)); selected{a}=qctx.ids(units);
    x=qutil.features(qctx.spikes(units),t(:,[1 4]));
    [~,d]=qutil.decode(x,labels(:,1),qcfg.seed); details{a}=d;
    y=d.observed; pred=d.predicted; ok=isfinite(pred); y=y(ok); pred=pred(ok);
    if numel(y)<25, continue; end
    score(a)=decoded_mi(y,pred); boot=nan(qcfg.bootstrap,1);
    for b=1:qcfg.bootstrap
        ix=randi(stream,numel(y),numel(y),1); boot(b)=decoded_mi(y(ix),pred(ix));
    end
    boot=sort(boot); ci(a,:)=boot(max(1,ceil([.025 .975]*numel(boot))));
    % Refit after circular label shifts to retain label autocorrelation.
    good=isfinite(labels(:,1)) & all(isfinite(x),2); yy=labels(good,1); xx=x(good,:);
    for b=1:100
        shifted=circshift(yy,randi(stream,numel(yy)-1));
        [~,dnull]=qutil.decode(xx,shifted,qcfg.seed);
        null(a,b)=decoded_mi(dnull.observed,dnull.predicted);
    end
end
q11=struct('summary',table(qctx.labels,score,ci(:,1),ci(:,2), ...
    'VariableNames',{'group','mean','ci95_low','ci95_high'}), ...
    'units','bits','config',qcfg,'decoding',{details},'selected_clusters',{selected}, ...
    'null_bits',null,'answer','Pending across-animal analysis and null comparison', ...
    'method','Whole-trial mean rate, matched unit count, blocked 5-fold ridge decoder; MI of held-out confusion matrix; conditional trial bootstrap CI.', ...
    'limitations','Decoded information proxy with finite-sample bias; whole-trial averaging may hide transient coding. CIs condition on fitted models; do not estimate full neural MI.');
q11.provenance=qctx.provenance;
disp(q11.summary)

function info=decoded_mi(y,pred)
    ok=isfinite(y) & isfinite(pred); y=y(ok); pred=pred(ok); info=nan;
    if isempty(y) || numel(unique(y))<2, return; end
    classes=unique([y;pred]); p=zeros(numel(classes));
    for i=1:numel(classes)
        for j=1:numel(classes), p(i,j)=mean(y==classes(i) & pred==classes(j)); end
    end
    independent=sum(p,2)*sum(p,1); nz=p>0;
    info=sum(p(nz).*log2(p(nz)./independent(nz)));
end
