%% Q8: spike-LFP 4-10 Hz pairwise phase consistency (PPC).
q00_prepare
[bfilter,afilter]=butter(3,[4 10]/(qctx.fs/2));
ppc=nan(numel(qctx.ids),1); spike_n=zeros(numel(qctx.ids),1);
% Fixed channel per area avoids selecting the strongest result post hoc.
for a=1:3
    field=sprintf('lfp_%d',a); c=qcfg.lfp_channels(a);
    assert(c>=1 && c<=size(data.(field),1));
    x=double(data.(field)(c,:));
    if any(~isfinite(x)) || std(x)==0, continue; end
    analytic=hilbert(filtfilt(bfilter,afilter,x));
    for u=find(qctx.area==a)'
        t=qctx.spikes{u}; t=t(t>=2 & t<qctx.duration-2);
        z=interp1((0:qctx.n-1)/qctx.fs,analytic,t,'linear');
        z=z(isfinite(z) & abs(z)>0); z=z./abs(z); n=numel(z); spike_n(u)=n;
        if n>=qcfg.minimum_spikes, ppc(u)=(abs(sum(z))^2-n)/(n*(n-1)); end
    end
end
values=cell(3,1); for a=1:3, values{a}=ppc(qctx.area==a); end
q08=qutil.summary(values,qctx.labels,'PPC (dimensionless)', ...
    '4-10 Hz zero-phase filter; complex interpolation; discard 2 s edges; >=50 spikes/unit; unit bootstrap.',qcfg);
q08.unit=table(qctx.ids,qctx.area,spike_n,ppc,'VariableNames',{'cluster','area','spikes','ppc'});
q08.limitations='Reference-channel choice and spike dependence matter; inspect channel sensitivity and surrogate locking.';
q08.provenance=qctx.provenance;
disp(q08.summary)
