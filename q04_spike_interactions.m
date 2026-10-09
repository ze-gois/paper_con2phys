%% Q4: magnitude of pairwise Pearson spike-count correlation at 100 ms.
q00_prepare
counts=qutil.bins(qctx.spikes,0:.1:qctx.duration);
values=cell(3,1); signed=cell(3,1); L=round(qcfg.block_seconds/.1);
for a=1:3
    units=find(qctx.area==a); v=[]; s=[];
    for first=1:L:size(counts,1)-L+1
        x=counts(first:first+L-1,units); x=x(:,std(x,0,1)>0);
        if size(x,2)<2, v(end+1,1)=nan; s(end+1,1)=nan; continue; end
        r=corrcoef(x); r=r(triu(true(size(r)),1));
        v(end+1,1)=mean(abs(r)); s(end+1,1)=mean(r);
    end
    values{a}=v; signed{a}=s;
end
q04=qutil.summary(values,qctx.labels,'absolute Pearson r', ...
    '100 ms nonoverlapping counts, mean absolute pair correlation per block; block bootstrap.',qcfg);
q04.signed_block_mean=signed;
q04.limitations='Shared rate modulation and task drive can induce correlation; not a synaptic interaction estimate.';
q04.provenance=qctx.provenance;
disp(q04.summary)
