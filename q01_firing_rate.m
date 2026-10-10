%% Q01 - Taxa media de disparos durante toda a gravacao
q00_prepare

%% Parametros e preparacao da analise
valores=cell(3,1);
for area=1:3, valores{area}=taxa_disparo(area_neuronio==area); end
%% Resultados
q01=resumir_resultados(valores,nomes_areas,'spikes/s/unit', ...
    'All mapped units, including silent units; unit bootstrap within recording.',parametros);
q01.unit=table(cluster_id,area_neuronio,taxa_disparo,'VariableNames',{'cluster','area','rate_hz'});
q01.excluded_spikes=spikes_excluidos;
q01.provenance=procedencia;
disp(q01.summary)

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
