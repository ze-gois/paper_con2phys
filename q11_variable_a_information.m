%% Q11 - Informacao sobre A: decodificacao e codificacao por taxa
q00_prepare

%% Parametros e preparacao da analise
[t,rotulos,valido]=selecionar_trials(data,parametros); rotulos(~valido,:)=nan;
assert(numel(unique(rotulos(isfinite(rotulos(:,1)),1)))<=2, ...
    'A variavel A deve ser binaria.');
sorteio=RandStream('mt19937ar','Seed',parametros.semente);
numero_selecionados=min([parametros.numero_neuronios;arrayfun(@(area)sum(area_neuronio==area),(1:3)')]);
assert(numero_selecionados>=1,'Each area needs at least one mapped unit.');
informacao_area=nan(3,1); intervalo_confianca=nan(3,2); nulo=nan(3,parametros.surrogates); detalhes_areas=cell(3,1); selecionados=cell(3,1);
for area=1:3
    neuronios=find(area_neuronio==area); neuronios=neuronios(randperm(sorteio,numel(neuronios),numero_selecionados)); selecionados{area}=cluster_id(neuronios);
    taxas=taxas_trials(spkt(neuronios),t(:,[1 4]));
    [~,detalhes]=decodificar_trials(taxas,rotulos(:,1),parametros.semente); detalhes_areas{area}=detalhes;
    observado=detalhes.observed; predicao=detalhes.predicted; ok=isfinite(predicao); observado=observado(ok); predicao=predicao(ok);
    if numel(observado)<25, continue; end
    informacao_area(area)=informacao_decodificada(observado,predicao); reamostras=nan(parametros.bootstrap,1);
    for repeticao=1:parametros.bootstrap
        indices=randi(sorteio,numel(observado),numel(observado),1); reamostras(repeticao)=informacao_decodificada(observado(indices),predicao(indices));
    end
    reamostras=sort(reamostras(isfinite(reamostras)));
    if numel(reamostras)>=2
        intervalo_confianca(area,:)=reamostras(max(1,ceil([.025 .975]*numel(reamostras))));
    end
    % Reajusta o modelo apos deslocar circularmente os rotulos.
    validos=isfinite(rotulos(:,1)) & all(isfinite(taxas),2); rotulos_validos=rotulos(validos,1); taxas_validas=taxas(validos,:);
    for repeticao=1:parametros.surrogates
        deslocados=circshift(rotulos_validos,randi(sorteio,numel(rotulos_validos)-1));
        [~,detalhes_nulos]=decodificar_trials(taxas_validas,deslocados,parametros.semente);
        nulo(area,repeticao)=informacao_decodificada(detalhes_nulos.observed,detalhes_nulos.predicted);
    end
end
%% Resultados
q11=struct('summary',table(nomes_areas,informacao_area,intervalo_confianca(:,1),intervalo_confianca(:,2), ...
    'VariableNames',{'group','mean','ci95_low','ci95_high'}), ...
    'units','bits','config',parametros,'decoding',{detalhes_areas},'selected_clusters',{selecionados}, ...
    'null_bits',nulo,'answer','Pending across-animal analysis and null comparison', ...
    'method','Whole-trial mean rate, matched unit count, blocked 5-fold ridge decoder; MI of held-out confusion matrix; conditional trial bootstrap CI.', ...
    'limitations','Decoded information proxy with finite-sample bias; whole-trial averaging may hide transient coding. CIs condition on fitted models; do not estimate full neural MI.');
q11.provenance=procedencia;
disp(q11.summary)

%% Codificacao temporal de A: segmentos do trial, sempre sem intervalo intertrial
% Complementa a MI decodificada do trial inteiro; nao escolhe o melhor segmento.
nomes_segmentos={'Inicio -> Estimulo';'Estimulo -> Desfecho';'Desfecho -> Fim'};
acuracia_segmento=nan(3,3); informacao_segmento=nan(3,3);
informacao_taxa=cell(3,1); informacao_spike=cell(3,1); p_taxa=cell(3,1);
for area=1:3
    [~,neuronios]=ismember(q11.selected_clusters{area},cluster_id);
    taxa_bits_segundo=nan(numel(neuronios),3); taxa_bits_spike=taxa_bits_segundo;
    p_por_unidade=taxa_bits_segundo;
    for segmento=1:3
        janelas=t(:,segmento:segmento+1);
        taxas=taxas_trials(spkt(neuronios),janelas);
        [acuracia_segmento(area,segmento),decodificacao]=decodificar_trials(taxas,rotulos(:,1),parametros.semente);
        informacao_segmento(area,segmento)=informacao_decodificada(decodificacao.observed,decodificacao.predicted);
        exposicao=diff(janelas,1,2);
        validos=valido & isfinite(rotulos(:,1)) & all(isfinite(taxas),2);
        rotulos_segmento=rotulos(validos,1); exposicao=exposicao(validos); taxas=taxas(validos,:);
        if numel(unique(rotulos_segmento))~=2 || numel(rotulos_segmento)<2, continue; end
        [taxa_bits_segundo(:,segmento),taxa_bits_spike(:,segmento)]= ...
            informacao_por_taxa(taxas,exposicao,rotulos_segmento);
        nulos=nan(numel(neuronios),parametros.surrogates);
        for repeticao=1:parametros.surrogates
            rotulos_nulos=circshift(rotulos_segmento,randi(sorteio,numel(rotulos_segmento)-1));
            nulos(:,repeticao)=informacao_por_taxa(taxas,exposicao,rotulos_nulos);
        end
        for neuronio=1:numel(neuronios)
            amostras_nulas=nulos(neuronio,:); amostras_nulas=amostras_nulas(isfinite(amostras_nulas));
            if isfinite(taxa_bits_segundo(neuronio,segmento)) && ~isempty(amostras_nulas)
                p_por_unidade(neuronio,segmento)=(1+sum(amostras_nulas>=taxa_bits_segundo(neuronio,segmento))) ...
                    /(numel(amostras_nulas)+1);
            end
        end
    end
    informacao_taxa{area}=taxa_bits_segundo; informacao_spike{area}=taxa_bits_spike;
    p_taxa{area}=p_por_unidade;
end
q11.temporal=struct('segmentos',{nomes_segmentos}, ...
    'balanced_accuracy',acuracia_segmento,'decoded_bits',informacao_segmento, ...
    'rate_bits_per_second',{informacao_taxa},'rate_bits_per_spike',{informacao_spike}, ...
    'p_surrogate_rate',{p_taxa},'clusters',{q11.selected_clusters}, ...
    'interpretacao','Informacao de taxa ponderada pela exposicao; nao equivale a MI populacional. P-valores exploratorios nao corrigidos.');

%% Funcoes locais
function informacao=informacao_decodificada(y,predicao)
    ok=isfinite(y) & isfinite(predicao); y=y(ok); predicao=predicao(ok); informacao=nan;
    if isempty(y) || numel(unique(y))<2, return; end
    classes=unique([y;predicao]); p=zeros(numel(classes));
    for i=1:numel(classes)
        for j=1:numel(classes), p(i,j)=mean(y==classes(i) & predicao==classes(j)); end
    end
    independente=sum(p,2)*sum(p,1); nz=p>0;
    informacao=sum(p(nz).*log2(p(nz)./independente(nz)));
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

function x = taxas_trials(tempos_spikes,janelas)
    x=nan(size(janelas,1),numel(tempos_spikes));
    for k=1:size(janelas,1)
        if any(~isfinite(janelas(k,:))) || diff(janelas(k,:))<=0, continue; end
        for u=1:numel(tempos_spikes)
            x(k,u)=sum(tempos_spikes{u}>=janelas(k,1) & tempos_spikes{u}<janelas(k,2))/diff(janelas(k,:));
        end
    end
end

function [acuracia,detalhes] = decodificar_trials(x,y,semente)
    % Cinco particoes temporais; normalizacao estimada somente no treino.
    % Ridge uma-classe-contra-as-demais; penalidade fixa, sem ajuste no teste.
    manter=all(isfinite(x),2) & isfinite(y); x=x(manter,:); y=y(manter);
    classes=unique(y); n=numel(y); predicao=nan(n,1); escores=nan(n,numel(classes));
    acuracia=nan; detalhes=struct('observed',y,'predicted',predicao,'softmax_scores',escores);
    if numel(classes)<2 || n<25 || isempty(x), return; end
    particao=min(5,ceil((1:n)'*5/n));
    for f=1:5
        teste=particao==f; treino=~teste;
        if any(arrayfun(@(c)sum(y(treino)==c)<2,classes)), continue; end
        media=mean(x(treino,:),1); desvio=std(x(treino,:),0,1); desvio(desvio==0)=1;
        a=[ones(sum(treino),1) (x(treino,:)-media)./desvio];
        b=[ones(sum(teste),1) (x(teste,:)-media)./desvio];
        alvos=double(y(treino)==classes');
        penalidade=eye(size(a,2)); penalidade(1,1)=0;
        w=(a'*a+penalidade)\(a'*alvos);
        z=b*w; z=exp(z-max(z,[],2)); z=z./sum(z,2);
        escores(teste,:)=z; [~,ii]=max(z,[],2); predicao(teste)=classes(ii);
    end
    sensibilidade=nan(numel(classes),1);
    for k=1:numel(classes)
        ix=y==classes(k) & isfinite(predicao);
        if any(ix), sensibilidade(k)=mean(predicao(ix)==y(ix)); end
    end
    if all(isfinite(sensibilidade)), acuracia=mean(sensibilidade); end
    detalhes=struct('observed',y,'predicted',predicao,'softmax_scores',escores, ...
        'classes',classes,'fold',particao,'retained_rows',find(manter),'seed',semente);
end

function [bits_segundo,bits_spike]=informacao_por_taxa(taxas,exposicao,rotulos)
    classes=unique(rotulos); bits_segundo=nan(size(taxas,2),1); bits_spike=bits_segundo;
    if numel(classes)~=2 || sum(exposicao)<=0, return; end
    probabilidade=zeros(2,1); taxa_classe=zeros(2,size(taxas,2));
    for classe=1:2
        indices=rotulos==classes(classe); tempo=sum(exposicao(indices));
        probabilidade(classe)=tempo/sum(exposicao);
        taxa_classe(classe,:)=sum(taxas(indices,:).*exposicao(indices),1)/tempo;
    end
    taxa_media=sum(taxa_classe.*probabilidade,1);
    for neuronio=1:size(taxas,2)
        if taxa_media(neuronio)<=0, continue; end
        positivos=taxa_classe(:,neuronio)>0;
        bits_segundo(neuronio)=sum(probabilidade(positivos).*taxa_classe(positivos,neuronio) ...
            .*log2(taxa_classe(positivos,neuronio)/taxa_media(neuronio)));
        bits_spike(neuronio)=bits_segundo(neuronio)/taxa_media(neuronio);
    end
end
