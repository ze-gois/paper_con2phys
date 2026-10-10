%% Q06 - Conectividade direcionada: modelo autorregressivo condicional
q00_prepare

%% Parametros e preparacao da analise
bin_segundos = .02;
ordem = 5; % Historia de 100 ms.
contagens=contar_spikes(spkt,0:bin_segundos:duracao); atividade_populacional=nan(size(contagens,1),3);
for area=1:3, atividade_populacional(:,area)=mean(contagens(:,area_neuronio==area),2); end
pares_areas=[1 2;3 2;3 1]; valores=cell(3,1); bins_bloco=round(parametros.bloco_segundos/bin_segundos);
for par=1:3
    valores_bloco=[];
    for inicio=1:bins_bloco:size(atividade_populacional,1)-bins_bloco+1
        contagens_bloco=atividade_populacional(inicio:inicio+bins_bloco-1,:);
        if any(~isfinite(contagens_bloco(:))) || any(std(contagens_bloco)==0), valores_bloco(end+1,1)=nan; continue; end
        contagens_bloco=detrend(contagens_bloco); contagens_bloco=contagens_bloco./std(contagens_bloco); numero_bins=size(contagens_bloco,1);
        matriz_completa=ones(numero_bins-ordem,1); colunas_origem=[];
        for atraso=1:ordem
            colunas_origem(end+1)=size(matriz_completa,2)+pares_areas(par,1);
            matriz_completa=[matriz_completa contagens_bloco(ordem+1-atraso:numero_bins-atraso,:)]; %#ok<AGROW>
        end
        resposta=contagens_bloco(ordem+1:end,pares_areas(par,2)); matriz_reduzida=matriz_completa;
        matriz_reduzida(:,colunas_origem)=[];
        if rank(matriz_completa)<size(matriz_completa,2), valores_bloco(end+1,1)=nan; continue; end
        residuo_completo=resposta-matriz_completa*(matriz_completa\resposta); residuo_reduzido=resposta-matriz_reduzida*(matriz_reduzida\resposta);
        variancia_completa=mean(residuo_completo.^2); variancia_reduzida=mean(residuo_reduzido.^2);
        if variancia_completa<=eps || variancia_reduzida<=eps, valores_bloco(end+1,1)=nan; else, valores_bloco(end+1,1)=log(variancia_reduzida/variancia_completa); end
    end
    valores{par}=valores_bloco;
end
%% Resultados
q06=resumir_resultados(valores,{'Area 1 -> 2';'Area 3 -> 2';'Area 3 -> 1'}, ...
    'log residual variance ratio','20 ms counts, fixed VAR order 5 (100 ms), conditional on all three areas; block bootstrap.',parametros);
q06.limitations='Exploratory in-sample predictability, positively biased; requires stationarity, residual and lag sensitivity checks; not causal evidence.';
q06.provenance=procedencia;
disp(q06.summary)

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
