%% Q12 - Decodificacao de C nos tres segmentos do trial
q00_prepare

%% Parametros e preparacao da analise
[t,rotulos,valido]=selecionar_trials(data,parametros);
valido=valido & isfinite(rotulos(:,2)); t=t(valido,:); observado=rotulos(valido,2);
assert(all(ismember(unique(observado),[1 2 3])),'Variable C must be categorical 1-3.');
acuracia=nan(3,1); intervalo_confianca=nan(3,2); detalhes_segmentos=cell(3,1); nulo=nan(3,parametros.surrogates);
sorteio=RandStream('mt19937ar','Seed',parametros.semente);
for segmento=1:3
    taxas=taxas_trials(spkt,t(:,segmento:segmento+1));
    [acuracia(segmento),detalhes]=decodificar_trials(taxas,observado,parametros.semente); detalhes_segmentos{segmento}=detalhes;
    if ~isfinite(acuracia(segmento)), continue; end
    reamostras=nan(parametros.bootstrap,1); classes=unique(observado);
    for repeticao=1:parametros.bootstrap
        acertos_classe=nan(numel(classes),1);
        for classe=1:numel(classes)
            indices=find(detalhes.observed==classes(classe) & isfinite(detalhes.predicted));
            if isempty(indices), continue; end
            amostra=indices(randi(sorteio,numel(indices),numel(indices),1));
            acertos_classe(classe)=mean(detalhes.predicted(amostra)==detalhes.observed(amostra));
        end
        reamostras(repeticao)=mean(acertos_classe);
    end
    reamostras=sort(reamostras); intervalo_confianca(segmento,:)=reamostras(max(1,ceil([.025 .975]*numel(reamostras))));
    for repeticao=1:parametros.surrogates
        rotulos_nulos=circshift(observado,randi(sorteio,numel(observado)-1));
        nulo(segmento,repeticao)=decodificar_trials(taxas,rotulos_nulos,parametros.semente);
    end
end
%% Resultados
q12=struct('summary',table({'Trial start -> Stim';'Stim -> Outcome';'Outcome -> End'}, ...
    acuracia,intervalo_confianca(:,1),intervalo_confianca(:,2),'VariableNames',{'group','mean','ci95_low','ci95_high'}), ...
    'units','balanced accuracy','config',parametros,'decoding',{detalhes_segmentos},'null_accuracy',nulo, ...
    'method','All units, segment mean rates, identical contiguous 5-fold splits, training-only standardization, fixed ridge decoder; stratified held-out bootstrap.', ...
    'answer','Pending paired segment contrasts across animals', ...
    'limitations','Variable segment duration changes count precision; duration-matched sensitivity needed. CI conditions on fitted models.');
q12.retained_trials=find(valido);
q12.provenance=procedencia;
disp(q12.summary)

%% Funcoes locais
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
