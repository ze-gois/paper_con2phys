# Arsenal metodológico — CON²PHYS

**Status: rascunho exploratório, não validado para inferência científica.**

Este diretório contém funções MATLAB reutilizáveis extraídas das operações
matemáticas relevantes para métodos publicados em eletrofisiologia. A unidade
de implementação é **uma função pública por arquivo `.m`** em [Path](Path/).
O arquivo [METHODS.tsv](METHODS.tsv) registra 97 entradas bibliográficas (incluindo 2 referências excluídas por escopo)
e associa artigos a primitivas, limitações e métodos ainda não reproduzidos.

## Organização

```text
arsenal/
  README.md
  METHODS.tsv
  resources.tsv
  searches.tsv
  research/
    consensus_methodological_review.md
    consensus_citation_index.tsv
  references/
    population_geometry.bib
    large_scale_ephys.bib
    consensus_verified.bib
    bosc_circular_glm.bib
  Path/
    welch_psd.m
    multitaper_psd.m
    ...
  tests/
    smoke_arsenal.m
    smoke_population.m
    smoke_ephys_methods.m
    smoke_consensus_methods.m
    smoke_bosc_circ_glm.m
```

O diretório `Path/` deve ser adicionado ao MATLAB path **na sessão que executa
os scripts**. Em Linux, Path e path são nomes distintos.

```matlab
addpath(fullfile(pwd,'arsenal','Path'))
% Ou use um caminho absoluto, sem supor o current working directory.
```

Os scripts legados `a00..d00` e `q00..q15` **não foram modificados**.
Não existem novas dependências de workspace ou chamadas automáticas à pasta
Arsenal. Num projeto baseado em scripts, as funções permanecem independentes.

## Exemplo com o dataset carregado

```matlab
% Execute a rotina de carregamento original antes desta célula.
fs = data.srate;            % CON2PHYS LFP: 500 Hz
x = double(data.lfp_3(1,1:round(30*fs))); % Um canal, apenas 30 segundos
[f,p] = welch_psd(x,fs,4,.5);
aperiodic = aperiodic_slope(f,p,[2 180],[48 52;58 62]);
theta = bandpass_lfp(x,fs,[4 10],4);
[phase,amplitude] = analytic_phase(theta);
cycles = cycle_by_cycle(theta,fs);

% Somente spikes já extraídos; timestamps em segundos:
unit_id = data.waveform_cluster(1);
t = double(data.spike_timestamp(data.spike_cluster==unit_id));
rate = firing_rate(t,0,size(data.lfp_3,2)/fs);
```

Ao selecionar uma unidade, confira o vínculo entre cluster, brain area e timestamps.
Não derive duração do registro com `numel` sobre uma matriz multicanal.

## Buscas bibliográficas em avaliação

O arquivo [searches.tsv](searches.tsv) registra as pesquisas externas que
alimentam a triagem metodológica, separadas dos artigos verificados de
[METHODS.tsv](METHODS.tsv). Uma busca compartilhada do Consensus
(`Métodos em eletrofisiologia computacional`) foi recuperada por
integração com a conta Consensus em 2026-10-11. O relatório original
com citações preservadas está em [research/consensus_methodological_review.md](research/consensus_methodological_review.md).
O relatório principal vincula **54 publicações** no índice
[research/consensus_citation_index.tsv](research/consensus_citation_index.tsv).
**10 referências** foram triadas individualmente e tiveram seus DOI e dados
editoriais conferidos, registradas em
[references/consensus_verified.bib](references/consensus_verified.bib).
As outras **44 referências** estão em estágio de rastreabilidade, não ainda
aprovadas para inclusão metodológica individual.

As duas funções adicionais são
`victor_purpura_distance.m` (métrica de edição para spike trains,
custo de deslocamento q/s) e `pac_mean_vector_length.m`
(estimativa de vetor médio fase-amplitude, bruta e normalizada).
As versões científicas completas de eMI, MRCSA, sliceTCA, PAC multitaper,
modelos calibrados de contaminação e testes de permutação clusterizados
permanecem explicitamente pendentes. A coluna status em METHODS.tsv não
deve ser interpretada como garantia de fidelidade à implementação publicada.

