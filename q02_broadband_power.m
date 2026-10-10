%% Q02 - Potencia do LFP entre 1 e 100 Hz
q00_prepare

%% Parametros e preparacao da analise
assert(srate>200,'1-100 Hz requires Nyquist above 100 Hz.');
valores=cell(3,1); potencia_canais=cell(3,1);
amostras_bloco=round(parametros.bloco_segundos*srate); inicios=1:amostras_bloco:numero_amostras-amostras_bloco+1;
for area=1:3
    campo=sprintf('lfp_%d',area); potencia_bloco=nan(numel(inicios),size(data.(campo),1));
    for bloco=1:numel(inicios)
        for canal=1:size(potencia_bloco,2)
            sinal=double(data.(campo)(canal,inicios(bloco):inicios(bloco)+amostras_bloco-1));
            if any(~isfinite(sinal)) || std(sinal)==0, continue; end
            janela_welch=min(round(4*srate),amostras_bloco);
            [densidade_espectral,frequencias]=pwelch(sinal-mean(sinal),hann(janela_welch),floor(janela_welch/2),max(janela_welch,2^nextpow2(janela_welch)),srate);
            indices_banda=frequencias>=1 & frequencias<=100; potencia_bloco(bloco,canal)=trapz(frequencias(indices_banda),densidade_espectral(indices_banda));
        end
    end
    potencia_canais{area}=potencia_bloco; valores{area}=mean(potencia_bloco,2,'omitnan');
end
%% Resultados
q02=resumir_resultados(valores,nomes_areas,'original LFP units squared', ...
    'Mean channel power per nonoverlapping block; block bootstrap; no rereferencing.',parametros);
q02.channel_power=potencia_canais; q02.unused_tail_seconds=(numero_amostras-numel(inicios)*amostras_bloco)/srate;
q02.provenance=procedencia;
disp(q02.summary)

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
