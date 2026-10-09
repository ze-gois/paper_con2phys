%% Q15: normalized LFP permutation entropy during stimulus-to-trial-end.
q00_prepare
[t,~,valid]=qutil.trials(data,qcfg); t=t(valid,:);
values=cell(3,1); per_channel=cell(3,1); delay=max(1,round(.01*qctx.fs));
for a=1:3
    field=sprintf('lfp_%d',a); v=nan(size(t,1),size(data.(field),1));
    for k=1:size(t,1)
        first=ceil(t(k,2)*qctx.fs)+1; last=min(qctx.n,ceil(t(k,4)*qctx.fs));
        for c=1:size(v,2)
            x=double(data.(field)(c,first:last));
            if numel(x)<100+2*delay || any(~isfinite(x)) || std(x)==0, continue; end
            x=detrend(x); patterns=[x(1:end-2*delay)' x(1+delay:end-delay)' x(1+2*delay:end)'];
            % Exclude tied patterns instead of arbitrary sort tie-breaking.
            ties=patterns(:,1)==patterns(:,2) | patterns(:,1)==patterns(:,3) | patterns(:,2)==patterns(:,3);
            patterns=patterns(~ties,:); if size(patterns,1)<100, continue; end
            [~,order]=sort(patterns,2); [~,~,id]=unique(order,'rows');
            p=accumarray(id,1)/numel(id); v(k,c)=-sum(p.*log(p))/log(6);
        end
    end
    per_channel{a}=v; values{a}=mean(v,2,'omitnan');
end
q15=qutil.summary(values,qctx.labels,'normalized permutation entropy [0,1]', ...
    'LFP order 3, delay 10 ms, linear detrending, no added band filter; channel mean per trial; trial bootstrap.',qcfg);
q15.channel_entropy=per_channel; q15.retained_trials=find(valid);
q15.limitations='High entropy can reflect measurement noise; not a direct measure of computational complexity. Check order, delay, trial duration and spectral sensitivity.';
q15.provenance=qctx.provenance;
disp(q15.summary)
