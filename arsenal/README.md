# Arsenal metodológico — CON²PHYS

**Status: rascunho exploratório, não validado para inferência científica.**

Este diretório contém funções MATLAB reutilizáveis extraídas das operações
matemáticas relevantes para métodos publicados em eletrofisiologia. A unidade
de implementação é **uma função pública por arquivo `.m`** em [Path](Path/).
O arquivo [METHODS.tsv](METHODS.tsv) registra 60 entradas bibliográficas
e associa artigos a primitivas, limitações e métodos ainda não reproduzidos.

## Organização

```text
arsenal/
  README.md
  METHODS.tsv
  Path/
    welch_psd.m
    multitaper_psd.m
    ...
  tests/
    smoke_arsenal.m
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

Para o último exemplo, a duração correta é
`size(data.lfp_3,2)/fs`, não `numel(data.lfp_3)/fs` quando há vários canais.

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
