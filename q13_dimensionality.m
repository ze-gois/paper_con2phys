%% Q13 - Dimensionalidade populacional e espectro de correlacao
q00_prepare

%% Parametros e preparacao da analise
[t,~,valido]=selecionar_trials(data,parametros); t=t(valido,:);
sorteio=RandStream('mt19937ar','Seed',parametros.semente);
numero_selecionados=min([parametros.numero_neuronios;arrayfun(@(area)sum(area_neuronio==area),(1:3)')]);
assert(numero_selecionados>=2,'Dimensionality requires >=2 units per area.');
estimativa=nan(3,1); intervalo_confianca=nan(3,2); repeticoes=cell(3,1); retidos=zeros(3,1);
for area=1:3
    neuronios=find(area_neuronio==area); trials_contagens=cell(size(t,1),1);
    for trial=1:size(t,1)
        bordas=t(trial,2):.1:t(trial,3);
        if numel(bordas)>=3, trials_contagens{trial}=contar_spikes(spkt(neuronios),bordas); end
    end
    trials_contagens=trials_contagens(~cellfun(@isempty,trials_contagens)); retidos(area)=numel(trials_contagens);
    if numel(trials_contagens)<2, continue; end
    contagens_total=vertcat(trials_contagens{:}); subamostras=nan(100,1);
    for repeticao=1:100
        colunas=randperm(sorteio,numel(neuronios),numero_selecionados); subamostras(repeticao)=calcular_dimensao(contagens_total(:,colunas));
    end
    estimativa(area)=mean(subamostras,'omitnan'); reamostras=nan(parametros.bootstrap,1);
    for repeticao=1:parametros.bootstrap
        indices=randi(sorteio,numel(trials_contagens),numel(trials_contagens),1);
        contagens_reamostradas=vertcat(trials_contagens{indices}); colunas=randperm(sorteio,numel(neuronios),numero_selecionados);
        reamostras(repeticao)=calcular_dimensao(contagens_reamostradas(:,colunas));
    end
    repeticoes{area}=reamostras; reamostras=sort(reamostras(isfinite(reamostras)));
    if numel(reamostras)>=2, intervalo_confianca(area,:)=reamostras(max(1,ceil([.025 .975]*numel(reamostras)))); end
end
%% Resultados
q13=struct('summary',table(nomes_areas,estimativa,intervalo_confianca(:,1),intervalo_confianca(:,2),retidos, ...
    'VariableNames',{'group','mean','ci95_low','ci95_high','trials'}), ...
    'units','effective dimensions','config',parametros,'matched_units',numero_selecionados,'bootstrap',{repeticoes}, ...
    'method','100 ms counts within stim-outcome only; covariance PR=(trace C)^2/trace(C^2); matched unit subsampling and trial bootstrap.', ...
    'answer','Pending across-animal comparison','limitations','CI includes random unit-subset variability. Raw covariance weights high-variance units; task and noise both contribute.');
q13.provenance=procedencia;
disp(q13.summary)

%% Espectro da correlacao e componentes acima de um modelo nulo
% Referencia: assemblies.m. Componentes nao sao automaticamente assemblies.
espectro_area=cell(3,1);
for area=1:3
    neuronios=find(area_neuronio==area);
    neuronios=neuronios(randperm(sorteio,numel(neuronios),numero_selecionados));
    contagens_trials={};
    for trial=1:size(t,1)
        bordas=t(trial,2):.1:t(trial,3);
        if numel(bordas)>=3
            contagens_trials{end+1,1}=contar_spikes(spkt(neuronios),bordas); %#ok<SAGROW>
        end
    end
    if isempty(contagens_trials), continue; end
    contagens_total=vertcat(contagens_trials{:});
    if any(std(contagens_total,0,1)==0), continue; end
    matriz_correlacao=corrcoef(contagens_total);
    [autovetores,diagonal]=eig(matriz_correlacao);
    [autovalores,ordem]=sort(diag(diagonal),'descend');
    autovetores=autovetores(:,ordem);
    numero_bins=size(contagens_total,1);
    limiar_mp=(1+sqrt(numero_selecionados/numero_bins))^2;
    maior_autovalor_nulo=nan(parametros.surrogates,1);
    for repeticao=1:parametros.surrogates
        nulo=contagens_trials;
        for trial=1:numel(nulo)
            for neuronio=1:numero_selecionados
                deslocamento=randi(sorteio,size(nulo{trial},1))-1;
                nulo{trial}(:,neuronio)=circshift(nulo{trial}(:,neuronio),deslocamento);
            end
        end
        matriz_nula=corrcoef(vertcat(nulo{:}));
        maior_autovalor_nulo(repeticao)=max(eig(matriz_nula));
    end
    ordenados=sort(maior_autovalor_nulo);
    limiar_nulo=ordenados(ceil(.95*numel(ordenados)));
    espectro_area{area}=struct('clusters',cluster_id(neuronios), ...
        'matriz_correlacao',matriz_correlacao,'autovalores',autovalores, ...
        'autovetores',autovetores,'dimensao_correlacao',sum(autovalores)^2/sum(autovalores.^2), ...
        'limiar_marchenko_pastur',limiar_mp,'limiar_surrogate',limiar_nulo, ...
        'componentes_acima_mp',sum(autovalores>limiar_mp), ...
        'componentes_acima_surrogate',sum(autovalores>limiar_nulo), ...
        'maior_autovalor_nulo',maior_autovalor_nulo,'numero_bins',numero_bins);
end
q13.espectro=espectro_area;
q13.nulo='Deslocamentos circulares independentes por unidade dentro de cada trial; preservam contagens por trial. MP e referencia teorica, nao teste calibrado para bins autocorrelacionados.';

%% Funcoes locais
function d=calcular_dimensao(x)
    d=nan; if size(x,1)<3, return; end
    c=cov(x); denominador=sum(c(:).^2);
    if denominador>0, d=trace(c)^2/denominador; end
end

function contagens = contar_spikes(tempos_spikes,bordas)
    contagens=zeros(numel(bordas)-1,numel(tempos_spikes));
    for u=1:numel(tempos_spikes)
        t=tempos_spikes{u}; t=t(t>=bordas(1) & t<bordas(end));
        contagens(:,u)=histcounts(t,bordas)';
    end
end

function [t,rotulos,valido] = selecionar_trials(data,opcoes)
    % O mapa explicito evita confundir uma coluna de indice com os eventos.
    c=opcoes.colunas_trial;
    if isempty(c) && isfield(data,'trial_columns'), c=data.trial_columns; end
    assert(isstruct(c),'Defina parametros.colunas_trial ou execute a01_probing atualizado.');
    campos_obrigatorios={'trial_start','stim_start','outcome','trial_end','A','C'};
    for k=1:numel(campos_obrigatorios)
        assert(isfield(c,campos_obrigatorios{k}),'Coluna de trial ausente: %s',campos_obrigatorios{k});
        validateattributes(c.(campos_obrigatorios{k}),{'numeric'},{'scalar','integer','positive','<=',size(data.trial,2)});
    end
    t=double(data.trial(:,[c.trial_start c.stim_start c.outcome c.trial_end]));
    rotulos=double(data.trial(:,[c.A c.C]));
    valido=all(isfinite(t),2) & all(diff(t,1,2)>0,2) & t(:,1)>=0 ...
        & t(:,4)<=size(data.lfp_1,2)/data.srate;
    % Exclui todos os trials sobrepostos, incluindo intervalos aninhados.
    validos_originais=valido;
    for k=find(validos_originais)'
        sobreposicao=validos_originais & t(:,1)<t(k,4) & t(:,4)>t(k,1);
        sobreposicao(k)=false;
        if any(sobreposicao), valido(k)=false; valido(sobreposicao)=false; end
    end
end
