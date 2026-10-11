function [template_id,similarity] = template_match_waveforms(waveforms,templates)
%TEMPLATE_MATCH_WAVEFORMS Cosine waveform-template similarities.
% Rows = detected waveforms/templates, columns = aligned samples.
% This is a primitive, not a full Rossant/Kilosort sorter.
x=double(waveforms); t=double(templates);
assert(ismatrix(x) && ismatrix(t) && size(x,2)==size(t,2));
assert(all(isfinite(x(:))) && all(isfinite(t(:))));
xn=sqrt(sum(x.^2,2)); tn=sqrt(sum(t.^2,2));
assert(all(xn>0) && all(tn>0),'Zero-norm waveform or template');
scores=(x*t')./(xn*tn');
[similarity,template_id]=max(scores,[],2);
end
