%% Q5: population spike-count correlation between areas, 100 ms.
q00_prepare
counts=qutil.bins(qctx.spikes,0:.1:qctx.duration); pop=nan(size(counts,1),3);
for a=1:3, pop(:,a)=mean(counts(:,qctx.area==a),2); end
pairs=[1 2;1 3;2 3]; values=cell(3,1); L=round(qcfg.block_seconds/.1);
for p=1:3
    v=[];
    for first=1:L:size(pop,1)-L+1
        x=pop(first:first+L-1,pairs(p,:));
        if any(~isfinite(x(:))) || any(std(x)==0), v(end+1,1)=nan; continue; end
        r=corrcoef(x); v(end+1,1)=abs(r(1,2));
    end
    values{p}=v;
end
q05=qutil.summary(values,{'Area 1 <-> 2';'Area 1 <-> 3';'Area 2 <-> 3'}, ...
    'absolute Pearson r','100 ms mean population counts; nonoverlapping block bootstrap.',qcfg);
q05.limitations='Undirected association, sensitive to common task drive and unequal unit counts.';
q05.provenance=qctx.provenance;
disp(q05.summary)