Teste sintético adicional:
```matlab
run('arsenal/tests/smoke_consensus_methods.m')
run('arsenal/tests/smoke_bosc_circ_glm.m')
```

## Famílias presentes

- **Espectro, oscilações e separação:** Welch, multitaper, Morlet,
  fase/amplitude de Hilbert, inclinação 1/f simples, candidatos a picos,
  IRASA simplificado, EMD/EEMD exploratórios, ciclos, CSD, entropias.
- **Acoplamento LFP–LFP e spike–LFP:** PLV, PPC, PLI, wPLI,
  MI fase-amplitude, coerência, PSI simplificado e controles surrogates.
- **Eventos e unidades:** detecção de candidatos ripple, threshold de spikes
  (somente broadband), forma de onda, PCA de waveforms e template similarity.
- **Spike trains:** binning, firing rate, ISI, ACG, CCG, PSTH, Fano e
  spike-triggered average.
- **Populações:** PCA, participation ratio, PCA de assemblies,
  expressão de assemblies e noise correlations.
- **Modelos e inferência:** GLM de Poisson aproximado, Granger VAR,
  informação mútua, transfer entropy plug-in, bootstrap iid,
  randomização pareada e jitter de spikes.

## Geometria e dinâmica de populações (seleção complementar)

O catálogo `references/population_geometry.bib` reúne as 20 referências
fornecidas para esta expansão, com anos e autores revisados. Quatro trabalhos
já constavam no índice e foram atualizados sem duplicação por DOI.
Uma preprint de Heller & David (2021) é identificada como predecessora
do artigo publicado em 2022; Do & Yau (2010) e Juavinett et al. (2017)
permanecem registrados por proveniência, mas **fora do critério
de método de análise eletrofisiológica**.

Primitivas adicionadas, uma por arquivo: `eigenspectrum_powerlaw`,
`population_dimension_scaling`, `condition_marginalization`,
`targeted_dimensionality_reduction`, `linear_discriminability`,
`reduced_rank_regression`, `communication_subspace_projection`,
`jpca_dynamics`, `tensor_cp_als`, `gaussian_process_smoothing`,
`crossvalidated_ridge_decoder`.

### Exemplo sintético

```matlab
rng(17)
x = randn(100,20);
labels = [zeros(50,1); ones(50,1)];
x(51:end,1) = x(51:end,1) + 2;

projection = targeted_dimensionality_reduction(x,labels);
result = crossvalidated_ridge_decoder(x,labels,5,1);
scale = population_dimension_scaling(x,[5 10 20],10,42);
```

**Não há equivalência automática** entre os arquivos pequenos e os
algoritmos originais. `tensor_cp_als` é apenas CP/ALS sem todo o
pipeline TCA, `gaussian_process_smoothing` não é GPFA,
`condition_marginalization` não é dPCA completo, `jpca_dynamics`
não reproduz todo o pipeline jPCA, e o decodificador ridge não é o
Gaussian-Process Multiclass Regression de Greenidge et al.

Para resultados publicáveis, selecionar posto, regularização, projeções
e hiperparâmetros exclusivamente no conjunto de treinamento. A estrutura
de trials deve ser preservada na validação cruzada para evitar leakage.

## Spike sorting em larga escala e field potentials

Os seis artigos checados nesta rodada estão em
[large_scale_ephys.bib](references/large_scale_ephys.bib).
O artigo de Buccino et al. (2026) já constava em METHODS.tsv e foi
atualizado, não duplicado. Recursos externos e seus estados de manutenção
constam em [resources.tsv](resources.tsv). Em particular, a antiga biblioteca
Allen ecephys_spike_sorting é **legada e sem manutenção**. O pipeline atual
da Allen Neural Dynamics utiliza SpikeInterface/Nextflow e permite Kilosort4.

