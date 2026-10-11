function info=decoded_mi(y,pred)
    ok=isfinite(y) & isfinite(pred); y=y(ok); pred=pred(ok); info=nan;
    if isempty(y) || numel(unique(y))<2, return; end
    classes=unique([y;pred]); p=zeros(numel(classes));
    for i=1:numel(classes)
        for j=1:numel(classes), p(i,j)=mean(y==classes(i) & pred==classes(j)); end
    end
    independent=sum(p,2)*sum(p,1); nz=p>0;
    info=sum(p(nz).*log2(p(nz)./independent(nz)));
end
