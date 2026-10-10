%% Q08 - Acoplamento entre disparos e fase do LFP de 4 a 10 Hz
% Referencias: 01-12-2011.m e 01-12-2011(1).m.
q00_prepare

%% Parametros e preparacao da analise

%% Parametros
banda_hz = [4 10];
margem_segundos = 2;
numero_surrogates = parametros.surrogates;
numero_bins_fase = 18;
assert(srate>2*banda_hz(2));
[b_filtro,a_filtro] = butter(3,banda_hz/(srate/2));
sorteio = RandStream('mt19937ar','Seed',parametros.semente);

%% Fase nos instantes dos disparos
numero_neuronios = numel(cluster_id);
ppc = nan(numero_neuronios,1); forca_vetorial = ppc; fase_preferida = ppc;
p_surrogate = ppc; quantidade_spikes = zeros(numero_neuronios,1);
ppc_surrogate = nan(numero_neuronios,numero_surrogates);
bordas_fase = linspace(-pi,pi,numero_bins_fase+1);
histograma_fase = zeros(numero_neuronios,numero_bins_fase);
ocupacao_fase = nan(3,numero_bins_fase);
for area = 1:3
    campo = sprintf('lfp_%d',area);
    canal = parametros.canais_lfp(area);
    assert(canal<=size(data.(campo),1));
    sinal = double(data.(campo)(canal,:));
    if any(~isfinite(sinal)) || std(sinal)==0 || duracao<=2*margem_segundos+1, continue; end
    sinal_analitico = hilbert(filtfilt(b_filtro,a_filtro,sinal));
    indices_validos = ceil(margem_segundos*srate)+1:floor((duracao-margem_segundos)*srate);
    ocupacao_fase(area,:) = histcounts(angle(sinal_analitico(indices_validos)),bordas_fase)/srate;
    intervalo = duracao-2*margem_segundos;
    for neuronio = find(area_neuronio==area)'
        tempos = spkt{neuronio};
        tempos = tempos(tempos>=margem_segundos & tempos<duracao-margem_segundos);
        fases = fases_disparos(sinal_analitico,tempos,srate);
        quantidade_spikes(neuronio) = numel(fases);
        histograma_fase(neuronio,:) = histcounts(fases,bordas_fase);
        if numel(fases)<parametros.minimo_spikes, continue; end
        vetor_medio = mean(exp(1i*fases));
        forca_vetorial(neuronio) = abs(vetor_medio);
        fase_preferida(neuronio) = angle(vetor_medio);
        ppc(neuronio) = calcular_ppc(fases);
        for repeticao=1:numero_surrogates
            % Deslocamento circular preserva a estrutura do trem salvo na emenda.
            deslocamento=.5+rand(sorteio)*(intervalo-1);
            tempos_nulos=mod(tempos-margem_segundos+deslocamento,intervalo)+margem_segundos;
            fases_nulas=fases_disparos(sinal_analitico,tempos_nulos,srate);
            if numel(fases_nulas)==numel(fases)
                ppc_surrogate(neuronio,repeticao)=calcular_ppc(fases_nulas);
            end
        end
        nulos=ppc_surrogate(neuronio,:); nulos=nulos(isfinite(nulos));
        if ~isempty(nulos), p_surrogate(neuronio)=(1+sum(nulos>=ppc(neuronio)))/(numel(nulos)+1); end
    end
end

%% Resultados: PPC principal, comprimento vetorial e angulo como diagnosticos
valores = cell(3,1);
for area=1:3, valores{area}=ppc(area_neuronio==area); end
%% Resultados
q08 = resumir_resultados(valores,nomes_areas,'PPC', ...
    'Fase Hilbert 4-10 Hz; PPC por unidade; bootstrap de unidades e deslocamentos circulares.',parametros);
q08.unit = table(cluster_id,area_neuronio,quantidade_spikes,ppc, ...
    forca_vetorial,fase_preferida,p_surrogate, ...
    'VariableNames',{'cluster','area','spikes','ppc','vector_strength','preferred_phase_rad','p_surrogate'});
q08.histograma_fase=histograma_fase; q08.bordas_fase=bordas_fase;
q08.ocupacao_fase_segundos=ocupacao_fase; q08.ppc_surrogate=ppc_surrogate;
q08.provenance=procedencia;
q08.limitations='P-valores exploratorios sem correcao multipla; nao usar fracao significativa para ranquear areas. Verificar estacionariedade, canal de referencia e dependencia entre spikes.';
disp(q08.summary)

%% Funcoes locais
function fases=fases_disparos(analitico,tempos,srate)
    posicao=tempos*srate+1; indice=floor(posicao); fracao=posicao-indice;
    valido=indice>=1 & indice<numel(analitico);
    indice=indice(valido); fracao=fracao(valido);
    z=(1-fracao(:)).*reshape(analitico(indice),[],1) ...
        +fracao(:).*reshape(analitico(indice+1),[],1);
    fases=angle(z(isfinite(z) & abs(z)>0));
end

function valor=calcular_ppc(fases)
    n=numel(fases); valor=nan;
    if n>=2, valor=(abs(sum(exp(1i*fases)))^2-n)/(n*(n-1)); end
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
