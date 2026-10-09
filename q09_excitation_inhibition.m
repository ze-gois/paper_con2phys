%% Q9: broad/narrow waveform COUNT ratio, explicitly an E/I proxy.
q00_prepare
[narrow,width]=qutil.waveform(data,qcfg);
ratio=nan(3,1); ci=nan(3,2); counts=zeros(3,2); valid_boot=zeros(3,1);
stream=RandStream('mt19937ar','Seed',qcfg.seed);
for a=1:3
    x=narrow(qctx.area==a); x=x(isfinite(x));
    counts(a,:)=[sum(x==0) sum(x==1)];
    if counts(a,2)==0, continue; end
    ratio(a)=counts(a,1)/counts(a,2); n=numel(x);
    b=sum(x(randi(stream,n,n,qcfg.bootstrap)),1);
    r=(n-b)./b; valid_boot(a)=sum(isfinite(r)); r=sort(r);
    ci(a,:)=r(max(1,ceil([.025 .975]*numel(r)))); % retain Inf for zero denominators
end
q09=struct('summary',table(qctx.labels,ratio,ci(:,1),ci(:,2),counts(:,1),counts(:,2), ...
    'VariableNames',{'group','mean','ci95_low','ci95_high','broad_units','narrow_units'}), ...
    'units','broad/narrow unit count ratio','config',qcfg,'finite_bootstrap_draws',valid_boot, ...
    'answer','Not enough data to identify physiological excitation/inhibition', ...
    'method','Waveform count proxy only. No synaptic currents, connectivity signs or validated cell identities are available.');
q09.width_ms=width;
q09.provenance=qctx.provenance;
disp(q09.summary)
