function [imfs,residual] = empirical_mode_decomposition(signal,max_imfs,max_sifts,tolerance)
%EMPIRICAL_MODE_DECOMPOSITION Exploratory Huang et al. (1998) EMD sifting.
% PCHIP envelope interpolation with endpoint anchoring; NOT a reference-grade
% boundary treatment or standardized S-number stopping criterion.
% Analyze bounded input segments, not millions of samples in one call.
if nargin<2 || isempty(max_imfs), max_imfs=5; end
if nargin<3 || isempty(max_sifts), max_sifts=40; end
if nargin<4 || isempty(tolerance), tolerance=.05; end
x=double(signal(:)); n=numel(x);
assert(n>=16 && all(isfinite(x)) && max_imfs>=1 && max_sifts>=1);
assert(tolerance>0 && tolerance<1);
imfs=zeros(n,0); residual=x;
t=(1:n)';
for k=1:max_imfs
    h=residual;
    maxima=find(diff(sign(diff(h)))<0)+1;
    minima=find(diff(sign(diff(h)))>0)+1;
    if numel(maxima)<2 || numel(minima)<2, break; end
    for iter=1:max_sifts
        maxima=find(diff(sign(diff(h)))<0)+1;
        minima=find(diff(sign(diff(h)))>0)+1;
        if numel(maxima)<2 || numel(minima)<2, break; end
        hi=[1;maxima(:);n]; lo=[1;minima(:);n];
        upper=interp1(hi,h(hi),t,'pchip');
        lower=interp1(lo,h(lo),t,'pchip');
        next=h-(upper+lower)/2;
        criterion=sum((next-h).^2)/max(sum(h.^2),eps);
        h=next;
        if criterion<tolerance, break; end
    end
    imfs(:,end+1)=h; %#ok<AGROW>
    residual=residual-h;
end
end
