%% Q05 - Conectividade nao direcionada: coerencia LFP e correlacao de spikes
q00_prepare

%% Parametros e preparacao da analise
contagens=contar_spikes(spkt,0:.1:duracao); atividade_populacional=nan(size(contagens,1),3);
for area=1:3, atividade_populacional(:,area)=mean(contagens(:,area_neuronio==area),2); end
pares_areas=[1 2;1 3;2 3]; valores=cell(3,1); bins_bloco=round(parametros.bloco_segundos/.1);
for par=1:3
    valores_bloco=[];
    for inicio=1:bins_bloco:size(atividade_populacional,1)-bins_bloco+1
        contagens_bloco=atividade_populacional(inicio:inicio+bins_bloco-1,pares_areas(par,:));
        if any(~isfinite(contagens_bloco(:))) || any(std(contagens_bloco)==0), valores_bloco(end+1,1)=nan; continue; end
        correlacao=corrcoef(contagens_bloco); valores_bloco(end+1,1)=abs(correlacao(1,2));
    end
    valores{par}=valores_bloco;
end
%% Resultados
q05=resumir_resultados(valores,{'Area 1 <-> 2';'Area 1 <-> 3';'Area 2 <-> 3'}, ...
    'absolute Pearson r','100 ms mean population counts; nonoverlapping block bootstrap.',parametros);
q05.limitations='Undirected association, sensitive to common task drive and unequal unit counts.';
q05.provenance=procedencia;

%% Coerencia LFP entre areas: estimativa principal de Q5
% Tres canais igualmente espacados por area, escolhidos antes dos resultados.
% Media dos nove pares de canais e de blocos de mesma duracao.
q05.correlacao_spikes = q05.summary;
q05.correlacao_spikes_valores = q05.values;
janela_segundos = 4;
banda_hz = [1 100];
assert(srate>2*banda_hz(2));
janela = hann(round(janela_segundos*srate));
sobreposicao = floor(numel(janela)/2);
nfft = 2^nextpow2(numel(janela));
amostras_bloco = round(parametros.bloco_segundos*srate);
assert(amostras_bloco>=2*numel(janela),'Coerencia requer multiplas janelas por bloco.');
inicios = 1:amostras_bloco:numero_amostras-amostras_bloco+1;
canais_area = cell(3,1);
for area=1:3
    campo=sprintf('lfp_%d',area);
    canais_area{area}=unique(round(linspace(1,size(data.(campo),1),min(3,size(data.(campo),1)))));
end
espectros = cell(3,1); valores_coerencia = cell(3,1); pares_validos=cell(3,1);
for par=1:3
    campo1=sprintf('lfp_%d',pares_areas(par,1)); campo2=sprintf('lfp_%d',pares_areas(par,2));
    matriz_coerencia=nan(numel(inicios),nfft/2+1); numero_validos=zeros(numel(inicios),1);
    for bloco=1:numel(inicios)
        indices=inicios(bloco):inicios(bloco)+amostras_bloco-1;
        soma_coerencia=zeros(nfft/2+1,1);
        for canal1=canais_area{pares_areas(par,1)}
            sinal1=double(data.(campo1)(canal1,indices));
            if any(~isfinite(sinal1)) || std(sinal1)==0, continue; end
            for canal2=canais_area{pares_areas(par,2)}
                sinal2=double(data.(campo2)(canal2,indices));
                if any(~isfinite(sinal2)) || std(sinal2)==0, continue; end
                [coerencia,frequencias]=mscohere(sinal1-mean(sinal1),sinal2-mean(sinal2), ...
                    janela,sobreposicao,nfft,srate);
                if any(~isfinite(coerencia)), continue; end
                soma_coerencia=soma_coerencia+coerencia(:);
                numero_validos(bloco)=numero_validos(bloco)+1;
            end
        end
        if numero_validos(bloco)>0
            matriz_coerencia(bloco,:)=soma_coerencia'/numero_validos(bloco);
        end
    end
    frequencias=(0:nfft/2)'*srate/nfft;
    mascara=frequencias>=banda_hz(1) & frequencias<=banda_hz(2);
    frequencias_banda=frequencias(mascara);
    valores_coerencia{par}=trapz(frequencias_banda,matriz_coerencia(:,mascara),2) ...
        /(frequencias_banda(end)-frequencias_banda(1));
    espectros{par}=matriz_coerencia; pares_validos{par}=numero_validos;
end
resultado_coerencia=resumir_resultados(valores_coerencia, ...
    {'Area 1 <-> 2';'Area 1 <-> 3';'Area 2 <-> 3'},'coerencia quadratica [0,1]', ...
    'Welch: janelas Hann de 4 s, 50% sobreposicao; media espectral 1-100 Hz, canais e blocos.',parametros);
q05.summary=resultado_coerencia.summary;
q05.values=resultado_coerencia.values;
q05.units=resultado_coerencia.units;
q05.method=resultado_coerencia.method;
q05.coerencia=struct('frequencias_hz',frequencias,'espectros',{espectros}, ...
    'canais',{canais_area},'pares_validos',{pares_validos},'banda_hz',banda_hz, ...
    'janela_segundos',janela_segundos);
q05.limitations='Coerencia sensivel a referencia comum, conducao de volume e atividade evocada; nao estabelece causalidade.';
disp(q05.summary)

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

function contagens = contar_spikes(tempos_spikes,bordas)
    contagens=zeros(numel(bordas)-1,numel(tempos_spikes));
    for u=1:numel(tempos_spikes)
        t=tempos_spikes{u}; t=t(t>=bordas(1) & t<bordas(end));
        contagens(:,u)=histcounts(t,bordas)';
    end
end
