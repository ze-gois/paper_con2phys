%% Q1: lowest mean single-unit firing rate across the complete recording.
q00_prepare
values=cell(3,1);
for a=1:3, values{a}=qctx.rate(qctx.area==a); end
q01=qutil.summary(values,qctx.labels,'spikes/s/unit', ...
    'All mapped units, including silent units; unit bootstrap within recording.',qcfg);
q01.unit=table(qctx.ids,qctx.area,qctx.rate,'VariableNames',{'cluster','area','rate_hz'});
q01.excluded_spikes=qctx.excluded_spikes;
q01.provenance=qctx.provenance;
disp(q01.summary)
