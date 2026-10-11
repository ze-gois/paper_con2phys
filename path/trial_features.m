function x = trial_features(spikes,windows)
    x=nan(size(windows,1),numel(spikes));
    for k=1:size(windows,1)
        if any(~isfinite(windows(k,:))) || diff(windows(k,:))<=0, continue; end
        for u=1:numel(spikes)
            x(k,u)=sum(spikes{u}>=windows(k,1) & spikes{u}<windows(k,2))/diff(windows(k,:));
        end
    end
end
