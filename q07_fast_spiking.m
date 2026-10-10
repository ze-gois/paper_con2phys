%% Q07 - Fracao de unidades com waveform estreita e diagnosticos de ISI
q00_prepare

%% Parametros e preparacao da analise
[estreito,largura]=classificar_waveforms(data,parametros); valores=cell(3,1);
for area=1:3, valores{area}=estreito(area_neuronio==area); end
%% Resultados
q07=resumir_resultados(valores,nomes_areas,'fraction of classifiable recorded units', ...
    'Negative-trough to following positive peak <0.4 ms at 30 kHz; unit bootstrap.',parametros);
q07.unit=table(cluster_id,area_neuronio,largura,estreito,taxa_disparo, ...
    'VariableNames',{'cluster','area','trough_peak_ms','putative_narrow','rate_hz'});
q07.limitations='Waveform class is not validated cell identity or anatomical cell density; invalid waveforms excluded.';
q07.provenance=procedencia;
disp(q07.summary)

%% Diagnosticos do trem de disparos, sem inferir tipo celular pelo agrupamento
cv_isi=nan(numel(cluster_id),1); fracao_refrataria=cv_isi;
for neuronio=1:numel(cluster_id)
    isi=diff(spkt{neuronio});
    if numel(isi)>=2 && mean(isi)>0
        cv_isi(neuronio)=std(isi)/mean(isi);
        fracao_refrataria(neuronio)=mean(isi<.002);
    end
end
q07.unit.cv_isi=cv_isi;
q07.unit.fraction_isi_below_2ms=fracao_refrataria;
% Violacoes refratarias sao diagnosticos; nao excluem unidades automaticamente.

%% Funcoes locais
function resultado = resumir_resultados(valores,rotulos,unidade_medida,metodo,opcoes)
    n = numel(valores); media = nan(n,1); intervalo_confianca = nan(n,2); quantidade = zeros(n,1);
    sorteio = RandStream('mt19937ar','Seed',opcoes.semente);
    for k=1:n
        x=valores{k}(:); x=x(isfinite(x)); quantidade(k)=numel(x);
        if isempty(x), continue; end
        media(k)=mean(x);
        if numel(x)<2, continue; end
        reamostras=mean(x(randi(sorteio,numel(x),numel(x),opcoes.bootstrap)),1);
        reamostras=sort(reamostras); intervalo_confianca(k,:)=reamostras(max(1,ceil([.025 .975]*numel(reamostras))));
    end
    resultado=struct('summary',table(rotulos(:),media,intervalo_confianca(:,1),intervalo_confianca(:,2),quantidade, ...
        'VariableNames',{'group','mean','ci95_low','ci95_high','n'}), ...
        'values',{valores},'units',unidade_medida,'method',metodo,'config',opcoes, ...
        'scope','Single loaded recording; descriptive resampling CI, not across-animal inference', ...
        'answer','Pending across-animal paired analysis and diagnostic review');
end

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
