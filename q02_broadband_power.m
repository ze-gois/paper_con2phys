%% Q2: integrated 1-100 Hz Welch power, equally weighting channels.
q00_prepare
assert(qctx.fs>200,'1-100 Hz requires Nyquist above 100 Hz.');
values=cell(3,1); channel_power=cell(3,1);
L=round(qcfg.block_seconds*qctx.fs); starts=1:L:qctx.n-L+1;
for a=1:3
    field=sprintf('lfp_%d',a); p=nan(numel(starts),size(data.(field),1));
    for b=1:numel(starts)
        for c=1:size(p,2)
            x=double(data.(field)(c,starts(b):starts(b)+L-1));
            if any(~isfinite(x)) || std(x)==0, continue; end
            win=min(round(4*qctx.fs),L);
            [psd,f]=pwelch(x-mean(x),hann(win),floor(win/2),max(win,2^nextpow2(win)),qctx.fs);
            ix=f>=1 & f<=100; p(b,c)=trapz(f(ix),psd(ix));
        end
    end
    channel_power{a}=p; values{a}=mean(p,2,'omitnan');
end
q02=qutil.summary(values,qctx.labels,'original LFP units squared', ...
    'Mean channel power per nonoverlapping block; block bootstrap; no rereferencing.',qcfg);
q02.channel_power=channel_power; q02.unused_tail_seconds=(qctx.n-numel(starts)*L)/qctx.fs;
q02.provenance=qctx.provenance;
disp(q02.summary)
