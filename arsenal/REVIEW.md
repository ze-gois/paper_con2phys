# Revisao manual: correcoes e execucao pendente

## Correcoes desta rodada

- `linear_discriminability`: `nb=size(b,1)`; regressao com grupos de tamanhos diferentes e covariancia calculada independentemente.
- `spike_bin_counts`: tolerancia de 1e-9 na contagem de bins completos; borda final limitada por `stop_s` para preservar exclusao do endpoint.
- `spike_waveform_average`: `reshape` preserva canais x amostras quando ha um canal; regressao verifica tambem o consumo por `spike_waveform_snr` (que nao usa squeeze).
- `peri_event_histogram`, `spike_bin_counts` e `spike_counts_edges`: trens vazios aceitos, timestamps nao finitos descartados e bins semiabertos. Eventos de alinhamento nao finitos continuam invalidos.

## Tentativa de execucao em 2026-10-11

As cinco chamadas a `matlab -batch` foram impedidas antes de iniciar o MATLAB:
executavel `matlab` ausente. Nenhum destes testes passou ou falhou numericamente.

| Teste | Estado |
|---|---|
| smoke_arsenal | Nao executado: runtime ausente |
| smoke_population | Nao executado: runtime ausente |
| smoke_ephys_methods | Nao executado: runtime ausente |
| smoke_consensus_methods | Nao executado: runtime ausente |
| smoke_bosc_circ_glm | Nao executado: runtime ausente |

## Pontos da revisao ainda abertos

- Oferecer folds contiguos no crossvalidated_ridge_decoder; manter avaliacao temporal explicita.
- Uniformizar seed/stream em jitter, randomizacao de fase, EEMD e CP/ALS, sem alterar o RNG global.
- Permitir bandas excluidas do ajuste de fundo do BOSC e avaliar o caso da senoide de 8 Hz.
- Conferir no artigo Heller & David a ordem PCA/projecao na reducao direcionada.
- Usar a forma dual de Tikhonov quando houver mais fontes que eletrodos.
- Vetorizar permutation_entropy, preservando a convencao para empates.
- Acrescentar normalizacao, seed, parada e testes de recuperacao mais fortes ao CP/ALS.
- Verificar os DOI sugeridos para Lachaux (1999) e Vinck (2011) antes de modificar METHODS.tsv.

Estes itens nao foram resolvidos pela correcao imediata dos bugs acima.
