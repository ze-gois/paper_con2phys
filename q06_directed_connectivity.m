%% Q6: conditional time-domain Granger proxy from population spike counts.
q00_prepare
counts=qutil.bins(qctx.spikes,0:.02:qctx.duration); pop=nan(size(counts,1),3);
for a=1:3, pop(:,a)=mean(counts(:,qctx.area==a),2); end
pairs=[1 2;3 2;3 1]; values=cell(3,1); order=5; L=round(qcfg.block_seconds/.02);
for p=1:3
    v=[];
    for first=1:L:size(pop,1)-L+1
        x=pop(first:first+L-1,:);
        if any(~isfinite(x(:))) || any(std(x)==0), v(end+1,1)=nan; continue; end
        x=detrend(x); x=x./std(x); n=size(x,1);
        design=ones(n-order,1); source_columns=[];
        for lag=1:order
            source_columns(end+1)=size(design,2)+pairs(p,1);
            design=[design x(order+1-lag:n-lag,:)]; %#ok<AGROW>
        end
        y=x(order+1:end,pairs(p,2)); reduced=design;
        reduced(:,source_columns)=[];
        if rank(design)<size(design,2), v(end+1,1)=nan; continue; end
        full_residual=y-design*(design\y); reduced_residual=y-reduced*(reduced\y);
        vf=mean(full_residual.^2); vr=mean(reduced_residual.^2);
        if vf<=eps || vr<=eps, v(end+1,1)=nan; else, v(end+1,1)=log(vr/vf); end
    end
    values{p}=v;
end
q06=qutil.summary(values,{'Area 1 -> 2';'Area 3 -> 2';'Area 3 -> 1'}, ...
    'log residual variance ratio','20 ms counts, fixed VAR order 5 (100 ms), conditional on all three areas; block bootstrap.',qcfg);
q06.limitations='Exploratory in-sample predictability, positively biased; requires stationarity, residual and lag sensitivity checks; not causal evidence.';
q06.provenance=qctx.provenance;
disp(q06.summary)
