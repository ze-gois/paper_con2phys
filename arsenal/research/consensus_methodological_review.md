# Métodos em Eletrofisiologia Computacional

**Question:** Estamos agora buscando arsenal metodológico em neurociências computacional. Buscamos uma miríade de artigos científicos em eletrofisiologia com o critério de inclusão ser o método de analise empregado.

# Arsenal **Metodológico** em **Eletrofisiologia**

## 1. Introduction

A literatura em eletrofisiologia computacional oferece, de fato, um arsenal metodológico amplo, mas ele não é um conjunto de técnicas intercambiáveis: a escolha do método depende do tipo de sinal, da hipótese biológica, da escala de análise e dos principais vieses esperados. Revisões e toolboxes centrais convergem em pelo menos seis famílias analíticas recorrentes: pré-processamento, spike sorting e controle de qualidade, análise espectral e tempo-frequência, conectividade funcional/efetiva, estatística de trens de spikes, e modelagem de dinâmica populacional em espaço latente [[1.1]](https://consensus.app/papers/the-applied-principles-of-eeg-analysis-methods-in-zhang-zhou/60457e9f07c1552180cb82a00c730e80/)[[1.2]](https://consensus.app/papers/the-applied-principles-of-eeg-analysis-methods-in-zhang-zhou/60457e9f07c1552180cb82a00c730e80/)[[2.1]](https://consensus.app/papers/a-tutorial-review-of-functional-connectivity-analysis-bastos-schoffelen/8252cc33a38a591fa0bc210ec42db794/)[[2.2]](https://consensus.app/papers/a-tutorial-review-of-functional-connectivity-analysis-bastos-schoffelen/8252cc33a38a591fa0bc210ec42db794/)[[3.1]](https://consensus.app/papers/dimensionality-reduction-for-largescale-neural-cunningham-yu/1ca0c08948f9582596e162e4f894c348/)[[3.2]](https://consensus.app/papers/dimensionality-reduction-for-largescale-neural-cunningham-yu/1ca0c08948f9582596e162e4f894c348/)[[4.1]](https://consensus.app/papers/meg-and-eeg-data-analysis-with-mnepython-gramfort-luessi/9092c1bf4416565e97bfdfe539d73758/)[[5.1]](https://consensus.app/papers/fieldtrip-open-source-software-for-advanced-analysis-of-oostenveld-fries/cc9920537ced550abc50cb04c67a8fd0/).

O ponto de consenso mais forte é negativo: não existe um “melhor método” universal. Isso aparece em conectividade EEG, em reconstrução de fontes EEG/MEG, em decomposição de dinâmica populacional e em spike sorting, onde desempenho e interpretabilidade mudam com SNR, geometria do problema, estrutura dos dados e pergunta experimental [[6.1]](https://consensus.app/papers/connectivity-analysis-in-eeg-data-a-tutorial-review-of-the-chiarion-sparacino/8159705e405652928643c8a49f19f517/)[[6.2]](https://consensus.app/papers/connectivity-analysis-in-eeg-data-a-tutorial-review-of-the-chiarion-sparacino/8159705e405652928643c8a49f19f517/)[[7.1]](https://consensus.app/papers/quantitative-evaluation-in-estimating-sources-halder-talwar/8c0997aa715952c790995d5005a1fc17/)[[8.1]](https://consensus.app/papers/towards-an-objective-evaluation-of-eegmeg-source-hauk-stenroos/4cf98834c78f5040a8f9547ea6e9376e/)[[9.1]](https://consensus.app/papers/dynamics-on-the-manifold-identifying-computational-duncker-sahani/e28949ac5a9c5224a7434d4cacac0aae/)[[10.1]](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)[[11.1]](https://consensus.app/papers/assessing-crosscontamination-in-spikesorted-vincent-economo/d7bae91adf665281ac8c3618c9ba4310/).

Ao mesmo tempo, a literatura é madura o suficiente para organizar um critério de inclusão “pelo método empregado”. Há classes bem estabelecidas de métodos, benchmarks comparativos, revisões tutoriais, e ecossistemas de software reprodutíveis para EEG/MEG, LFP, spikes extracelulares e patch clamp [[12.1]](https://consensus.app/papers/efficient-and-reproducible-pipelines-for-spike-sorting-buccino-sridhar/93f9021c836958b48640584131406b26/)[[12.2]](https://consensus.app/papers/efficient-and-reproducible-pipelines-for-spike-sorting-buccino-sridhar/93f9021c836958b48640584131406b26/)[[10.2]](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)[[13.1]](https://consensus.app/papers/elephant-–-opensource-tool-for-the-analysis-of-yegenoglu-holstein/5a7b4f339d62516e80337769bc6cf19b/)[[14.1]](https://consensus.app/papers/neuromatic-an-integrated-opensource-software-toolkit-for-rothman-silver/82de1723ca6c52be849fd7dd0410a470/)[[15.1]](https://consensus.app/papers/exploring-brain-networks-using-noninvasive-leahy-medani/4249ed3270bc5fa0b1c5d9bbf1022d4a/).




## 2. Methods

A busca foi conduzida no Consensus sobre um universo de mais de 220 milhões de artigos científicos indexados em Semantic Scholar, PubMed e outras bases. O foco foi construir uma revisão metodológica orientada por técnica analítica, cobrindo sinais extracelulares, EEG/MEG, LFP, trens de spikes, conectividade, dinâmica populacional e eletrofisiologia intracelular.

Foram priorizados artigos metodológicos, benchmarks, revisões tutoriais, protocolos reprodutíveis e papers fundacionais de novas classes analíticas. Em seguida, as referências e citações de revisões centrais foram usadas para recuperar linhagens metodológicas e trabalhos comparativos que explicitam pressupostos, limitações e critérios de validação.




A estratégia combinou buscas semânticas por família analítica com rastreamento de referências de revisões fundacionais e benchmarks.

## 3. Results

### 3.1 Key Papers

Alguns artigos funcionam como âncoras porque não apenas introduzem métodos, mas também organizam campos inteiros de análise. Entre eles estão as revisões de redução de dimensionalidade, conectividade funcional, e espectros neurais periódicos/aperiódicos, além de plataformas abertas que operacionalizam pipelines complexos em EEG/MEG e spikes [[3.2]](https://consensus.app/papers/dimensionality-reduction-for-largescale-neural-cunningham-yu/1ca0c08948f9582596e162e4f894c348/)[[2.3]](https://consensus.app/papers/a-tutorial-review-of-functional-connectivity-analysis-bastos-schoffelen/8252cc33a38a591fa0bc210ec42db794/)[[16.1]](https://consensus.app/papers/parameterizing-neural-power-spectra-into-periodic-and-donoghue-haller/cc7667c3143e5b0fae2aa5f742b1bc2c/)[[4.1]](https://consensus.app/papers/meg-and-eeg-data-analysis-with-mnepython-gramfort-luessi/9092c1bf4416565e97bfdfe539d73758/)[[5.1]](https://consensus.app/papers/fieldtrip-open-source-software-for-advanced-analysis-of-oostenveld-fries/cc9920537ced550abc50cb04c67a8fd0/).

| Paper | Summary |
|---|---|
|  | Guia de seleção em redução dimensional [[3.2]](https://consensus.app/papers/dimensionality-reduction-for-largescale-neural-cunningham-yu/1ca0c08948f9582596e162e4f894c348/) |
|  | Taxonomia e armadilhas em conectividade [[2.2]](https://consensus.app/papers/a-tutorial-review-of-functional-connectivity-analysis-bastos-schoffelen/8252cc33a38a591fa0bc210ec42db794/) |
|  | Separa componentes periódicos e aperiódicos [[16.1]](https://consensus.app/papers/parameterizing-neural-power-spectra-into-periodic-and-donoghue-haller/cc7667c3143e5b0fae2aa5f742b1bc2c/) |



### 3.2 Comparison of Method Families

| Dimension | Spike/Spikes | EEG/MEG/LFP | Population Dynamics | Citations |
|---|---|---|---|---|
| Core task | Detect, sort, decode | Spectra, coupling, sources | Infer latent trajectories | [[17.1]](https://consensus.app/papers/decoding-spikes-from-multiunit-data-farina-yu/bf57ed0464185cafbac68b6d274e5b80/)[[1.3]](https://consensus.app/papers/the-applied-principles-of-eeg-analysis-methods-in-zhang-zhou/60457e9f07c1552180cb82a00c730e80/)[[9.2]](https://consensus.app/papers/dynamics-on-the-manifold-identifying-computational-duncker-sahani/e28949ac5a9c5224a7434d4cacac0aae/) |
| Common models | Clustering, GLM, Bayesian | Fourier, wavelet, inverse models | GPFA, LDS, autoencoders | [[17.2]](https://consensus.app/papers/decoding-spikes-from-multiunit-data-farina-yu/bf57ed0464185cafbac68b6d274e5b80/)[[5.1]](https://consensus.app/papers/fieldtrip-open-source-software-for-advanced-analysis-of-oostenveld-fries/cc9920537ced550abc50cb04c67a8fd0/)[[18.1]](https://consensus.app/papers/inferring-singletrial-neural-population-dynamics-using-pandarinath-o’shea/e306d9fb007151b7b008172ad91af544/) |
| Main confounds | Contamination, labels, drift | Volume conduction, 1/f, artifacts | Sampling, identifiability | [[11.2]](https://consensus.app/papers/assessing-crosscontamination-in-spikesorted-vincent-economo/d7bae91adf665281ac8c3618c9ba4310/)[[2.4]](https://consensus.app/papers/a-tutorial-review-of-functional-connectivity-analysis-bastos-schoffelen/8252cc33a38a591fa0bc210ec42db794/)[[19.1]](https://consensus.app/papers/simulation-of-frontoparietal-neural-population-activity-filippow/ace0dd9bd1685ff2bfd54af31b71e0d7/) |
| Best validation | Ground truth benchmarks | Simulations plus resolution metrics | Prediction and latent recovery | [[10.2]](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)[[8.2]](https://consensus.app/papers/towards-an-objective-evaluation-of-eegmeg-source-hauk-stenroos/4cf98834c78f5040a8f9547ea6e9376e/)[[20.1]](https://consensus.app/papers/bayesian-inference-of-structured-latent-spaces-from-meng-bouchard/2098f19c2a0c56c086713c7ec70f3521/) |
| Reproducible tools | SpikeForest, Elephant | MNE, FieldTrip, Brainstorm | Often custom but growing | [[10.2]](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)[[13.1]](https://consensus.app/papers/elephant-–-opensource-tool-for-the-analysis-of-yegenoglu-holstein/5a7b4f339d62516e80337769bc6cf19b/)[[4.1]](https://consensus.app/papers/meg-and-eeg-data-analysis-with-mnepython-gramfort-luessi/9092c1bf4416565e97bfdfe539d73758/) |

A maior diferença prática é que spikes, campos e atividade populacional exigem critérios distintos de validação. Spike sorting depende fortemente de benchmarking com ground truth e métricas de isolamento, enquanto EEG/MEG depende de análise de vazamento espacial, modelagem da cabeça e mitigação de volume conduction; já modelos latentes são avaliados sobretudo por recuperação de trajetórias, predição neural e interpretabilidade [[10.3]](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)[[8.3]](https://consensus.app/papers/towards-an-objective-evaluation-of-eegmeg-source-hauk-stenroos/4cf98834c78f5040a8f9547ea6e9376e/)[[21.1]](https://consensus.app/papers/comparison-of-the-spatial-resolution-of-source-imaging-hedrich-pellegrino/ddb12ec771105a0188475438cacc4690/)[[22.1]](https://consensus.app/papers/dynamical-flexible-inference-of-nonlinear-latent-factors-abbaspourazad-erturk/3ba85e08da7f5097b7bcab28be99dec9/)[[23.1]](https://consensus.app/papers/variational-latent-gaussian-process-for-recovering-zhao-park/d06c5863b6fa59ef84beadb254398ff0/).

### 3.3 Themes

Em spike sorting, a literatura recente converge para automação, escalabilidade e benchmarking reprodutível. Pipelines paralelizáveis e benchmarks comunitários foram desenvolvidos porque datasets de milhares de canais tornaram a triagem manual um gargalo, e comparações anteriores eram frequentemente enviesadas ou difíceis de reproduzir [[12.3]](https://consensus.app/papers/efficient-and-reproducible-pipelines-for-spike-sorting-buccino-sridhar/93f9021c836958b48640584131406b26/)[[12.4]](https://consensus.app/papers/efficient-and-reproducible-pipelines-for-spike-sorting-buccino-sridhar/93f9021c836958b48640584131406b26/)[[10.4]](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)[[10.5]](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)[[24.1]](https://consensus.app/papers/spike-sorting-with-kilosort4-pachitariu-sridhar/d58683bcc8685f109420696fc9cc9bb0/)[[24.2]](https://consensus.app/papers/spike-sorting-with-kilosort4-pachitariu-sridhar/d58683bcc8685f109420696fc9cc9bb0/).

Em análise espectral, a principal mudança conceitual foi abandonar a suposição de que potência em banda equivale a oscilação. A separação entre componentes oscilatórios e aperiódicos tornou-se central porque mudanças em 1/f podem confundir estimativas de potência e conectividade, e métodos como IRASA, FOOOF/specparam e extensões bivariadas foram propostos justamente para isolar esses componentes [[25.1]](https://consensus.app/papers/separating-neural-oscillations-from-aperiodic-1f-gerster-waterstraat/f8e9975bc3bb5272aeb5603c1bcc79c1/)[[25.2]](https://consensus.app/papers/separating-neural-oscillations-from-aperiodic-1f-gerster-waterstraat/f8e9975bc3bb5272aeb5603c1bcc79c1/)[[16.2]](https://consensus.app/papers/parameterizing-neural-power-spectra-into-periodic-and-donoghue-haller/cc7667c3143e5b0fae2aa5f742b1bc2c/)[[16.3]](https://consensus.app/papers/parameterizing-neural-power-spectra-into-periodic-and-donoghue-haller/cc7667c3143e5b0fae2aa5f742b1bc2c/)[[26.1]](https://consensus.app/papers/separating-fractal-and-oscillatory-components-in-the-wen-liu/776e2b6b0c215a16a1a38be487453312/)[[27.1]](https://consensus.app/papers/multipleresampling-crossspectral-analysis-an-unbiased-racz-czoch/36d69c1c6b2c528597a5075e20c42aea/).

Em modelagem populacional, há uma linha evolutiva clara de PCA para métodos probabilísticos, dinâmicos, supervisionados e não lineares. PCA continua útil como resumo de estrutura compartilhada, mas falha em recuperar variáveis latentes de forma não misturada; por isso surgiram GPFA, vLGP, LFADS, dPCA, TCA, sliceTCA, OSLMM, DFINE, MARBLE e variantes de equações diferenciais neurais [[19.2]](https://consensus.app/papers/simulation-of-frontoparietal-neural-population-activity-filippow/ace0dd9bd1685ff2bfd54af31b71e0d7/)[[19.3]](https://consensus.app/papers/simulation-of-frontoparietal-neural-population-activity-filippow/ace0dd9bd1685ff2bfd54af31b71e0d7/)[[28.1]](https://consensus.app/papers/functional-but-not-anatomical-separation-of-what-and-when-shenoy-sahani/a43135d1b95a52dc82610a7dd118763c/)[[23.2]](https://consensus.app/papers/variational-latent-gaussian-process-for-recovering-zhao-park/d06c5863b6fa59ef84beadb254398ff0/)[[29.1]](https://consensus.app/papers/demixed-principal-component-analysis-of-neural-kobak-brendel/1a180a1c9b555f9bab98bb46f794fe53/)[[30.1]](https://consensus.app/papers/unsupervised-discovery-of-demixed-lowdimensional-neural-williams-kim/3cb013fe9c455e3fb7e606f81a621ad4/)[[31.1]](https://consensus.app/papers/dimensionality-reduction-beyond-neural-subspaces-with-pellegrino-stein/79c26b3827875259a49f731dfd7342b1/)[[20.2]](https://consensus.app/papers/bayesian-inference-of-structured-latent-spaces-from-meng-bouchard/2098f19c2a0c56c086713c7ec70f3521/)[[22.2]](https://consensus.app/papers/dynamical-flexible-inference-of-nonlinear-latent-factors-abbaspourazad-erturk/3ba85e08da7f5097b7bcab28be99dec9/)[[32.1]](https://consensus.app/papers/marble-interpretable-representations-of-neural-gosztolai-peach/8df590dfc6225f349a82affbfd8a9814/)[[33.1]](https://consensus.app/papers/inferring-latent-dynamics-underlying-neural-population-kim-luo/7e4068b7a0345c0e8731a5ceb5f95813/).

### 3.4 Methodological Pitfalls

A literatura é especialmente rica em alertas contra interpretações excessivas. Em EEG/MEG, testes de permutação por clusters resolvem o problema de comparações múltiplas, mas não estabelecem precisamente latência ou localização do efeito no nível de ponto temporal ou sensor [[34.1]](https://consensus.app/papers/clusterbased-permutation-tests-of-megeeg-data-do-not-sassenhagen-draschkow/bc34baff00dc58fd847040bb5c9b8222/)[[34.2]](https://consensus.app/papers/clusterbased-permutation-tests-of-megeeg-data-do-not-sassenhagen-draschkow/bc34baff00dc58fd847040bb5c9b8222/)[[35.1]](https://consensus.app/papers/using-cluster‐based-permutation-tests-to-estimate-megeeg-rousselet/302f1749082f5a82ae8bd7d59d9454bf/).

Em PAC e acoplamentos cruzados, vários estudos mostraram que filtros, harmônicos, formas de onda não sinusoidais e surrogates inadequados podem gerar acoplamentos espúrios. Isso motivou ferramentas mais robustas, como eMI, estimadores multitaper e abordagens que combinam múltiplas medidas para separar PAC harmônico de não harmônico [[36.1]](https://consensus.app/papers/addressing-pitfalls-in-phaseamplitude-coupling-analysis-jurkiewicz-hunt/4663550e59fa5c8fbc9d83adfeae7df6/)[[36.2]](https://consensus.app/papers/addressing-pitfalls-in-phaseamplitude-coupling-analysis-jurkiewicz-hunt/4663550e59fa5c8fbc9d83adfeae7df6/)[[37.1]](https://consensus.app/papers/multitaper-estimates-of-phaseamplitude-coupling-lepage-fleming/aa51e700f7705081b40bc6f90819922d/)[[37.2]](https://consensus.app/papers/multitaper-estimates-of-phaseamplitude-coupling-lepage-fleming/aa51e700f7705081b40bc6f90819922d/)[[38.1]](https://consensus.app/papers/on-crossfrequency-phasephase-coupling-between-theta-and-scheffer-teixeira-tort/3549a988a1df583a979a41653183397e/)[[39.1]](https://consensus.app/papers/dissociating-harmonic-and-nonharmonic-phaseamplitude-giehl-noury/c00c07a3b90b54948de8ba86e755cfdb/).

Em conectividade, referência comum, vazamento espacial e common input continuam sendo problemas estruturais. Revisões e estudos teóricos mostram que coerência e causalidade de Granger podem ser distorcidas por sinais comuns, e que derivações bipolares, análise em espaço-fonte e métricas apropriadas ajudam, mas não eliminam automaticamente o problema [[2.4]](https://consensus.app/papers/a-tutorial-review-of-functional-connectivity-analysis-bastos-schoffelen/8252cc33a38a591fa0bc210ec42db794/)[[6.3]](https://consensus.app/papers/connectivity-analysis-in-eeg-data-a-tutorial-review-of-the-chiarion-sparacino/8159705e405652928643c8a49f19f517/)[[40.1]](https://consensus.app/papers/the-effect-of-common-signals-on-power-coherence-and-granger-cohen-tsuchiya/c786f2b8a8485530892f2ed284125e83/)[[40.2]](https://consensus.app/papers/the-effect-of-common-signals-on-power-coherence-and-granger-cohen-tsuchiya/c786f2b8a8485530892f2ed284125e83/)[[40.3]](https://consensus.app/papers/the-effect-of-common-signals-on-power-coherence-and-granger-cohen-tsuchiya/c786f2b8a8485530892f2ed284125e83/).

### Results Timeline

A literatura metodológica evoluiu de métricas clássicas para pipelines escaláveis e modelos latentes profundos.




Os marcos mais antigos concentram-se em métricas de spike trains, informação e point processes; a fase intermediária consolida software aberto, conectividade e redução de dimensionalidade; a fase recente enfatiza benchmarking, separação de componentes espectrais, inferência latente não linear e reprodutibilidade em larga escala [[41.1]](https://consensus.app/papers/metricspace-analysis-of-spike-trains-theory-algorithms-victor-purpura/4b3fda2767d4594984040424fbb27c90/)[[42.1]](https://consensus.app/papers/a-point-process-framework-for-relating-neural-spiking-truccolo-eden/4b76e12f308250ac82790372e2f7f54a/)[[43.1]](https://consensus.app/papers/dynamic-analyses-of-information-encoding-in-neural-barbieri-frank/6216867396df5af1bfa983d04168348e/)[[5.2]](https://consensus.app/papers/fieldtrip-open-source-software-for-advanced-analysis-of-oostenveld-fries/cc9920537ced550abc50cb04c67a8fd0/)[[4.1]](https://consensus.app/papers/meg-and-eeg-data-analysis-with-mnepython-gramfort-luessi/9092c1bf4416565e97bfdfe539d73758/)[[3.2]](https://consensus.app/papers/dimensionality-reduction-for-largescale-neural-cunningham-yu/1ca0c08948f9582596e162e4f894c348/)[[16.1]](https://consensus.app/papers/parameterizing-neural-power-spectra-into-periodic-and-donoghue-haller/cc7667c3143e5b0fae2aa5f742b1bc2c/)[[10.2]](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)[[22.2]](https://consensus.app/papers/dynamical-flexible-inference-of-nonlinear-latent-factors-abbaspourazad-erturk/3ba85e08da7f5097b7bcab28be99dec9/)[[32.1]](https://consensus.app/papers/marble-interpretable-representations-of-neural-gosztolai-peach/8df590dfc6225f349a82affbfd8a9814/).

### Top Contributors




## 4. Discussion

O corpus mostra um campo metodologicamente maduro, mas fragmentado. A maturidade aparece na existência de benchmarks, protocolos, toolboxes abertos e comparações formais entre classes de métodos; a fragmentação aparece porque diferentes comunidades ainda usam linguagens analíticas distintas para problemas próximos, como sincronia de spikes, conectividade oscilatória e dinâmica latente [[10.6]](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)[[44.1]](https://consensus.app/papers/recommendations-and-publication-guidelines-for-studies-keil-bernat/97872e72b5a35c3bb09a3543dedea847/)[[17.3]](https://consensus.app/papers/decoding-spikes-from-multiunit-data-farina-yu/bf57ed0464185cafbac68b6d274e5b80/)[[45.1]](https://consensus.app/papers/synchrony-oscillations-and-phase-relationships-in-baroni-fulcher/d73bce73d79e5fb9a76e97b43919cf38/).

A evidência mais forte sustenta métodos com ecossistemas de validação explícitos. Spike sorting é um exemplo: existem frameworks reprodutíveis, dados com ground truth e comparações sistemáticas entre algoritmos, incluindo evidência recente de vantagem do Kilosort4 em condições simuladas difíceis e benchmarks em larga escala [[12.2]](https://consensus.app/papers/efficient-and-reproducible-pipelines-for-spike-sorting-buccino-sridhar/93f9021c836958b48640584131406b26/)[[12.5]](https://consensus.app/papers/efficient-and-reproducible-pipelines-for-spike-sorting-buccino-sridhar/93f9021c836958b48640584131406b26/)[[10.2]](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)[[24.2]](https://consensus.app/papers/spike-sorting-with-kilosort4-pachitariu-sridhar/d58683bcc8685f109420696fc9cc9bb0/).

A evidência é moderada, e mais dependente de pressupostos, em conectividade, PAC e inferência de fontes. Nesses domínios, os estudos convergem menos para “melhor método” e mais para “melhor correspondência entre hipótese e método”, porque referência comum, leakage espacial, componentes harmônicos, não estacionariedade e SNR alteram substancialmente o resultado [[6.4]](https://consensus.app/papers/connectivity-analysis-in-eeg-data-a-tutorial-review-of-the-chiarion-sparacino/8159705e405652928643c8a49f19f517/)[[2.4]](https://consensus.app/papers/a-tutorial-review-of-functional-connectivity-analysis-bastos-schoffelen/8252cc33a38a591fa0bc210ec42db794/)[[8.4]](https://consensus.app/papers/towards-an-objective-evaluation-of-eegmeg-source-hauk-stenroos/4cf98834c78f5040a8f9547ea6e9376e/)[[39.2]](https://consensus.app/papers/dissociating-harmonic-and-nonharmonic-phaseamplitude-giehl-noury/c00c07a3b90b54948de8ba86e755cfdb/)[[46.1]](https://consensus.app/papers/quantification-of-phaseamplitude-coupling-in-neuronal-hülsemann-naumann/f03bc151176f586e8cd622a6cec3d638/).

Em dinâmica populacional, há grande inovação, mas a interpretação mecanística ainda é o gargalo. Muitos métodos melhoram predição, decodificação ou recuperação de trajetórias, mas nem todos resolvem identificabilidade, interpretação causal ou generalização entre tarefas e escalas; trabalhos recentes explicitamente tratam essas limitações, inclusive o debate entre baixa e alta dimensionalidade efetiva [[22.1]](https://consensus.app/papers/dynamical-flexible-inference-of-nonlinear-latent-factors-abbaspourazad-erturk/3ba85e08da7f5097b7bcab28be99dec9/)[[47.1]](https://consensus.app/papers/learning-identifiable-and-interpretable-latent-models-of-zhou-wei/93ab053a560e5bbe887693da7384a6b9/)[[9.1]](https://consensus.app/papers/dynamics-on-the-manifold-identifying-computational-duncker-sahani/e28949ac5a9c5224a7434d4cacac0aae/)[[48.1]](https://consensus.app/papers/simultaneous-cortexwide-dynamics-of-up-to-1-million-manley-lu/a0e2f4106afb5d858baf16735de9a9ad/)[[49.1]](https://consensus.app/papers/highdimensional-neuronal-activity-from-lowdimensional-schmutz-haydaroğlu/a72ae3dd49cc598fad65165b2446fa88/)[[50.1]](https://consensus.app/papers/probabilistic-decomposed-linear-dynamical-systems-for-chen-mudrik/e70f9571110258ed9a16c2592acf5847/).

| Claim | Evidence Strength | Reasoning | Papers |
|---|---|---|---|
| Método analítico deve ser escolhido pela pergunta e pelo tipo de sinal, não por preferência genérica. |  | Revisões e comparações concordam amplamente e explicitam ausência de método universal. | [[6.1]](https://consensus.app/papers/connectivity-analysis-in-eeg-data-a-tutorial-review-of-the-chiarion-sparacino/8159705e405652928643c8a49f19f517/)[[6.5]](https://consensus.app/papers/connectivity-analysis-in-eeg-data-a-tutorial-review-of-the-chiarion-sparacino/8159705e405652928643c8a49f19f517/)[[1.4]](https://consensus.app/papers/the-applied-principles-of-eeg-analysis-methods-in-zhang-zhou/60457e9f07c1552180cb82a00c730e80/)[[8.5]](https://consensus.app/papers/towards-an-objective-evaluation-of-eegmeg-source-hauk-stenroos/4cf98834c78f5040a8f9547ea6e9376e/) |
| Spike sorting moderno já possui base forte de benchmarking reprodutível. |  | Há múltiplos pipelines, ground truth e comparações sistemáticas entre algoritmos. | [[10.2]](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)[[12.2]](https://consensus.app/papers/efficient-and-reproducible-pipelines-for-spike-sorting-buccino-sridhar/93f9021c836958b48640584131406b26/)[[24.2]](https://consensus.app/papers/spike-sorting-with-kilosort4-pachitariu-sridhar/d58683bcc8685f109420696fc9cc9bb0/)[[51.1]](https://consensus.app/papers/a-fully-automated-approach-to-spike-sorting-chung-magland/1c8a21dac87254229169155d8d4bd9ea/) |
| Separar componentes periódicos e aperiódicos melhora a interpretação espectral. |  | Vários artigos mostram confusão entre potência oscilatória e 1/f e propõem soluções práticas. | [[25.3]](https://consensus.app/papers/separating-neural-oscillations-from-aperiodic-1f-gerster-waterstraat/f8e9975bc3bb5272aeb5603c1bcc79c1/)[[16.2]](https://consensus.app/papers/parameterizing-neural-power-spectra-into-periodic-and-donoghue-haller/cc7667c3143e5b0fae2aa5f742b1bc2c/)[[26.2]](https://consensus.app/papers/separating-fractal-and-oscillatory-components-in-the-wen-liu/776e2b6b0c215a16a1a38be487453312/) |
| Métodos de PAC e conectividade são úteis, mas muito sensíveis a artefatos e pressupostos. |  | A utilidade é repetida, mas com muitas ressalvas sobre harmônicos, surrogates, referência e leakage. | [[46.2]](https://consensus.app/papers/quantification-of-phaseamplitude-coupling-in-neuronal-hülsemann-naumann/f03bc151176f586e8cd622a6cec3d638/)[[36.1]](https://consensus.app/papers/addressing-pitfalls-in-phaseamplitude-coupling-analysis-jurkiewicz-hunt/4663550e59fa5c8fbc9d83adfeae7df6/)[[38.2]](https://consensus.app/papers/on-crossfrequency-phasephase-coupling-between-theta-and-scheffer-teixeira-tort/3549a988a1df583a979a41653183397e/)[[40.4]](https://consensus.app/papers/the-effect-of-common-signals-on-power-coherence-and-granger-cohen-tsuchiya/c786f2b8a8485530892f2ed284125e83/) |
| Pré-processamento EEG “mais agressivo” nem sempre melhora o sinal. |  | Há evidência provocativa recente, mas ainda concentrada em poucos estudos e métricas específicas. | [[52.1]](https://consensus.app/papers/eeg-is-better-left-alone-delorme/2d7c71ef3d425d70abff64282c762b09/)[[52.2]](https://consensus.app/papers/eeg-is-better-left-alone-delorme/2d7c71ef3d425d70abff64282c762b09/)[[53.1]](https://consensus.app/papers/standardizing-eeg-preprocessing-for-crosssite-böttcher-wendiggensen/83bf184213e65701ac6cea12dc820810/) |



## 5. Conclusion

O corpus sustenta um mapeamento metodológico robusto de eletrofisiologia computacional, e ele pode ser organizado com segurança por famílias de análise. A mensagem central é simples: o campo dispõe de muitas técnicas maduras, mas a inclusão de artigos deve ser guiada pelo método empregado, seus pressupostos e seu regime de validação, não apenas pelo domínio biológico [[17.4]](https://consensus.app/papers/decoding-spikes-from-multiunit-data-farina-yu/bf57ed0464185cafbac68b6d274e5b80/)[[17.5]](https://consensus.app/papers/decoding-spikes-from-multiunit-data-farina-yu/bf57ed0464185cafbac68b6d274e5b80/)[[1.5]](https://consensus.app/papers/the-applied-principles-of-eeg-analysis-methods-in-zhang-zhou/60457e9f07c1552180cb82a00c730e80/).

### Research Gaps

A cobertura é ampla nas famílias clássicas, mas desigual nas zonas de interface entre elas. O que mais falta não é variedade de algoritmos, e sim validação cruzada entre classes metodológicas e regras de decisão que liguem explicitamente tipo de hipótese, tipo de sinal e critério de qualidade.



O gap mais evidente está em interpretabilidade e validação mecanística para modelos latentes modernos: métodos como DFINE, MARBLE, OSLMM e dLDS melhoram inferência e predição, mas a literatura ainda enfatiza recuperação de trajetórias mais do que validação causal ou biológica direta [[22.1]](https://consensus.app/papers/dynamical-flexible-inference-of-nonlinear-latent-factors-abbaspourazad-erturk/3ba85e08da7f5097b7bcab28be99dec9/)[[32.2]](https://consensus.app/papers/marble-interpretable-representations-of-neural-gosztolai-peach/8df590dfc6225f349a82affbfd8a9814/)[[20.3]](https://consensus.app/papers/bayesian-inference-of-structured-latent-spaces-from-meng-bouchard/2098f19c2a0c56c086713c7ec70f3521/)[[54.1]](https://consensus.app/papers/decomposed-linear-dynamical-systems-dlds-for-learning-the-mudrik-chen/a5ee007f59e15ff5a9ea0eb48622492d/). Outro gap forte está em conectividade e PAC, onde os confounds são bem documentados, mas persistem porque dependem da física do registro e de escolhas analíticas difíceis de padronizar [[2.4]](https://consensus.app/papers/a-tutorial-review-of-functional-connectivity-analysis-bastos-schoffelen/8252cc33a38a591fa0bc210ec42db794/)[[38.1]](https://consensus.app/papers/on-crossfrequency-phasephase-coupling-between-theta-and-scheffer-teixeira-tort/3549a988a1df583a979a41653183397e/)[[39.2]](https://consensus.app/papers/dissociating-harmonic-and-nonharmonic-phaseamplitude-giehl-noury/c00c07a3b90b54948de8ba86e755cfdb/)[[40.1]](https://consensus.app/papers/the-effect-of-common-signals-on-power-coherence-and-granger-cohen-tsuchiya/c786f2b8a8485530892f2ed284125e83/). Em pré-processamento EEG, a coexistência de pipelines padronizados e críticas ao benefício de correções agressivas mostra que faltam métricas aceitas de qualidade downstream, não apenas novos pipelines [[53.2]](https://consensus.app/papers/standardizing-eeg-preprocessing-for-crosssite-böttcher-wendiggensen/83bf184213e65701ac6cea12dc820810/)[[53.1]](https://consensus.app/papers/standardizing-eeg-preprocessing-for-crosssite-böttcher-wendiggensen/83bf184213e65701ac6cea12dc820810/)[[52.3]](https://consensus.app/papers/eeg-is-better-left-alone-delorme/2d7c71ef3d425d70abff64282c762b09/)[[52.4]](https://consensus.app/papers/eeg-is-better-left-alone-delorme/2d7c71ef3d425d70abff64282c762b09/).

### Open Research Questions

Direções futuras convergem para validação objetiva, integração entre escalas e prevenção de inferências espúrias. As perguntas abaixo concentram as lacunas mais consequentes para um critério de inclusão metodológico.

| Question | Why |
|---|---|
|  | Robustez entre laboratórios ainda é limitada por forte dependência de SNR, leakage, e escolhas de limpeza ou parametrização. |
|  | Modelos recentes já predizem bem, mas ainda faltam critérios amplamente aceitos de interpretabilidade causal. |
|  | As avaliações seguem fragmentadas por subcampo, o que dificulta comparações ponta a ponta e escolhas metodológicas consistentes. |

Para um arsenal metodológico em neurociências computacionais com foco em eletrofisiologia, a melhor síntese é esta: há uma miríade real de métodos, mas eles devem ser selecionados e comparados por família analítica, pressupostos, confounds e regime de validação.

## References

[1] [The applied principles of EEG analysis methods in neuroscience and clinical neurology](https://consensus.app/papers/the-applied-principles-of-eeg-analysis-methods-in-zhang-zhou/60457e9f07c1552180cb82a00c730e80/)
  Hao Zhang, Qin Zhou, He Chen, Xiao-Qing Hu, Wei-Guang Li, Yang Bai, Jun Han, Yao Wang, Zhen-Hu Liang, Dan Chen, F. Cong, Jia-Qing Yan, Xiao-Li Li · 2023 · Military Medical Research · doi:10.1186/s40779-023-00502-7

  > [1.1] Although EEG/iEEG has good practicality, its application requires a certain foundation in signal processing technologies due to the complex representation of EEG signals; this leads to a problem in that some researchers lack clarity in selecting and applying analytical methods for EEG/iEEG. (Body)

  > [1.2] The methods are classified into power spectrum analysis, time–frequency analysis, connectivity analysis, source localization analysis, and machine learning. (Body)

  > [1.3] Second, five main directions for the methods of EEG analysis, including power spectrum analysis, time-frequency analysis, connectivity analysis, source localization methods, and machine learning methods, are described in the main section, along with different sub-methods and effect evaluations for solving the same problem. (Abstract)

  > [1.4] The methods introduced in this review are only a subset of common methods, and users need to make choices based on the characteristics of the data and methods. (Body)

  > [1.5] This article is expected to assist researchers in selecting suitable EEG analysis methods based on their research objectives, provide references for subsequent research, and summarize current issues and prospects for the future. (Abstract)

[2] [A Tutorial Review of Functional Connectivity Analysis Methods and Their Interpretational Pitfalls](https://consensus.app/papers/a-tutorial-review-of-functional-connectivity-analysis-bastos-schoffelen/8252cc33a38a591fa0bc210ec42db794/)
  André M. Bastos, J. Schoffelen · 2016 · Frontiers in Systems Neuroscience · doi:10.3389/fnsys.2015.00175

  > [2.1] The hypothesis that neuronal oscillations in general, and inter-areal synchronization of these oscillations in particular, are instrumental for normal brain function has resulted in widespread application of quantitative methods to evaluate neuronal synchrony in electrophysiological data. (Body)

  > [2.2] In this paper, we have presented a non-exhaustive review of different methods currently used to quantify rhythmic functional connectivity. (Body)

  > [2.3] This tutorial will review and summarize current analysis methods used in the field of invasive and non-invasive electrophysiology to study the dynamic connections between neuronal populations. (Abstract)

  > [2.4] Next, we highlight a number of interpretational caveats and common pitfalls that can arise when performing functional connectivity analysis, including the common reference problem, the signal to noise ratio problem, the volume conduction problem, the common input problem, and the sample size bias problem. (Abstract)

[3] [Dimensionality reduction for large-scale neural recordings](https://consensus.app/papers/dimensionality-reduction-for-largescale-neural-cunningham-yu/1ca0c08948f9582596e162e4f894c348/)
  J. Cunningham, Byron M. Yu · 2014 · Nature neuroscience · doi:10.1038/nn.3776

  > [3.1] Most sensory, cognitive and motor functions depend on the interactions of many neurons. (Abstract)

  > [3.2] We describe the dimensionality reduction methods commonly applied to population activity and offer practical advice about selecting methods and interpreting their outputs. (Abstract)

[4] [MEG and EEG data analysis with MNE-Python](https://consensus.app/papers/meg-and-eeg-data-analysis-with-mnepython-gramfort-luessi/9092c1bf4416565e97bfdfe539d73758/)
  Alexandre Gramfort, M. Luessi, E. Larson, D. Engemann, D. Strohmeier, C. Brodbeck, Roman Goj, M. Jas, Teon L Brooks, L. Parkkonen, M. Hämäläinen · 2013 · Frontiers in Neuroscience · doi:10.3389/fnins.2013.00267

  > [4.1] As part of the MNE software suite, MNE-Python is an open-source software package that addresses this challenge by providing state-of-the-art algorithms implemented in Python that cover multiple methods of data preprocessing, source localization, statistical analysis, and estimation of functional connectivity between distributed brain regions. (Abstract)

[5] [FieldTrip: Open Source Software for Advanced Analysis of MEG, EEG, and Invasive Electrophysiological Data](https://consensus.app/papers/fieldtrip-open-source-software-for-advanced-analysis-of-oostenveld-fries/cc9920537ced550abc50cb04c67a8fd0/)
  R. Oostenveld, P. Fries, E. Maris, J. Schoffelen · 2010 · Computational Intelligence and Neuroscience · doi:10.1155/2011/156869

  > [5.1] It includes algorithms for simple and advanced analysis, such as time-frequency analysis using multitapers, source reconstruction using dipoles, distributed sources and beamformers, connectivity analysis, and nonparametric statistical permutation tests at the channel and source level. (Abstract)

  > [5.2] This paper describes FieldTrip, an open source software package that we developed for the analysis of MEG, EEG, and other electrophysiological data. (Abstract)

[6] [Connectivity Analysis in EEG Data: A Tutorial Review of the State of the Art and Emerging Trends](https://consensus.app/papers/connectivity-analysis-in-eeg-data-a-tutorial-review-of-the-chiarion-sparacino/8159705e405652928643c8a49f19f517/)
  Giovanni Chiarion, Laura Sparacino, Y. Antonacci, L. Faes, L. Mesin · 2023 · Bioengineering · doi:10.3390/bioengineering10030372

  > [6.1] We warn the readers that there is no single optimum method for assessing brain connectivity. (Body)

  > [6.2] The efficiency of the method depends on the specific application and on the assumptions at the basis of the method itself. (Body)

  > [6.3] In addition, the importance of source localization, and the impacts of signal acquisition and pre-processing techniques (e.g., filtering, source localization, and artifact rejection) on the connectivity estimates are recognized and discussed. (Abstract)

  > [6.4] Different approaches to the study of brain connectivity may produce different results, even with reference to the same data. (Body)

  > [6.5] Hence, the selection of the most suitable technique to use for the investigation of brain connectivity is not straightforward as it may seem. (Body)

[7] [Quantitative Evaluation in Estimating Sources Underlying Brain Oscillations Using Current Source Density Methods and Beamformer Approaches](https://consensus.app/papers/quantitative-evaluation-in-estimating-sources-halder-talwar/8c0997aa715952c790995d5005a1fc17/)
  Tamesh Halder, Siddharth Talwar, Amit Jaiswal, A. Banerjee · 2019 · eNeuro · doi:10.1523/eneuro.0170-19.2019

  > [7.1] However, different inverse methods provide different solutions leading to no agreement of which algorithm is the “best method,” as we illustrated in this manuscript with simulated and empirical EEG data. (Body)

[8] [Towards an objective evaluation of EEG/MEG source estimation methods - The linear approach](https://consensus.app/papers/towards-an-objective-evaluation-of-eegmeg-source-hauk-stenroos/4cf98834c78f5040a8f9547ea6e9376e/)
  O. Hauk, M. Stenroos, M. Treder · 2022 · NeuroImage · doi:10.1016/j.neuroimage.2022.119177

  > [8.1] However, they have not yet led to established recommendations or guidelines, and it is still difficult for researchers without a methodological background to establish which methods are most suitable and which parameter settings most optimal for their task at hand. (Body)

  > [8.2] Within this framework it is possible to define resolution metrics that define meaningful aspects of source estimation results (such as localization accuracy in terms of peak localization error, PLE, and spatial extent in terms of spatial deviation, SD) that are relevant to the task at hand and can easily be visualized. (Abstract)

  > [8.3] At the core of this framework is the resolution matrix, which describes the potential leakage from and into point sources (point-spread and cross-talk functions, or PSFs and CTFs, respectively). (Abstract)

  > [8.4] However, their SD as well as both PLE and SD for CTFs are far less optimal for all methods, in particular for deep cortical areas. (Abstract)

  > [8.5] A method that works well for a few focal sources and early evoked potentials may fail for resting state activity or complex distributed sources underlying cognitive processes. (Body)

[9] [Dynamics on the manifold: Identifying computational dynamical activity from neural population recordings.](https://consensus.app/papers/dynamics-on-the-manifold-identifying-computational-duncker-sahani/e28949ac5a9c5224a7434d4cacac0aae/)
  Lea Duncker, M. Sahani · 2021 · Current opinion in neurobiology · doi:10.1016/j.conb.2021.10.014

  > [9.1] We discuss advantages and limitations of different modelling approaches and address future challenges for the field. (Abstract)

  > [9.2] Here, we review methods that aim to quantify structure in neural population recordings through a dynamical system defined in a low-dimensional latent variable space. (Abstract)

[10] [SpikeForest, reproducible web-facing ground-truth validation of automated neural spike sorters](https://consensus.app/papers/spikeforest-reproducible-webfacing-groundtruth-magland-jun/fee1289b4af2541f86b530a769a02d85/)
  J. Magland, J. Jun, Elizabeth Lovero, Alexander J Morley, C. Hurwitz, A. Buccino, Samuel Garcia, A. Barnett · 2020 · eLife · doi:10.7554/elife.55167

  > [10.1] While many spike sorting packages are available, there is little consensus about which are most accurate under different experimental conditions. (Abstract)

  > [10.2] SpikeForest is an open-source and reproducible software suite that benchmarks the performance of automated spike sorting algorithms across an extensive, curated database of ground-truth electrophysiological recordings, displaying results interactively on a continuously-updating website. (Abstract)

  > [10.3] Ten of the most popular spike sorting codes are wrapped in a Python package and evaluated on a compute cluster using an automated pipeline. (Abstract)

  > [10.4] In the past, comparisons between spike sorting algorithms have been biased or limited. (Body)

  > [10.5] The openness and reproducibility of SpikeForest in part remedies this situation. (Body)

  > [10.6] To this end, we seek contributions and input from the electrophysiology community, both to optimize parameter settings for existing algorithms, and to further expand the set of algorithms and ground-truth recordings included in the analysis. (Body)

[11] [Assessing Cross-Contamination in Spike-Sorted Electrophysiology Data](https://consensus.app/papers/assessing-crosscontamination-in-spikesorted-vincent-economo/d7bae91adf665281ac8c3618c9ba4310/)
  J. P. Vincent, Michael N. Economo · 2023 · eNeuro · doi:10.1523/eneuro.0554-23.2024

  > [11.1] This has necessitated both the development of new computational methods for spike sorting and better methods to determine spike-sorting accuracy. (Abstract)

  > [11.2] We find that the relationship between ISIv and FDR is highly nonlinear, with additional dependencies on firing frequency, the correlation in activity between neurons, and contaminant neuron count. (Abstract)

[12] [Efficient and reproducible pipelines for spike sorting large-scale electrophysiology data](https://consensus.app/papers/efficient-and-reproducible-pipelines-for-spike-sorting-buccino-sridhar/93f9021c836958b48640584131406b26/)
  A. Buccino, Arjun Sridhar, David Feng, K. Svoboda, Joshua H. Siegle · 2026 · eLife · doi:10.7554/elife.110170

  > [12.1] By providing an open, transparent, and well-documented framework, we aim to advance reproducibility and efficiency in the analysis of large-scale electrophysiology data. (Body)

  > [12.2] In addition, we introduce a benchmarking pipeline, also optimized for parallel processing, that enables systematic comparison of multiple sorting pipelines. (Abstract)

  > [12.3] Spike sorting, the procedure that extracts spikes from extracellular voltage measurements, remains a major bottleneck: a dataset collected in a few hours can take days to spike sort on a single machine, and the field lacks rigorous validation of the many spike sorting algorithms and preprocessing steps that are in use. (Abstract)

  > [12.4] Here, we present an end-to-end spike sorting pipeline that leverages parallelization to scale to large datasets. (Abstract)

  > [12.5] Using this framework, we show that Kilosort4, a widely used spike sorting algorithm, outperforms Kilosort2.5. (Abstract)

[13] [Elephant – Open-Source Tool for the Analysis of Electrophysiological Data Sets](https://consensus.app/papers/elephant-–-opensource-tool-for-the-analysis-of-yegenoglu-holstein/5a7b4f339d62516e80337769bc6cf19b/)
  Alper Yegenoglu, D. Holstein, L. D. Phan, M. Denker, Andrew P. Davison, S. Grün · 2015

  > [13.1] Elephant is an easy-to-use,open-source Python library, that offers a broad range of functions for analyzing multi-scale data of brain dynamics from experiments and brain simulations. (Abstract)

[14] [NeuroMatic: An Integrated Open-Source Software Toolkit for Acquisition, Analysis and Simulation of Electrophysiological Data](https://consensus.app/papers/neuromatic-an-integrated-opensource-software-toolkit-for-rothman-silver/82de1723ca6c52be849fd7dd0410a470/)
  J. Rothman, R. Silver · 2018 · Frontiers in Neuroinformatics · doi:10.3389/fninf.2018.00014

  > [14.1] To address this, we developed NeuroMatic, an open-source software toolkit that performs data acquisition (episodic, continuous and triggered recordings), data analysis (spike rasters, spontaneous event detection, curve fitting, stationarity) and simulations (stochastic synaptic transmission, synaptic short-term plasticity, integrate-and-fire and Hodgkin-Huxley-like single-compartment models). (Abstract)

[15] [Exploring Brain Networks Using Noninvasive Electrophysiological Measurements: Methods and Applications](https://consensus.app/papers/exploring-brain-networks-using-noninvasive-leahy-medani/4249ed3270bc5fa0b1c5d9bbf1022d4a/)
  R. Leahy, Takfarinas Medani · 2026 · doi:10.48550/arxiv.2607.17602

  > [15.1] Modern end-to-end analysis pipelines are presented, with particular emphasis on Brainstorm and complementary open-source software for reproducible EEG/MEG research. (Abstract)

[16] [Parameterizing neural power spectra into periodic and aperiodic components](https://consensus.app/papers/parameterizing-neural-power-spectra-into-periodic-and-donoghue-haller/cc7667c3143e5b0fae2aa5f742b1bc2c/)
  Thomas Donoghue, Matar Haller, Erik J. Peterson, P. Varma, Priyadarshini Sebastian, Richard Gao, Torben Noto, Antonio H. Lara, J. Wallis, R. Knight, A. Shestyuk, Bradley Voytek · 2020 · Nature neuroscience · doi:10.1038/s41593-020-00744-x

  > [16.1] Here we introduce a novel method for algorithmically extracting periodic and aperiodic components in electro- and magnetophysiological data that addresses these often-overlooked issues in cognitive and systems neuroscience. (Body)

  > [16.2] We show that standard analytic approaches can conflate periodic parameters (center frequency, power, bandwidth) with aperiodic ones (offset, exponent), compromising physiological interpretations. (Abstract)

  > [16.3] To overcome these limitations, we introduce an algorithm to parameterize neural power spectra as a combination of an aperiodic component and putative periodic oscillatory peaks. (Abstract)

[17] [Decoding Spikes From Multiunit Data](https://consensus.app/papers/decoding-spikes-from-multiunit-data-farina-yu/bf57ed0464185cafbac68b6d274e5b80/)
  D. Farina, Tianyi Yu · 2026 · IEEE Reviews in Biomedical Engineering · doi:10.1109/rbme.2025.3647848

  > [17.1] The methods reviewed span classic spike sorting, probabilistic inference, Bayesian frameworks, blind source separation (BSS), and deep learning techniques. (Body)

  > [17.2] Rather than organizing the literature by application domain, we group and critically compare methods by their underlying principles: classical spike sorting, Bayesian and probabilistic inference, blind source separation, and data-driven approaches, including deep learning and hybrid schemes. (Abstract)

  > [17.3] By bridging previously compartmentalized literature, this survey aims to accelerate crosspollination of ideas between application areas and to provide a roadmap for selecting, adapting, and advancing decoding methods across diverse multiunit recording modalities. (Abstract)

  > [17.4] Instead of organizing the discussion by field of application, we group methods by their underlying signal processing principles, irrespective of where they were first developed or mostly used. (Body)

  > [17.5] For each class of methods, we present the core mathematical formulation and algorithmic strategies and discuss assumptions and limitations. (Abstract)

[18] [Inferring single-trial neural population dynamics using sequential auto-encoders](https://consensus.app/papers/inferring-singletrial-neural-population-dynamics-using-pandarinath-o’shea/e306d9fb007151b7b008172ad91af544/)
  C. Pandarinath, D. O’Shea, Jasmine Collins, R. Józefowicz, S. Stavisky, J. Kao, Eric M. Trautmann, Matthew T. Kaufman, S. Ryu, L. Hochberg, J. Henderson, K. Shenoy, L. Abbott, David Sussillo · 2017 · Nature methods · doi:10.1038/s41592-018-0109-9

  > [18.1] We introduce latent factor analysis via dynamical systems, a deep learning method to infer latent dynamics from single-trial neural spiking data. (Abstract)

[19] [Simulation of fronto-parietal neural population activity to probe dimensionality reduction methods.](https://consensus.app/papers/simulation-of-frontoparietal-neural-population-activity-filippow/ace0dd9bd1685ff2bfd54af31b71e0d7/)
  Andrej Filippow · 2022 · doi:10.53846/goediss-9450

  > [19.1] Even though PCA has been analyzed in general, and several conceptual weaknesses have been noted before, the applicability of PCA to neuronal data has not been studied in detail. (Abstract)

  > [19.2] We find that the limiting parameter for PCA is the number of trials recorded per condition. (Abstract)

  > [19.3] Furthermore, principal components are arbitrary linear combinations of the true LVs and it’s impossible to recover the LVs in an unmixed fashion from the results of PCA. (Abstract)

[20] [Bayesian inference of structured latent spaces from neural population activity with the orthogonal stochastic linear mixing model](https://consensus.app/papers/bayesian-inference-of-structured-latent-spaces-from-meng-bouchard/2098f19c2a0c56c086713c7ec70f3521/)
  Rui Meng, Kristofer E. Bouchard · 2024 · PLOS Computational Biology · doi:10.1371/journal.pcbi.1011975

  > [20.1] We demonstrate superior performance of OSLMM on latent trajectory recovery in synthetic experiments and show superior computational efficiency and prediction performance on several real-world benchmark data sets. (Abstract)

  > [20.2] Here, we developed a new latent process Bayesian regression framework, the orthogonal stochastic linear mixing model (OSLMM) which introduces an orthogonality constraint amongst time-varying mixture coefficients, and provide Markov chain Monte Carlo inference procedures. (Abstract)

  > [20.3] Most importantly, in both experimental contexts, we demonstrate that OSLMM latent trajectories directly reflect features of the sounds and reaches, demonstrating that neural dynamics are structured by neural representations. (Abstract)

[21] [Comparison of the spatial resolution of source imaging techniques in high‐density EEG and MEG](https://consensus.app/papers/comparison-of-the-spatial-resolution-of-source-imaging-hedrich-pellegrino/ddb12ec771105a0188475438cacc4690/)
  T. Hedrich, G. Pellegrino, E. Kobayashi, J. Lina, C. Grova · 2017 · Neuroimage · doi:10.1016/j.neuroimage.2017.06.022

  > [21.1] This indicates that cMEM would be a good candidate for studying source localization of focal and extended generators as well as functional connectivity studies. (Abstract)

[22] [Dynamical flexible inference of nonlinear latent factors and structures in neural population activity](https://consensus.app/papers/dynamical-flexible-inference-of-nonlinear-latent-factors-abbaspourazad-erturk/3ba85e08da7f5097b7bcab28be99dec9/)
  Hamidreza Abbaspourazad, Eray Erturk, Bijan Pesaran, M. Shanechi · 2023 · Nature Biomedical Engineering · doi:10.1038/s41551-023-01106-1

  > [22.1] Compared with earlier neural-network models, DFINE enables flexible inference, better predicts neural activity and behaviour, and better captures the latent neural manifold structure. (Abstract)

  > [22.2] To enable flexible inference, we developed a neural network that separates the model into jointly trained manifold and dynamic latent factors such that nonlinearity is captured through the manifold factors and the dynamics can be modelled in tractable linear form on this nonlinear manifold. (Abstract)

[23] [Variational Latent Gaussian Process for Recovering Single-Trial Dynamics from Population Spike Trains](https://consensus.app/papers/variational-latent-gaussian-process-for-recovering-zhao-park/d06c5863b6fa59ef84beadb254398ff0/)
  Yuan Zhao, Il-Su Park · 2016 · Neural Computation · doi:10.1162/neco_a_00953

  > [23.1] These results show that vLGP is a robust method with the potential to reveal hidden neural dynamics from large-scale neural recordings. (Abstract)

  > [23.2] Here, we propose a practical and efficient inference method, the variational latent gaussian process (vLGP). (Abstract)

[24] [Spike sorting with Kilosort4](https://consensus.app/papers/spike-sorting-with-kilosort4-pachitariu-sridhar/d58683bcc8685f109420696fc9cc9bb0/)
  Marius Pachitariu, Shashwat Sridhar, Jacob Pennington, C. Stringer · 2024 · Nature Methods · doi:10.1038/s41592-024-02232-7

  > [24.1] We also report the development of Kilosort4, a version with substantially improved performance due to clustering algorithms inspired by graph-based approaches. (Abstract)

  > [24.2] We found that nearly all versions of Kilosort outperformed other algorithms on a variety of simulated conditions and that Kilosort4 performed best in all cases, correctly identifying even neurons with low amplitudes and small spatial extents in high drift conditions. (Abstract)

[25] [Separating Neural Oscillations from Aperiodic 1/f Activity: Challenges and Recommendations](https://consensus.app/papers/separating-neural-oscillations-from-aperiodic-1f-gerster-waterstraat/f8e9975bc3bb5272aeb5603c1bcc79c1/)
  M. Gerster, G. Waterstraat, V. Litvak, K. Lehnertz, A. Schnitzler, E. Florin, G. Curio, V. Nikulin · 2021 · Neuroinformatics · doi:10.1007/s12021-022-09581-8

  > [25.1] However, the standard analysis of assessing periodic power through bandpass filtering is problematic because the pass-band comprises both periodic and aperiodic activity. (Body)

  > [25.2] For that reason, estimating the 1/f component before determining the power of periodic activity has recently been suggested (Donoghue et al., 2021; Wen &amp; Liu, 2016). (Body)

  > [25.3] If the power of aperiodic activity changes between two conditions, analyzing neural oscillations in bandpass filtered signals would hence be confounded by these changes in the aperiodic part of the spectra. (Body)

[26] [Separating Fractal and Oscillatory Components in the Power Spectrum of Neurophysiological Signal](https://consensus.app/papers/separating-fractal-and-oscillatory-components-in-the-wen-liu/776e2b6b0c215a16a1a38be487453312/)
  Haiguang Wen, Zhong-Ming Liu · 2015 · Brain topography · doi:10.1007/s10548-015-0448-0

  > [26.1] Here, we present a new method, namely the irregular-resampling auto-spectral analysis (IRASA), to separate fractal and oscillatory components in the power spectrum of neurophysiological signal according to their distinct temporal and spectral characteristics. (Abstract)

  > [26.2] We tested this method on simulated data and demonstrated that IRASA could robustly separate the fractal component from the oscillatory component. (Abstract)

[27] [Multiple-Resampling Cross-Spectral Analysis: An Unbiased Tool for Estimating Fractal Connectivity With an Application to Neurophysiological Signals](https://consensus.app/papers/multipleresampling-crossspectral-analysis-an-unbiased-racz-czoch/36d69c1c6b2c528597a5075e20c42aea/)
  F. S. Racz, Akos Czoch, Zalan Kaposzta, Orestis Stylianou, Peter Mukli, A. Eke · 2022 · Frontiers in Physiology · doi:10.3389/fphys.2022.817239

  > [27.1] Here we introduce multiple-resampling cross-spectral analysis (MRCSA) as an extension of IRASA from the univariate to the bivariate case, namely, to separate the fractal component of the cross-spectrum between two simultaneously recorded neural signals by applying the same principle. (Abstract)

[28] [Functional, but Not Anatomical, Separation of "what" and "when" in Prefrontal Cortex Gaussian-process Factor Analysis for Low-dimensional Single-trial Analysis of Neural Population Activity](https://consensus.app/papers/functional-but-not-anatomical-separation-of-what-and-when-shenoy-sahani/a43135d1b95a52dc82610a7dd118763c/)
  V. Shenoy, M. Sahani, Byron M. Yu, J. Cunningham, G. Santhanam, S. Ryu, Krishna, C. Machens, R. Romo, C. Brody, K. Shenoy, Yu Bm, Cunningham Jp, G. Santhanam, Ryu Si, Shenoy Kv, Sahani M. Gaussian, M. Sahani, Gatsby

  > [28.1] We then present a novel method for extracting neural trajectories-Gaussian-process factor analysis (GPFA)-which unifies the smoothing and dimensionality-reduction operations in a common probabilistic framework. (Abstract)

[29] [Demixed principal component analysis of neural population data](https://consensus.app/papers/demixed-principal-component-analysis-of-neural-kobak-brendel/1a180a1c9b555f9bab98bb46f794fe53/)
  D. Kobak, Wieland Brendel, C. Constantinidis, C. Feierstein, Adam Kepecs, Z. Mainen, Xue-Lian Qi, R. Romo, N. Uchida, C. Machens · 2014 · eLife · doi:10.7554/elife.10989

  > [29.1] Here we demonstrate the advantages of a new dimensionality reduction technique, demixed principal component analysis (dPCA), that decomposes population activity into a few components. (Abstract)

[30] [Unsupervised Discovery of Demixed, Low-Dimensional Neural Dynamics across Multiple Timescales through Tensor Component Analysis](https://consensus.app/papers/unsupervised-discovery-of-demixed-lowdimensional-neural-williams-kim/3cb013fe9c455e3fb7e606f81a621ad4/)
  Alex H. Williams, T. H. Kim, Forea Wang, Saurabh Vyas, S. Ryu, K. Shenoy, M. Schnitzer, T. Kolda, Surya Ganguli · 2017 · Neuron · doi:10.1101/211128

  > [30.1] We demonstrate a simple tensor component analysis (TCA) can meet this challenge by extracting three interconnected, low-dimensional descriptions of neural data: neuron factors, reflecting cell assemblies; temporal factors, reflecting rapid circuit dynamics mediating perceptions, thoughts, and actions within each trial; and trial factors, describing both long-term learning and trial-to-trial changes in cognitive state. (Abstract)

[31] [Dimensionality reduction beyond neural subspaces with slice tensor component analysis](https://consensus.app/papers/dimensionality-reduction-beyond-neural-subspaces-with-pellegrino-stein/79c26b3827875259a49f731dfd7342b1/)
  Arthur Pellegrino, H. Stein, N. A. Cayco-Gajic · 2024 · Nature Neuroscience · doi:10.1038/s41593-024-01626-2

  > [31.1] To demix these covariability classes, we develop sliceTCA (slice tensor component analysis), a new unsupervised dimensionality reduction method for neural data tensors. (Abstract)

[32] [MARBLE: interpretable representations of neural population dynamics using geometric deep learning](https://consensus.app/papers/marble-interpretable-representations-of-neural-gosztolai-peach/8df590dfc6225f349a82affbfd8a9814/)
  Adam Gosztolai, R. Peach, Alexis Arnaudon, M. Barahona, P. Vandergheynst · 2023 · Nature Methods · doi:10.1038/s41592-024-02582-2

  > [32.1] We introduce a representation learning method, MARBLE, which decomposes on-manifold dynamics into local flow fields and maps them into a common latent space using unsupervised geometric deep learning. (Abstract)

  > [32.2] Extensive benchmarking demonstrates state-of-the-art within- and across-animal decoding accuracy of MARBLE compared to current representation learning approaches, with minimal user input. (Abstract)

[33] [Inferring Latent Dynamics Underlying Neural Population Activity via Neural Differential Equations](https://consensus.app/papers/inferring-latent-dynamics-underlying-neural-population-kim-luo/7e4068b7a0345c0e8731a5ceb5f95813/)
  T. Kim, T. Z. Luo, J. Pillow, C. Brody · 2021

  > [33.1] Here we address this problem by introducing a low-dimensional nonlinear model for latent neural population dynamics us-ing neural ordinary differential equations (neural ODEs), with noisy sensory inputs and Poisson spike train outputs. (Abstract)

[34] [Cluster-based permutation tests of MEG/EEG data do not establish significance of effect latency or location.](https://consensus.app/papers/clusterbased-permutation-tests-of-megeeg-data-do-not-sassenhagen-draschkow/bc34baff00dc58fd847040bb5c9b8222/)
  Jona Sassenhagen, D. Draschkow · 2019 · Psychophysiology · doi:10.1111/psyp.13335

  > [34.1] They elegantly handle the multiple comparisons problem in high-dimensional magnetoencephalographic and EEG data. (Abstract)

  > [34.2] This leads researchers to statements about the onset or offset of a certain effect that is not supported by the permutation test. (Abstract)

[35] [Using cluster‐based permutation tests to estimate MEG/EEG onsets: How bad is it?](https://consensus.app/papers/using-cluster‐based-permutation-tests-to-estimate-megeeg-rousselet/302f1749082f5a82ae8bd7d59d9454bf/)
  G. Rousselet · 2024 · The European Journal of Neuroscience · doi:10.1111/ejn.16618

  > [35.1] Yet, these cluster-based methods have an important limitation: each cluster is associated with a unique p-value, such that there is no error control at individual timepoints, and one must be cautious about interpreting when and where effects start and end. (Abstract)

[36] [Addressing Pitfalls in Phase-Amplitude Coupling Analysis with an Extended Modulation Index Toolbox](https://consensus.app/papers/addressing-pitfalls-in-phaseamplitude-coupling-analysis-jurkiewicz-hunt/4663550e59fa5c8fbc9d83adfeae7df6/)
  G. Jurkiewicz, M. Hunt, J. Żygierewicz · 2020 · Neuroinformatics · doi:10.1007/s12021-020-09487-3

  > [36.1] However, the intrinsic features of some signals can lead to the identification of spurious or waveform-dependent coupling. (Abstract)

  > [36.2] One of the novelty&#x27;s offered by eMI is a heuristic algorithm for classification of PAC as Reliable or Ambiguous. (Abstract)

[37] [Multitaper estimates of phase-amplitude coupling](https://consensus.app/papers/multitaper-estimates-of-phaseamplitude-coupling-lepage-fleming/aa51e700f7705081b40bc6f90819922d/)
  K. Lepage, Cavan N. Fleming, M. Witcher, S. Vijayan · 2021 · Journal of neural engineering · doi:10.1088/1741-2552/ac1deb

  > [37.1] The dangers and pitfalls of assessing PAC with commonly used statistical measures have been well-documented. (Abstract)

  > [37.2] Finally, asymptotic statistical assessment of the multitaper estimator is introduced to address issue (4). (Abstract)

[38] [On cross-frequency phase-phase coupling between theta and gamma oscillations in the hippocampus](https://consensus.app/papers/on-crossfrequency-phasephase-coupling-between-theta-and-scheffer-teixeira-tort/3549a988a1df583a979a41653183397e/)
  Robson Scheffer-Teixeira, A. Tort · 2016 · eLife · doi:10.7554/elife.20515

  > [38.1] We show that the quasi-linear phase shifts introduced by filtering lead to spurious coupling levels in both white noise and hippocampal LFPs, which highly depend on epoch length, and that significant coupling may be falsely detected when employing improper surrogate methods. (Abstract)

  > [38.2] Studies investigating phase-phase coupling should rely on appropriate statistical controls and be aware of confounding factors; otherwise, they could easily fall into analysis pitfalls. (Abstract)

[39] [Dissociating harmonic and non-harmonic phase-amplitude coupling in the human brain](https://consensus.app/papers/dissociating-harmonic-and-nonharmonic-phaseamplitude-giehl-noury/c00c07a3b90b54948de8ba86e755cfdb/)
  Janet Giehl, N. Noury, M. Siegel · 2020 · Neuroimage · doi:10.1101/2020.08.11.246298

  > [39.1] In conjunction, these measures allow to distinguish harmonic and non-harmonic PAC. (Abstract)

  > [39.2] Furthermore, we show how physiological artifacts and spectral leakage cause spurious PAC across wide frequency ranges. (Abstract)

[40] [The Effect of Common Signals on Power, Coherence and Granger Causality: Theoretical Review, Simulations, and Empirical Analysis of Fruit Fly LFPs Data](https://consensus.app/papers/the-effect-of-common-signals-on-power-coherence-and-granger-cohen-tsuchiya/c786f2b8a8485530892f2ed284125e83/)
  Dror Cohen, N. Tsuchiya · 2018 · Frontiers in Systems Neuroscience · doi:10.3389/fnsys.2018.00030

  > [40.1] For example a non-silent reference electrode adds a common signal across all recorded data and this adversely affects functional and effective connectivity analysis. (Abstract)

  > [40.2] We further show that subtracting spatially adjacent signals (bipolar derivations) largely removes the effects of the common signals. (Abstract)

  > [40.3] We also show that Granger causality is adversely affected by common signals and that a quantity referred to as &quot;instantaneous interaction&quot; is increased in the presence of common signals. (Abstract)

  > [40.4] The theoretical review, simulation, and empirical analysis we present can readily be adapted by others to investigate the nature of the common signals in their data. (Abstract)

[41] [Metric-space analysis of spike trains: theory, algorithms and application](https://consensus.app/papers/metricspace-analysis-of-spike-trains-theory-algorithms-victor-purpura/4b3fda2767d4594984040424fbb27c90/)
  J. Victor, K. Purpura · 1998 · Network: Computation In Neural Systems · doi:10.1088/0954-898x_8_2_003

  > [41.1] We present the mathematical basis of a new approach to the analysis of temporal coding. (Abstract)

[42] [A point process framework for relating neural spiking activity to spiking history, neural ensemble, and extrinsic covariate effects.](https://consensus.app/papers/a-point-process-framework-for-relating-neural-spiking-truccolo-eden/4b76e12f308250ac82790372e2f7f54a/)
  Wilson A. Truccolo, U. Eden, M. Fellows, J. Donoghue, E. Brown · 2005 · Journal of neurophysiology · doi:10.1152/jn.00697.2004

  > [42.1] We propose a statistical framework based on the point process likelihood function to relate a neuron&#x27;s spiking probability to three typical covariates: the neuron&#x27;s own spiking history, concurrent ensemble activity, and extrinsic covariates such as stimuli or behavior. (Abstract)

[43] [Dynamic Analyses of Information Encoding in Neural Ensembles](https://consensus.app/papers/dynamic-analyses-of-information-encoding-in-neural-barbieri-frank/6216867396df5af1bfa983d04168348e/)
  R. Barbieri, L. Frank, David P. Nguyen, M. Quirk, V. Solo, Matthew A. Wilson, E. Brown · 2004 · Neural Computation · doi:10.1162/089976604322742038

  > [43.1] Neural spike train decoding algorithms and techniques to compute Shannon mutual information are important methods for analyzing how neural systems represent biological signals. (Abstract)

[44] [Recommendations and publication guidelines for studies using frequency domain and time-frequency domain analyses of neural time series](https://consensus.app/papers/recommendations-and-publication-guidelines-for-studies-keil-bernat/97872e72b5a35c3bb09a3543dedea847/)
  A. Keil, E. Bernat, Michael X. Cohen, M. Ding, M. Fabiani, G. Gratton, E. Kappenman, E. Maris, K. Mathewson, R. T. Ward, N. Weisz · 2022 · Psychophysiology · doi:10.1111/psyp.14052

  > [44.1] It also provides publication guidelines, which aim to (1) foster replication and scientific rigor, (2) assist new researchers who wish to enter the field of brain oscillations, and (3) facilitate communication among authors, reviewers, and editors. (Abstract)

[45] [Synchrony, oscillations, and phase relationships in collective neuronal activity: A highly comparative overview of methods](https://consensus.app/papers/synchrony-oscillations-and-phase-relationships-in-baroni-fulcher/d73bce73d79e5fb9a76e97b43919cf38/)
  Fabiano Baroni, Ben D. Fulcher · 2024 · PLOS Computational Biology · doi:10.1101/2024.05.05.592564

  > [45.1] Overall, the highly comparative approach provides a detailed description of the empirical properties of multineuron spike train analysis methods, including practical guidelines for their use in experimental settings, and advances our understanding of neuronal coordination and coding. (Abstract)

[46] [Quantification of Phase-Amplitude Coupling in Neuronal Oscillations: Comparison of Phase-Locking Value, Mean Vector Length, Modulation Index, and Generalized-Linear-Modeling-Cross-Frequency-Coupling](https://consensus.app/papers/quantification-of-phaseamplitude-coupling-in-neuronal-hülsemann-naumann/f03bc151176f586e8cd622a6cec3d638/)
  M. Hülsemann, E. Naumann, B. Rasch · 2019 · Frontiers in Neuroscience · doi:10.3389/fnins.2019.00573 

  > [46.1] Coupling values of all four indices were influenced by moderators including data length, signal-to-noise-ratio, and sampling rate when approaching Nyquist frequencies. (Abstract)

  > [46.2] Here, performance of the three most widely used phase-amplitude coupling measures - phase-locking value (PLV), mean vector length (MVL), and modulation index (MI) - and of the generalized linear modeling cross-frequency coupling (GLM-CFC) method is thoroughly compared with the help of simulated data. (Abstract)

[47] [Learning identifiable and interpretable latent models of high-dimensional neural activity using pi-VAE](https://consensus.app/papers/learning-identifiable-and-interpretable-latent-models-of-zhou-wei/93ab053a560e5bbe887693da7384a6b9/)
  Ding Zhou, Xue-Xin Wei · 2020 · ArXiv · doi:10.48550/arxiv.2011.04798

  > [47.1] We demonstrate that pi-VAE not only fits the data better, but also provides unexpected novel insights into the structure of the neural codes. (Abstract)

[48] [Simultaneous, cortex-wide dynamics of up to 1 million neurons reveal unbounded scaling of dimensionality with neuron number](https://consensus.app/papers/simultaneous-cortexwide-dynamics-of-up-to-1-million-manley-lu/a0e2f4106afb5d858baf16735de9a9ad/)
  Jason Manley, Sihao Lu, Kevin Barber, Jeff Demas, Hyewon Kim, David Meyer, F. Traub, A. Vaziri · 2024 · Neuron · doi:10.1016/j.neuron.2024.02.011

  > [48.1] Although half of the neural variance is contained within sixteen dimensions correlated with behavior, our discovered scaling of dimensionality corresponds to an ever-increasing number of neuronal ensembles without immediate behavioral or sensory correlates. (Abstract)

[49] [High-dimensional neuronal activity from low-dimensional latent dynamics: a solvable model](https://consensus.app/papers/highdimensional-neuronal-activity-from-lowdimensional-schmutz-haydaroğlu/a72ae3dd49cc598fad65165b2446fa88/)
  Valentin Schmutz, Ali Haydaroğlu, Shuqi Wang, Yixiao Feng, M. Carandini, K. Harris · 2025 · bioRxiv · doi:10.1101/2025.06.03.657632

  > [49.1] Spectral theory tells us that the covariance eigenspectrum alone does not allow us to recover the dimensionality of the latents, which can be low or high, when neurons are nonlinear. (Abstract)

[50] [Probabilistic Decomposed Linear Dynamical Systems for Robust Discovery of Latent Neural Dynamics](https://consensus.app/papers/probabilistic-decomposed-linear-dynamical-systems-for-chen-mudrik/e70f9571110258ed9a16c2592acf5847/)
  Yenho Chen, Noga Mudrik, Kyle A. Johnsen, Sankaraleengam (Sankar) Alagapan, Adam S. Charles, Christopher J. Rozell · 2024 · ArXiv · doi:10.48550/arxiv.2408.16862

  > [50.1] This can lead to inconsistent results on signals with similar dynamics, limiting the model&#x27;s ability to provide scientific insight. (Abstract)

[51] [A fully automated approach to spike sorting](https://consensus.app/papers/a-fully-automated-approach-to-spike-sorting-chung-magland/1c8a21dac87254229169155d8d4bd9ea/)
  Jason E. Chung, J. Magland, A. Barnett, Vanessa M. Tolosa, A. Tooker, K. Lee, K. Shah, S. Felix, L. Frank, L. Greengard · 2017 · Neuron · doi:10.1016/j.neuron.2017.08.030

  > [51.1] We show that our approach has accuracy comparable to or exceeding that achieved using manual or semi-manual techniques with desktop central processing unit (CPU) runtimes faster than acquisition time for up to hundreds of electrodes. (Abstract)

[52] [EEG is better left alone](https://consensus.app/papers/eeg-is-better-left-alone-delorme/2d7c71ef3d425d70abff64282c762b09/)
  A. Delorme · 2022 · Scientific Reports · doi:10.1038/s41598-023-27528-0

  > [52.1] Using three publicly available collections of EEG data, we showed that, with the exceptions of high-pass filtering and bad channel interpolation, automated data corrections had no effect on or significantly decreased the percentage of significant channels. (Abstract)

  > [52.2] Automated Independent Component Analysis rejection of eyes and muscles failed to increase performance reliably. (Abstract)

  > [52.3] Automated preprocessing methods are critically needed to process the large publicly-available EEG databases, but the optimal approach remains unknown because we lack data quality metrics to compare them. (Abstract)

  > [52.4] Only one pipeline performed significantly better than high-pass filtering the data. (Abstract)

[53] [Standardizing EEG preprocessing for cross-site integration - the CLEAN pipeline](https://consensus.app/papers/standardizing-eeg-preprocessing-for-crosssite-böttcher-wendiggensen/83bf184213e65701ac6cea12dc820810/)
  Adriana Böttcher, Paul Wendiggensen, Moritz Mückschel, Sven Hoffmann, C. Buss, M. Kölch, I. Körte, Shu-Chen Li, V. Mall, Peter B. Marschik, Maximilian Pilhatsch, Veit Roessner, Saskia Rusche, Christian Beste · 2026 · NeuroImage · doi:10.1016/j.neuroimage.2026.121812

  > [53.1] Emphasis is placed on transparency through comprehensive logging and quality-control plotting, as well as on minimizing rank reduction to preserve data suitability for advanced analyses such as source localization and connectivity modeling. (Abstract)

  > [53.2] This paper introduces the CLEAN-EEG preprocessing pipeline, designed to standardize data processing and documentation across multiple sites. (Abstract)

[54] [Decomposed Linear Dynamical Systems (dLDS) for learning the latent components of neural dynamics](https://consensus.app/papers/decomposed-linear-dynamical-systems-dlds-for-learning-the-mudrik-chen/a5ee007f59e15ff5a9ea0eb48622492d/)
  Noga Mudrik, Yenho Chen, Eva Yezerets, C. Rozell, Adam S. Charles · 2022 · ArXiv · doi:10.48550/arxiv.2206.02972

  > [54.1] The decomposed nature of the dynamics is more expressive than previous switched approaches for a given number of parameters and enables modeling of overlapping and non-stationary dynamics. (Abstract)