**Funções novas (13):**

- `spike_refractory_violations`, `spike_presence_ratio`,
  `spike_sorting_agreement`, `spike_waveform_snr`,
  `spike_waveform_extraction`, `spike_waveform_average`;
- `common_median_reference`, `bipolar_reference_lfp`,
  `spike_field_coherence`, `multitaper_coherence`,
  `wavelet_coherence`;
- `field_potential_forward`, `field_potential_inverse_tikhonov`.

Essas funções são **primitivas**, não um sorter profundo, um pipeline
de Neuropixels ou implementações equivalentes ao Kilosort4 e ao SpikeInterface.
A comparação de eventos `spike_sorting_agreement` pressupõe que uma unidade
de referência já esteja pareada a uma unidade predita; não resolve matching
entre múltiplas unidades. `spike_presence_ratio` depende dos bins e taxa de
disparo; a fração de violação refratária não é estimativa calibrada de
contaminação. Para `spike_waveform_extraction`, usar exclusivamente
sinal **broadband AP** (por exemplo, 30 kHz) e amostras com índice **MATLAB
iniciado em 1**, nunca LFP CON2PHYS a 500 Hz.

As funções de referência e coerência aceitam recortes finitos por canal.
`wavelet_coherence` usa suavização temporal apenas, sem suavização entre
escalas ou tratamento integral do cone de influência; deve permanecer
exploratória. `field_potential_forward` e
`field_potential_inverse_tikhonov` exigem matriz de sensibilidade
física fornecida externamente. A reconstrução por Tikhonov **não recupera
uma fonte fisiológica única**. Dados de EEG/LFP não permitem deduzir
excitação/inibição ou neuromodulação diretamente a partir de uma simples
regressão inversa.

