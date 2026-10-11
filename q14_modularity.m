%% Q14: positive weighted spike-correlation network modularity.
q00_prepare
counts=spike_bins(qctx.spikes,0:.1:qctx.duration);
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
q14=summarize_questionnaire(values,qctx.labels,'weighted Newman-Girvan Q', ...
    '100 ms counts; fixed matched node subset; positive Pearson edges; greedy community merging per block; block bootstrap.',qcfg);
q14.selected_clusters=selected;
q14.limitations='Mean local block modularity across recording, not one static whole-session graph. Negative edges discarded; greedy result is a lower bound on maximum Q. Inspect node-count, resolution and null-network sensitivity.';
q14.provenance=qctx.provenance;
disp(q14.summary)
