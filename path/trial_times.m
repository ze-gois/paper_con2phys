function [t,labels,valid] = trial_times(data,cfg)
    % Explicit map avoids guessing whether column 1 is a spreadsheet index.
    c=cfg.trial_columns;
    if isempty(c) && isfield(data,'trial_columns'), c=data.trial_columns; end
    assert(isstruct(c),'Set qcfg.trial_columns (see README), or rerun updated a01_probing.');
    keys={'trial_start','stim_start','outcome','trial_end','A','C'};
    for k=1:numel(keys)
        assert(isfield(c,keys{k}),'Missing trial column: %s',keys{k});
        validateattributes(c.(keys{k}),{'numeric'},{'scalar','integer','positive','<=',size(data.trial,2)});
    end
    t=double(data.trial(:,[c.trial_start c.stim_start c.outcome c.trial_end]));
    labels=double(data.trial(:,[c.A c.C]));
    valid=all(isfinite(t),2) & all(diff(t,1,2)>0,2) & t(:,1)>=0 ...
        & t(:,4)<=size(data.lfp_1,2)/data.srate;
    % Overlap would double count observation time; reject affected trials.
    [~,order]=sort(t(:,1));
    for k=2:numel(order)
        if t(order(k),1)<t(order(k-1),4), valid(order(k-1:k))=false; end
    end
end