Os frameworks e cursos usados como fontes de comparação:
[SpikeInterface](https://github.com/SpikeInterface/spikeinterface),
[Kilosort4](https://github.com/MouseLand/Kilosort),
[AIND Ephys Pipeline](https://github.com/AllenNeuralDynamics/aind-ephys-pipeline) e
[iBOTS LFP Analysis](https://learn.ibots-bonn.de/docs/lfp_analysis/).

### Teste complementar

```matlab
run('arsenal/tests/smoke_ephys_methods.m')
run('arsenal/tests/smoke_consensus_methods.m')
```

Esse teste gera dados sintéticos e confere contratos básicos. Não substitui
verificação contra waveforms com ground truth, testes de unidades duplicadas,
efeitos da geometria laminar ou comparações com código de referência.

## Oscilações BOSC, estatística circular e GLM acoplado

Seis novas referências foram registradas em
[references/bosc_circular_glm.bib](references/bosc_circular_glm.bib),
incluindo correções bibliográficas de Whitten, Kajikawa e Linderman.

- `bosc_detect`: triagem de episódios oscilatórios com wavelets Morlet,
  modelo global de fundo espectral em log-log, limite de potência da
  distribuição exponencial e duração mínima em ciclos.
- `oscillation_episode`: converte excedências binárias por amostra
  em episódios sustentados, com início, fim, duração e fração temporal.
- `circular_mean`, `rayleigh_test`: média circular (com pesos, quando
  aplicável) e teste de não uniformidade de Rayleigh. Entradas em radianos;
  observações dependentes exigem testes que respeitem a correlação temporal.
- `spike_history_design`: matriz causal de regressores defasados,
  sem observar spikes presentes/futuros.
- `coupling_filters`: ajusta um GLM Poisson por unidade usando apenas
  o histórico dos disparos de todas as unidades; devolve coeficientes
  alvo x fonte x lag. Os coeficientes são dependências preditivas
  condicionais, **não sinapses nem evidência de causalidade física**.

A função BOSC é uma **versão exploratória**: o ajuste global do
fundo pode ser contaminado por picos, não há adaptação a mudanças de
estado, e episódios próximos das bordas da wavelet são excluídos.
A implementação não equivale a eBOSC. Os estimadores circulares não
reproduzem a toolbox CircStat inteira, e a inferência do coupled GLM
não reproduz a reconstrução/decodificação populacional de Pillow et al.

O método rSLDS de Linderman et al. permanece **planejado**:
`slds_inference.m` não foi criado artificialmente como placeholder,
pois dependerá de inferência aproximada probabilística e validação
com estados latentes simulados. O estudo de Cunningham & Yu foi
atualizado no catálogo com aplicações a manifolds, sem duplicação.

Os DOIs enviados para Whitten, Kajikawa e Linderman não
correspondiam aos artigos citados. As referências corretas são:
Whitten (2011) `10.1016/j.neuroimage.2010.08.064`;
Kajikawa & Schroeder (2011) `10.1016/j.neuron.2011.09.029`;
Linderman et al. (2017) está em PMLR 54, pp. 914-922, AISTATS,
com URL bibliográfica, sem reutilizar o DOI IEEE informado.

```matlab
run('arsenal/tests/smoke_bosc_circ_glm.m')
```

A existência desses testes **não significa que tenham sido executados**.
O arquivo `METHODS.tsv` contém seis colunas separadas por TAB,
inclusive DOI vazio quando não confirmado.

## Contratos e limites

1. Funções usam valores e parâmetros explícitos; não acessam `data` nem
   variáveis do workspace por conta própria. Timestamps são segundos;
   amostragem em Hz; fase em radianos.
2. LFP CON²PHYS tem Nyquist de **250 Hz**. O spike detector opera apenas
   sobre sinal broadband na taxa real de aquisição, não sobre LFP a 500 Hz.
3. `spectral_peak_candidates` e `aperiodic_slope` **não** implementam
   o algoritmo completo FOOOF/specparam. `cycle_by_cycle` omite critérios
   de bursts. `current_source_density` é diferença finita, não iCSD.
4. `irasa_decomposition`, `empirical_mode_decomposition` e
   `ensemble_empirical_mode_decomposition` são formulações exploratórias,
   não reproduções auditadas dos artigos.
5. `template_match_waveforms` **não é Kilosort4**, e
   `population_pca` **não é** GPFA, LFADS, jPCA ou dPCA.
6. `modulation_index`, Granger, informação mútua e transfer entropy
   demandam surrogates, análise de viés e pressupostos específicos antes
   de conclusões sobre acoplamento, direção ou causalidade.
7. Processar LFP inteiro pode consumir muitos GiB: passar **blocos** de
   canais; não assumir que todas as funções são streaming ou memmap-ready.
8. Para inferência em múltiplos animais, o animal deve ser unidade
   experimental, não milhões de bins pseudorreplicados.

## Compatibilidade e validação

Alvo: MATLAB R2019a ou superior; várias rotinas dependem da
**Signal Processing Toolbox** (`pwelch`, `dpss`, `hilbert`,
`butter`, `filtfilt`, `findpeaks`, `resample`).

```matlab
run('arsenal/tests/smoke_arsenal.m')
run('arsenal/tests/smoke_population.m')
run('arsenal/tests/smoke_ephys_methods.m')
```

O smoke test é sintético; não substitui testes de referência, comparação
com implementações originais, experimentos surrogates e análise estatística.
**MATLAB não estava disponível no ambiente de autoria, portanto o smoke test
não foi executado.** Nenhuma convergência, acurácia ou equivalência numérica
entre implementações e artigos é afirmada.

## Próxima fase

Implementar testes de referência por artigo, aferir streaming/memmap,
controle de borda em convoluções, qualidade de unidade, jitter condicional
rigoroso, null models para assemblies, surrogates de PAC, ICSD inversa,
cluster permutations, GPFA/LFADS/dPCA e benchmarking de spike sorting.
