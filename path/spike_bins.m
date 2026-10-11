function counts = spike_bins(spikes,edges)
    counts=zeros(numel(edges)-1,numel(spikes));
    for u=1:numel(spikes)
        counts(:,u)=spike_counts_edges(spikes{u},edges);
    end
end
