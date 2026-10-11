function d=participation(x)
    d=nan; if size(x,1)<3, return; end
    c=cov(x); denom=sum(c(:).^2);
    if denom>0, d=trace(c)^2/denom; end
end
