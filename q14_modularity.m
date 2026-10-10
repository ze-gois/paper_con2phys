%% Q14 - Modularidade da rede de correlacoes positivas
q00_prepare

%% Parametros e preparacao da analise
contagens=contar_spikes(spkt,0:.1:duracao);
sorteio=RandStream('mt19937ar','Seed',parametros.semente);
numero_selecionados=min([parametros.numero_neuronios;arrayfun(@(area)sum(area_neuronio==area),(1:3)')]);
assert(numero_selecionados>=3,'Modularity requires >=3 units per area.');
bins_bloco=round(parametros.bloco_segundos/.1); valores=cell(3,1); selecionados=cell(3,1);
for area=1:3
    neuronios=find(area_neuronio==area); neuronios=neuronios(randperm(sorteio,numel(neuronios),numero_selecionados)); selecionados{area}=cluster_id(neuronios);
    valores_bloco=[];
    for inicio=1:bins_bloco:size(contagens,1)-bins_bloco+1
        contagens_bloco=contagens(inicio:inicio+bins_bloco-1,neuronios);
        % Mantem o tamanho da rede: exclui blocos com unidades constantes.
        if any(std(contagens_bloco)==0), valores_bloco(end+1,1)=nan; continue; end
        pesos=max(corrcoef(contagens_bloco),0); pesos(1:numero_selecionados+1:end)=0;
        valores_bloco(end+1,1)=calcular_modularidade(pesos);
    end
    valores{area}=valores_bloco;
end
%% Resultados
q14=resumir_resultados(valores,nomes_areas,'weighted Newman-Girvan Q', ...
    '100 ms counts; fixed matched node subset; positive Pearson edges; greedy community merging per block; block bootstrap.',parametros);
q14.selected_clusters=selecionados;
q14.limitations='Mean local block modularity across recording, not one static whole-session graph. Negative edges discarded; greedy result is a lower bound on maximum Q. Inspect node-count, resolution and null-network sensitivity.';
q14.provenance=procedencia;
disp(q14.summary)

%% Funcoes locais
function modularidade=calcular_modularidade(w)
    s=sum(w(:)); modularidade=nan; if s<=0, return; end
    k=sum(w,2); b=w-k*k'/s; comunidade=1:size(w,1);
    modularidade=sum(diag(b))/s;
    while true
        rotulos=unique(comunidade); ganho=0; par_comunidades=[];
        for i=1:numel(rotulos)
            for j=i+1:numel(rotulos)
                variacao=2*sum(sum(b(comunidade==rotulos(i),comunidade==rotulos(j))))/s;
                if variacao>ganho+1e-12, ganho=variacao; par_comunidades=[rotulos(i) rotulos(j)]; end
            end
        end
        if isempty(par_comunidades), break; end
        comunidade(comunidade==par_comunidades(2))=par_comunidades(1); modularidade=modularidade+ganho;
    end
end

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
