%% Q7: proportion of recorded units with narrow putative interneuron waveforms.
q00_prepare
[narrow,width]=qutil.waveform(data,qcfg); values=cell(3,1);
for a=1:3, values{a}=narrow(qctx.area==a); end
q07=qutil.summary(values,qctx.labels,'fraction of classifiable recorded units', ...
    'Negative-trough to following positive peak <0.4 ms at 30 kHz; unit bootstrap.',qcfg);
q07.unit=table(qctx.ids,qctx.area,width,narrow,qctx.rate, ...
    'VariableNames',{'cluster','area','trough_peak_ms','putative_narrow','rate_hz'});
q07.limitations='Waveform class is not validated cell identity or anatomical cell density; invalid waveforms excluded.';
q07.provenance=qctx.provenance;
disp(q07.summary)
