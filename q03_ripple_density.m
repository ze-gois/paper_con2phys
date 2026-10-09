%% Q3: candidate ripple density, NOT anatomical identification of SWRs.
q00_prepare
assert(qctx.fs>400,'Candidate ripple band 120-200 Hz requires fs > 400.');
[bfilter,afilter]=butter(3,[120 200]/(qctx.fs/2));
values=cell(3,1); events=cell(3,1); exposure=zeros(3,1);
L=round(qcfg.block_seconds*qctx.fs); starts=1:L:qctx.n-L+1;
for a=1:3
    field=sprintf('lfp_%d',a); rates=nan(numel(starts),1); all_events=[];
    for b=1:numel(starts)
        % Two-second padding; do not count events touching the block boundary.
        first=starts(b); last=first+L-1;
        lo=max(1,first-round(2*qctx.fs)); hi=min(qctx.n,last+round(2*qctx.fs));
        detected=[]; usable=0;
        for c=1:size(data.(field),1)
            x=double(data.(field)(c,lo:hi));
            if any(~isfinite(x)) || std(x)==0, continue; end
            env=abs(hilbert(filtfilt(bfilter,afilter,x)));
            core=env(first-lo+1:last-lo+1); med=median(core);
            scale=1.4826*median(abs(core-med));
            if scale<=0, continue; end
            usable=usable+1; z=(core-med)/scale;
            edges=diff([false z>2 false]); on=find(edges==1); off=find(edges==-1)-1;
            for e=1:numel(on)
                duration=(off(e)-on(e)+1)/qctx.fs;
                if on(e)==1 || off(e)==L || duration<.025 || duration>.15, continue; end
                if max(z(on(e):off(e)))<5, continue; end
                detected(end+1,:)=[(first+on(e)-2)/qctx.fs (first+off(e)-1)/qctx.fs]; %#ok<SAGROW>
            end
        end
        if usable==0, continue; end
        % Union across channels: a shared event counts once per area.
        merged=[];
        if ~isempty(detected)
            detected=sortrows(detected,1); merged=detected(1,:);
            for e=2:size(detected,1)
                if detected(e,1)<=merged(end,2)+.02
                    merged(end,2)=max(merged(end,2),detected(e,2));
                else, merged(end+1,:)=detected(e,:); end %#ok<SAGROW>
            end
        end
        rates(b)=size(merged,1)/(L/qctx.fs/60);
        all_events=[all_events;merged]; %#ok<AGROW>
        exposure(a)=exposure(a)+L/qctx.fs;
    end
    values{a}=rates; events{a}=all_events;
end
q03=qutil.summary(values,qctx.labels,'candidate events/min', ...
    '120-200 Hz envelope, robust z onset 2/peak 5, 25-150 ms; 20 ms channel union; block bootstrap.',qcfg);
q03.events_seconds=events; q03.exposure_seconds=exposure;
q03.limitations='Candidate screen only: inspect sharp waves, artifacts, threshold sensitivity and channel-count bias before calling events hippocampal ripples.';
q03.provenance=qctx.provenance;
disp(q03.summary)
