%% Q04 - Correlacao entre trens de disparos em bins de 100 ms
q00_prepare

%% Parametros e preparacao da analise
bin_segundos = .1;
atrasos_bins = -10:10;
contagens=contar_spikes(spkt,0:bin_segundos:duracao);
valores=cell(3,1); correlacao_assinada=cell(3,1); bins_bloco=round(parametros.bloco_segundos/bin_segundos);
for area=1:3
    neuronios=find(area_neuronio==area); valores_bloco=[]; valores_assinados=[];
    for inicio=1:bins_bloco:size(contagens,1)-bins_bloco+1
        contagens_bloco=contagens(inicio:inicio+bins_bloco-1,neuronios); contagens_bloco=contagens_bloco(:,std(contagens_bloco,0,1)>0);
        if size(contagens_bloco,2)<2, valores_bloco(end+1,1)=nan; valores_assinados(end+1,1)=nan; continue; end
        correlacoes=corrcoef(contagens_bloco); correlacoes=correlacoes(triu(true(size(correlacoes)),1));
        valores_bloco(end+1,1)=mean(abs(correlacoes)); valores_assinados(end+1,1)=mean(correlacoes);
    end
    valores{area}=valores_bloco; correlacao_assinada{area}=valores_assinados;
end
%% Resultados
q04=resumir_resultados(valores,nomes_areas,'absolute Pearson r', ...
    '100 ms nonoverlapping counts, mean absolute pair correlation per block; block bootstrap.',parametros);
q04.signed_block_mean=correlacao_assinada;
q04.limitations='Shared rate modulation and task drive can induce correlation; not a synaptic interaction estimate.';
q04.provenance=procedencia;
disp(q04.summary)

%% Correlograma populacional: diagnostico em atrasos de -1 a 1 segundo
% Correlacao de contagens com bins de 100 ms, nao um CCG de precisao sinaptica.
correlacao_atrasada = nan(3,numel(atrasos_bins));
numero_pares = zeros(3,1);
for area = 1:3
    contagens_area = contagens(:,area_neuronio==area);
    contagens_area = contagens_area(:,std(contagens_area,0,1)>0);
    numero_neuronios = size(contagens_area,2);
    numero_pares(area) = numero_neuronios*(numero_neuronios-1)/2;
    if numero_neuronios<2, continue; end
    for indice_atraso = 1:numel(atrasos_bins)
        atraso = atrasos_bins(indice_atraso);
        indices = max(1,1-atraso):min(size(contagens_area,1),size(contagens_area,1)-atraso);
        antes = contagens_area(indices,:); depois = contagens_area(indices+atraso,:);
        antes = antes-mean(antes,1); depois = depois-mean(depois,1);
        normalizacao = sqrt(sum(antes.^2,1)'*sum(depois.^2,1));
        correlacao = (antes'*depois)./normalizacao;
        pares = ~eye(numero_neuronios) & isfinite(correlacao);
        correlacao_atrasada(area,indice_atraso) = mean(correlacao(pares));
    end
end
q04.correlograma = struct('atrasos_segundos',bin_segundos*atrasos_bins, ...
    'correlacao_media',correlacao_atrasada,'numero_pares',numero_pares, ...
    'interpretacao','Media dos pares ordenados; perfil simetrico, sem inferencia direcional.');

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
