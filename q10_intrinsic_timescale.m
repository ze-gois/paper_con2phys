%% Q10 - Escala temporal intrinseca durante o baseline
q00_prepare

%% Parametros e preparacao da analise
[t,~,valido]=selecionar_trials(data,parametros); baseline_janelas=[t(:,1)-1 t(:,1)];
valido=valido & baseline_janelas(:,1)>=0;
% Exige um segundo completo de baseline fora de qualquer trial.
for trial=1:size(t,1)
    sobreposicao=t(:,4)>baseline_janelas(trial,1) & t(:,1)<baseline_janelas(trial,2);
    sobreposicao(trial)=false; valido(trial)=valido(trial) & ~any(sobreposicao);
end
baseline_janelas=baseline_janelas(valido,:); tau=nan(numel(cluster_id),1); qualidade_ajuste=tau;
autocorrelacao=nan(numel(cluster_id),10); atrasos=(1:10)'*.05;
for neuronio=1:numel(cluster_id)
    if size(baseline_janelas,1)<20, continue; end
    contagens_baseline=zeros(size(baseline_janelas,1),20);
    for trial=1:size(baseline_janelas,1)
        bordas=linspace(baseline_janelas(trial,1),baseline_janelas(trial,2),21);
        contagens_baseline(trial,:)=contar_spikes(spkt(neuronio),bordas)';
    end
    % Correlaciona posicoes entre trials, sem concatenar os baselines.
    for atraso=1:10
        correlacoes=[];
        for posicao=1:20-atraso
            contagens_antes=contagens_baseline(:,posicao); contagens_depois=contagens_baseline(:,posicao+atraso);
            if std(contagens_antes)>0 && std(contagens_depois)>0
                matriz_correlacao=corrcoef(contagens_antes,contagens_depois); correlacoes(end+1)=matriz_correlacao(1,2);
            end
        end
        if ~isempty(correlacoes), autocorrelacao(neuronio,atraso)=mean(correlacoes); end
    end
    correlacao_lag=autocorrelacao(neuronio,:)'; validos=isfinite(correlacao_lag);
    if sum(validos)<6 || max(correlacao_lag(validos))<=0, continue; end
    tempo=atrasos(validos); correlacao_lag=correlacao_lag(validos);
    % Amplitude e tau positivos; termo constante livre no ajuste.
    erro_ajuste=@(coeficientes)sum((correlacao_lag-(exp(coeficientes(1))*exp(-tempo/exp(coeficientes(2)))+coeficientes(3))).^2);
    coeficientes=fminsearch(erro_ajuste,[log(max(correlacao_lag)-min(correlacao_lag)+eps) log(.15) min(correlacao_lag)], ...
        optimset('Display','off','MaxIter',1000));
    candidato=exp(coeficientes(2)); r2=1-erro_ajuste(coeficientes)/max(sum((correlacao_lag-mean(correlacao_lag)).^2),eps);
    qualidade_ajuste(neuronio)=r2;
    if candidato>=.025 && candidato<=1 && r2>=.5, tau(neuronio)=candidato; end
end
valores=cell(3,1); for area=1:3, valores{area}=tau(area_neuronio==area); end
%% Resultados
q10=resumir_resultados(valores,nomes_areas,'seconds', ...
    '1 s pretrial nonoverlapping ITI baseline; across-trial 50 ms count correlations; A exp(-lag/tau)+C; unit bootstrap.',parametros);
q10.unit=table(cluster_id,area_neuronio,tau,qualidade_ajuste,'VariableNames',{'cluster','area','tau_seconds','r2'});
q10.acf=autocorrelacao; q10.lag_seconds=atrasos; q10.baseline_windows=baseline_janelas;
q10.fit_criteria='>=20 baseline trials, >=6 finite lags, positive A, tau 25-1000 ms, R2 >=0.5; accepted-fit selection bias possible.';
q10.provenance=procedencia;
disp(q10.summary)

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
