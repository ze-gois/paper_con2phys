%% Q14: positive weighted spike-correlation network modularity.
q00_prepare
counts=qutil.bins(qctx.spikes,0:.1:qctx.duration);
stream=RandStream('mt19937ar','Seed',qcfg.seed);
m=min([qcfg.matched_units;arrayfun(@(a)sum(qctx.area==a),(1:3)')]);
assert(m>=3,'Modularity requires >=3 units per area.');
L=round(qcfg.block_seconds/.1); values=cell(3,1); selected=cell(3,1);
for a=1:3
    units=find(qctx.area==a); units=units(randperm(stream,numel(units),m)); selected{a}=qctx.ids(units);
    v=[];
    for first=1:L:size(counts,1)-L+1
        x=counts(first:first+L-1,units);
        % Keep the matched network size: exclude blocks with silent nodes.
        if any(std(x)==0), v(end+1,1)=nan; continue; end
        w=max(corrcoef(x),0); w(1:m+1:end)=0;
        v(end+1,1)=greedy_modularity(w);
    end
    values{a}=v;
end
q14=qutil.summary(values,qctx.labels,'weighted Newman-Girvan Q', ...
    '100 ms counts; fixed matched node subset; positive Pearson edges; greedy community merging per block; block bootstrap.',qcfg);
q14.selected_clusters=selected;
q14.limitations='Mean local block modularity across recording, not one static whole-session graph. Negative edges discarded; greedy result is a lower bound on maximum Q. Inspect node-count, resolution and null-network sensitivity.';
q14.provenance=qctx.provenance;
disp(q14.summary)

function best=greedy_modularity(w)
    s=sum(w(:)); best=nan; if s<=0, return; end
    k=sum(w,2); b=w-k*k'/s; group=1:size(w,1);
    best=sum(diag(b))/s;
    while true
        labels=unique(group); gain=0; pair=[];
        for i=1:numel(labels)
            for j=i+1:numel(labels)
                delta=2*sum(sum(b(group==labels(i),group==labels(j))))/s;
                if delta>gain+1e-12, gain=delta; pair=[labels(i) labels(j)]; end
            end
        end
        if isempty(pair), break; end
        group(group==pair(2))=pair(1); best=best+gain;
    end
end
