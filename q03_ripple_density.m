%% Q03 - Densidade de eventos candidatos a ripple
q00_prepare

%% Parametros e preparacao da analise
assert(srate>400,'Candidate ripple band 120-200 Hz requires fs > 400.');
[bfilter,afilter]=butter(3,[120 200]/(srate/2));
valores=cell(3,1); eventos=cell(3,1); exposicao=zeros(3,1);
amostras_bloco=round(parametros.bloco_segundos*srate); inicios=1:amostras_bloco:numero_amostras-amostras_bloco+1;
for area=1:3
    campo=sprintf('lfp_%d',area); taxas=nan(numel(inicios),1); todos_eventos=[];
    for bloco=1:numel(inicios)
        % Margem de dois segundos; rejeita eventos nas bordas do bloco.
        inicio=inicios(bloco); fim=inicio+amostras_bloco-1;
        inicio_ampliado=max(1,inicio-round(2*srate)); fim_ampliado=min(numero_amostras,fim+round(2*srate));
        detectados=[]; canais_validos=0;
        for canal=1:size(data.(campo),1)
            sinal=double(data.(campo)(canal,inicio_ampliado:fim_ampliado));
            if any(~isfinite(sinal)) || std(sinal)==0, continue; end
            envelope=abs(hilbert(filtfilt(bfilter,afilter,sinal)));
            trecho=envelope(inicio-inicio_ampliado+1:fim-inicio_ampliado+1); mediana=median(trecho);
            escala=1.4826*median(abs(trecho-mediana));
            if escala<=0, continue; end
            canais_validos=canais_validos+1; z=(trecho-mediana)/escala;
            bordas=diff([false z>2 false]); inicio_evento=find(bordas==1); fim_evento=find(bordas==-1)-1;
            for evento=1:numel(inicio_evento)
                duracao_evento=(fim_evento(evento)-inicio_evento(evento)+1)/srate;
                if inicio_evento(evento)==1 || fim_evento(evento)==amostras_bloco || duracao_evento<.025 || duracao_evento>.15, continue; end
                if max(z(inicio_evento(evento):fim_evento(evento)))<5, continue; end
                detectados(end+1,:)=[(inicio+inicio_evento(evento)-2)/srate (inicio+fim_evento(evento)-1)/srate]; %#ok<SAGROW>
            end
        end
        if canais_validos==0, continue; end
        % Uniao dos canais: um evento compartilhado conta uma vez por area.
        unificados=[];
        if ~isempty(detectados)
            detectados=sortrows(detectados,1); unificados=detectados(1,:);
            for evento=2:size(detectados,1)
                if detectados(evento,1)<=unificados(end,2)+.02
                    unificados(end,2)=max(unificados(end,2),detectados(evento,2));
                else, unificados(end+1,:)=detectados(evento,:); end %#ok<SAGROW>
            end
        end
        taxas(bloco)=size(unificados,1)/(amostras_bloco/srate/60);
        todos_eventos=[todos_eventos;unificados]; %#ok<AGROW>
        exposicao(area)=exposicao(area)+amostras_bloco/srate;
    end
    valores{area}=taxas; eventos{area}=todos_eventos;
end
%% Resultados
q03=resumir_resultados(valores,nomes_areas,'candidate events/min', ...
    '120-200 Hz envelope, robust z onset 2/peak 5, 25-150 ms; 20 ms channel union; block bootstrap.',parametros);
q03.events_seconds=eventos; q03.exposure_seconds=exposicao;
q03.limitations='Candidate screen only: inspect sharp waves, artifacts, threshold sensitivity and channel-count bias before calling events hippocampal ripples.';
q03.provenance=procedencia;
disp(q03.summary)

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
