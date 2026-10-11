function [narrow,width] = waveform_class(data,cfg)
    width=nan(size(data.waveform,1),1);
    for u=1:numel(width)
        w=double(data.waveform(u,:));
        if any(~isfinite(w)) || range(w)==0, continue; end
        w=w-mean(w(1:min(10,numel(w))));
        [trough,j]=min(w);
        if trough>=0 || j==1 || j>=numel(w)-1, continue; end
        [peak,k]=max(w(j+1:end));
        if peak<=0 || j+k==numel(w), continue; end
        width(u)=1000*k/cfg.waveform_srate;
    end
    narrow=nan(size(width)); ok=isfinite(width); narrow(ok)=double(width(ok)<cfg.narrow_ms);
end
