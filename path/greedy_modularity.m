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
