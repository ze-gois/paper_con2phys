%% Q15 - Complexidade do LFP por entropia de permutacao
q00_prepare

%% Parametros e preparacao da analise
atraso_segundos = .01;
[t,~,valido]=selecionar_trials(data,parametros); t=t(valido,:);
valores=cell(3,1); por_canal=cell(3,1); atraso_amostras=max(1,round(atraso_segundos*srate));
for area=1:3
    campo=sprintf('lfp_%d',area); entropia_canais=nan(size(t,1),size(data.(campo),1));
    for trial=1:size(t,1)
        inicio=ceil(t(trial,2)*srate)+1; fim=min(numero_amostras,ceil(t(trial,4)*srate));
        for canal=1:size(entropia_canais,2)
            sinal=double(data.(campo)(canal,inicio:fim));
            if numel(sinal)<100+2*atraso_amostras || any(~isfinite(sinal)) || std(sinal)==0, continue; end
            sinal=detrend(sinal); padroes=[sinal(1:end-2*atraso_amostras)' sinal(1+atraso_amostras:end-atraso_amostras)' sinal(1+2*atraso_amostras:end)'];
            % Exclui empates para nao atribuir ordens arbitrarias aos padroes.
            empates=padroes(:,1)==padroes(:,2) | padroes(:,1)==padroes(:,3) | padroes(:,2)==padroes(:,3);
            padroes=padroes(~empates,:); if size(padroes,1)<100, continue; end
            [~,ordem]=sort(padroes,2); [~,~,indice_padrao]=unique(ordem,'rows');
            probabilidade=accumarray(indice_padrao,1)/numel(indice_padrao); entropia_canais(trial,canal)=-sum(probabilidade.*log(probabilidade))/log(6);
        end
    end
    por_canal{area}=entropia_canais; valores{area}=mean(entropia_canais,2,'omitnan');
end
%% Resultados
q15=resumir_resultados(valores,nomes_areas,'normalized permutation entropy [0,1]', ...
    'LFP order 3, delay 10 ms, linear detrending, no added band filter; channel mean per trial; trial bootstrap.',parametros);
q15.channel_entropy=por_canal; q15.retained_trials=find(valido);
q15.limitations='High entropy can reflect measurement noise; not a direct measure of computational complexity. Check order, delay, trial duration and spectral sensitivity.';
q15.provenance=procedencia;
disp(q15.summary)

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
