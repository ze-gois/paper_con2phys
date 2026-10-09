%% Q10: baseline spike-count autocorrelation decay across repeated trials.
q00_prepare
[t,~,valid]=qutil.trials(data,qcfg); baseline=[t(:,1)-1 t(:,1)];
valid=valid & baseline(:,1)>=0;
% Require a full one-second intertrial baseline, with no preceding trial overlap.
for k=1:size(t,1)
    overlap=t(:,4)>baseline(k,1) & t(:,1)<baseline(k,2);
    overlap(k)=false; valid(k)=valid(k) & ~any(overlap);
end
baseline=baseline(valid,:); tau=nan(numel(qctx.ids),1); fit_r2=tau;
acf=nan(numel(qctx.ids),10); lags=(1:10)'*.05;
for u=1:numel(qctx.ids)
    if size(baseline,1)<20, continue; end
    x=zeros(size(baseline,1),20);
    for k=1:size(baseline,1)
        edges=linspace(baseline(k,1),baseline(k,2),21);
        x(k,:)=qutil.bins(qctx.spikes(u),edges)';
    end
    % Correlate matching positions across trials; never concatenate baselines.
    for lag=1:10
        r=[];
        for j=1:20-lag
            a=x(:,j); b=x(:,j+lag);
            if std(a)>0 && std(b)>0
                z=corrcoef(a,b); r(end+1)=z(1,2);
            end
        end
        if ~isempty(r), acf(u,lag)=mean(r); end
    end
    y=acf(u,:)'; good=isfinite(y);
    if sum(good)<6 || max(y(good))<=0, continue; end
    time=lags(good); y=y(good);
    % Positive amplitude and tau; a free offset allows a long-lived component.
    loss=@(p)sum((y-(exp(p(1))*exp(-time/exp(p(2)))+p(3))).^2);
    p=fminsearch(loss,[log(max(y)-min(y)+eps) log(.15) min(y)], ...
        optimset('Display','off','MaxIter',1000));
    candidate=exp(p(2)); r2=1-loss(p)/max(sum((y-mean(y)).^2),eps);
    fit_r2(u)=r2;
    if candidate>=.025 && candidate<=1 && r2>=.5, tau(u)=candidate; end
end
values=cell(3,1); for a=1:3, values{a}=tau(qctx.area==a); end
q10=qutil.summary(values,qctx.labels,'seconds', ...
    '1 s pretrial nonoverlapping ITI baseline; across-trial 50 ms count correlations; A exp(-lag/tau)+C; unit bootstrap.',qcfg);
q10.unit=table(qctx.ids,qctx.area,tau,fit_r2,'VariableNames',{'cluster','area','tau_seconds','r2'});
q10.acf=acf; q10.lag_seconds=lags; q10.baseline_windows=baseline;
q10.fit_criteria='>=20 baseline trials, >=6 finite lags, positive A, tau 25-1000 ms, R2 >=0.5; accepted-fit selection bias possible.';
q10.provenance=qctx.provenance;
disp(q10.summary)
