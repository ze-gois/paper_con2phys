%% Q09 - Razao entre waveforms largas e estreitas como proxy de E/I
q00_prepare

%% Parametros e preparacao da analise
[estreito,largura]=classificar_waveforms(data,parametros);
razao=nan(3,1); intervalo_confianca=nan(3,2); contagens=zeros(3,2); bootstrap_valido=zeros(3,1);
sorteio=RandStream('mt19937ar','Seed',parametros.semente);
for area=1:3
    classes_waveform=estreito(area_neuronio==area); classes_waveform=classes_waveform(isfinite(classes_waveform));
    contagens(area,:)=[sum(classes_waveform==0) sum(classes_waveform==1)];
    if contagens(area,2)==0, continue; end
    razao(area)=contagens(area,1)/contagens(area,2); numero_unidades=numel(classes_waveform);
    numero_estreitos=sum(classes_waveform(randi(sorteio,numero_unidades,numero_unidades,parametros.bootstrap)),1);
    razoes_nulas=(numero_unidades-numero_estreitos)./numero_estreitos; bootstrap_valido(area)=sum(isfinite(razoes_nulas)); razoes_nulas=sort(razoes_nulas);
    intervalo_confianca(area,:)=razoes_nulas(max(1,ceil([.025 .975]*numel(razoes_nulas)))); % preserva Inf quando o denominador e zero
end
%% Resultados
q09=struct('summary',table(nomes_areas,razao,intervalo_confianca(:,1),intervalo_confianca(:,2),contagens(:,1),contagens(:,2), ...
    'VariableNames',{'group','mean','ci95_low','ci95_high','broad_units','narrow_units'}), ...
    'units','broad/narrow unit count ratio','config',parametros,'finite_bootstrap_draws',bootstrap_valido, ...
    'answer','Not enough data to identify physiological excitation/inhibition', ...
    'method','Waveform count proxy only. No synaptic currents, connectivity signs or validated cell identities are available.');
q09.width_ms=largura;
q09.provenance=procedencia;
disp(q09.summary)

%% Funcoes locais
function [estreito,largura] = classificar_waveforms(data,opcoes)
    largura=nan(size(data.waveform,1),1);
    for u=1:numel(largura)
        w=double(data.waveform(u,:));
        if any(~isfinite(w)) || range(w)==0, continue; end
        w=w-mean(w(1:min(10,numel(w))));
        [vale,j]=min(w);
        if vale>=0 || j==1 || j>=numel(w)-1, continue; end
        [pico,k]=max(w(j+1:end));
        if pico<=0 || j+k==numel(w), continue; end
        largura(u)=1000*k/opcoes.srate_waveform;
    end
    estreito=nan(size(largura)); ok=isfinite(largura); estreito(ok)=double(largura(ok)<opcoes.limiar_largura_ms);
end
