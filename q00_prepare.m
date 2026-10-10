%% Q00 - Preparacao dos dados para o questionario
% Execute a01_probing antes. data permanece inalterado.
% Parametros ja definidos no workspace sao preservados entre os scripts.
assert(exist('data','var')==1 && isstruct(data),'Execute a01_probing primeiro.');

%% Parametros comuns
if ~exist('parametros','var'), parametros=struct(); end
padrao.semente = 42;
padrao.bootstrap = 1000;
padrao.surrogates = 199;
padrao.bloco_segundos = 30;
padrao.srate_waveform = 30000;
padrao.limiar_largura_ms = 0.4;
padrao.minimo_spikes = 50;
padrao.numero_neuronios = 5;
padrao.colunas_trial = [];
padrao.canais_lfp = [1 1 1];

nomes_parametros=fieldnames(padrao);
for indice_parametro=1:numel(nomes_parametros)
    nome=nomes_parametros{indice_parametro};
    if ~isfield(parametros,nome), parametros.(nome)=padrao.(nome); end
end
validateattributes(parametros.bootstrap,{'numeric'},{'scalar','integer','>=',20});
validateattributes(parametros.surrogates,{'numeric'},{'scalar','integer','>=',19});
validateattributes(parametros.semente,{'numeric'},{'scalar','integer','>=',0,'<=',2^32-1});
validateattributes(parametros.bloco_segundos,{'numeric'},{'scalar','finite','>=',8});
validateattributes(parametros.numero_neuronios,{'numeric'},{'scalar','integer','positive'});
validateattributes(parametros.srate_waveform,{'numeric'},{'scalar','finite','positive'});
validateattributes(parametros.limiar_largura_ms,{'numeric'},{'scalar','finite','positive'});
validateattributes(parametros.minimo_spikes,{'numeric'},{'scalar','integer','>=',2});
validateattributes(parametros.canais_lfp,{'numeric'},{'vector','numel',3,'integer','positive'});

%% Eixo temporal do LFP: primeira amostra em zero, intervalo [0,duracao)
srate=double(data.srate);
validateattributes(srate,{'numeric'},{'scalar','finite','positive'});
numero_amostras=size(data.lfp_1,2);
assert(numero_amostras>0 && size(data.lfp_2,2)==numero_amostras ...
    && size(data.lfp_3,2)==numero_amostras,'As areas devem compartilhar o eixo temporal.');
duracao=numero_amostras/srate;

%% Unidades: IDs nao precisam ser consecutivos
cluster_id=double(data.waveform_cluster(:));
area_neuronio=double(data.waveform_area(:));
assert(all(isfinite(cluster_id)) && numel(unique(cluster_id))==numel(cluster_id),'IDs invalidos ou duplicados.');
assert(numel(area_neuronio)==numel(cluster_id) && all(ismember(area_neuronio,1:3)));
assert(size(data.waveform,1)==numel(cluster_id),'Waveforms e IDs devem ter a mesma ordem.');

tempos=double(data.spike_timestamp(:));
clusters=double(data.spike_cluster(:));
assert(numel(tempos)==numel(clusters));
[cluster_conhecido,indice_neuronio]=ismember(clusters,cluster_id);
spike_valido=cluster_conhecido & isfinite(tempos) & tempos>=0 & tempos<duracao;
spikes_excluidos=sum(~spike_valido);

%% Trens de disparos e taxas durante toda a gravacao
spkt=cell(numel(cluster_id),1);
for neuronio=1:numel(cluster_id)
    spkt{neuronio}=sort(tempos(spike_valido & indice_neuronio==neuronio));
end
taxa_disparo=cellfun(@numel,spkt)/duracao;
nomes_areas={'Area 1';'Area 2';'Area 3'};

%% Procedencia e resultado da preparacao
procedencia=struct('duration_seconds',duracao,'lfp_samples',numero_amostras, ...
    'lfp_srate',srate,'cluster_ids',cluster_id,'excluded_spikes',spikes_excluidos);
if isfield(data,'source'), procedencia.source=data.source; end
if isfield(data,'trial_columns'), procedencia.trial_columns=data.trial_columns; end
if ~isempty(parametros.colunas_trial), procedencia.trial_columns=parametros.colunas_trial; end
q00=struct('spkt',{spkt},'cluster_id',cluster_id,'area_neuronio',area_neuronio, ...
    'taxa_disparo',taxa_disparo,'duracao',duracao,'srate',srate, ...
    'config',parametros,'provenance',procedencia);
% Remove somente copias temporarias grandes. Os resultados ficam no workspace.
clear tempos clusters cluster_conhecido indice_neuronio spike_valido padrao nomes_parametros
