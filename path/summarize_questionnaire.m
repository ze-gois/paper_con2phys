function out = summarize_questionnaire(values,labels,units,method,cfg)
    n = numel(values); mu = nan(n,1); ci = nan(n,2); count = zeros(n,1);
    stream = RandStream('mt19937ar','Seed',cfg.seed);
    for k=1:n
        x=values{k}(:); x=x(isfinite(x)); count(k)=numel(x);
        if isempty(x), continue; end
        mu(k)=mean(x);
        if numel(x)<2, continue; end
        boot=mean(x(randi(stream,numel(x),numel(x),cfg.bootstrap)),1);
        boot=sort(boot); ci(k,:)=boot(max(1,ceil([.025 .975]*numel(boot))));
    end
    out=struct('summary',table(labels(:),mu,ci(:,1),ci(:,2),count, ...
        'VariableNames',{'group','mean','ci95_low','ci95_high','n'}), ...
        'values',{values},'units',units,'method',method,'config',cfg, ...
        'scope','Single loaded recording; descriptive resampling CI, not across-animal inference', ...
        'answer','Pending across-animal paired analysis and diagnostic review');
end
