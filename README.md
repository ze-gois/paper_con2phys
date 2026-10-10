# paper_con2phys

Analises do questionario CON²PHYS em MATLAB. Execute os scripts a partir desta
pasta, depois de carregar um animal com `a01_probing`.

## Estilo de scripting

`q00:q15` seguem o estilo das referencias de aula: secoes `%%`, variaveis
inspecionaveis no workspace, parametros explicitos e funcoes locais ao final.
Os nomes dos arquivos foram mantidos para preservar os comandos existentes.
As variaveis da analise usam nomes descritivos em portugues, sem acentos.
`data` mantem os nomes originais do carregamento; os resultados continuam em
`q01` a `q15`, com campos existentes como `summary`, `units` e `provenance`.
`q00` agora guarda tambem o resultado da preparacao.

Nao ha mais `qutil`, `qctx` ou chamadas de funcoes por campos de uma estrutura.
As poucas rotinas compartilhadas sao funcoes locais nos scripts que as usam.
`q00_prepare` prepara `spkt`, `cluster_id`, `area_neuronio`, `taxa_disparo`,
`srate`, `duracao` e `procedencia`. Ele e executado por cada questao para evitar
reutilizar dados de outro animal por acidente. Nao modifica `data`.

```matlab
a01_probing

% Opcional: parametros comuns, antes de executar as questoes.
parametros = struct();
parametros.bootstrap = 1000;
parametros.surrogates = 199;
parametros.numero_neuronios = 5;

q01_firing_rate
q05_undirected_connectivity
q08_phase_locking

q01.summary
q05.summary
q08.unit
save('animal01_questionario.mat','q01','q05','q08')
```

A antiga configuracao `qcfg` foi substituida por `parametros`. Os padroes ficam
visiveis em `q00_prepare`: semente 42, 1000 reamostragens, 199 surrogates, blocos
de 30 s (minimo 8 s), waveform a 30 kHz, largura de 0,4 ms, minimo de 50 spikes
para PPC, cinco unidades nas analises que igualam o tamanho da populacao e
canal LFP 1 por area para Q8. Valores ja definidos sao preservados. Use
`clear parametros` para retornar aos padroes. Os sorteios locais nao alteram
`rng` do workspace.

## Colunas de trials e convencoes

`a01_probing` tenta identificar os cabecalhos da planilha. Se os dados ja
estiverem carregados, confirme os indices na planilha antes de informar:

```matlab
% EXEMPLO: valido apenas se estes indices corresponderem aos seus cabecalhos.
parametros.colunas_trial = struct('trial_start',2,'stim_start',3, ...
    'outcome',4,'trial_end',5,'A',6,'C',8);
q11_variable_a_information
q13_dimensionality
```

Sem mapa valido, as analises de trials param com uma mensagem. Trials com
intervalos invalidos, fora da gravacao ou sobrepostos sao excluidos, incluindo
sobreposicoes aninhadas. Os intervalos sao `[inicio,fim)`, spikes em segundos,
LFP iniciando em zero e duracao igual a numero de amostras/srate. IDs de cluster
sao mapeados explicitamente; spikes desconhecidos ou fora da gravacao sao
contabilizados nas exclusoes. Unidades silenciosas permanecem em Q1.

## O que cada script estima

| Questao | Estimativa principal | Diagnosticos e observacoes |
|---|---|---|
| Q01 | Media de spikes/s por unidade, toda a gravacao | Usa N/T, preservando tempo silencioso |
| Q02 | Integral Welch 1-100 Hz, media entre canais e blocos | Unidades originais ao quadrado, sem supor microvolts |
| Q03 | Eventos candidatos a ripple por minuto | Envelope 120-200 Hz, z robusto 2/5, duracao 25-150 ms, uniao entre canais em 20 ms |
| Q04 | Media do modulo da correlacao de contagens em 100 ms | Media assinada e correlograma de -1 a 1 s, com bins de 100 ms |
| Q05 | **Coerencia LFP media em 1-100 Hz** | Correlacao de spikes anterior preservada em `correlacao_spikes` e `correlacao_spikes_valores` |
| Q06 | Razao logaritmica de variancias residuais, VAR condicional | Bins de 20 ms, cinco atrasos; comparacoes 1->2, 3->2, 3->1 |
| Q07 | Fracao de waveforms estreitas entre unidades classificaveis | Acrescenta CV do ISI e fracao de ISIs menores que 2 ms |
| Q08 | PPC em 4-10 Hz | Forca vetorial, fase preferida, histograma, ocupacao de fase e surrogates |
| Q09 | Razao de contagem larga/estreita | Proxy morfologico; nao identifica E/I fisiologica |
| Q10 | Tau de decaimento da autocorrelacao no baseline | Baseline de 1 s antes do trial, fora de outros trials; ajuste com offset |
| Q11 | MI da matriz de confusao de A, em teste, trial inteiro | Decodificacao por segmento e informacao por taxa em bits/s e bits/spike |
| Q12 | Acuracia balanceada de C por segmento | Mesmos trials/particoes; normalizacao apenas no treino |
| Q13 | Participation ratio da covariancia, estimulo->desfecho | Espectro de correlacao, autovetores ordenados, limiares MP e surrogate |
| Q14 | Media da modularidade por bloco | Rede de correlacoes positivas, mesmo numero de unidades, fusao gulosa |
| Q15 | Entropia de permutacao do LFP, estimulo->fim | Ordem 3, atraso 10 ms, media de canais por trial |

## Escolhas introduzidas pela revisao das referencias

**Q04:** o correlograma e a correlacao assinada de contagens defasadas, calculada
para cada par ordenado. A media e simetrica; nao e um detector de conexoes
sinapticas nem estima direcao. A estatistica principal de 100 ms foi mantida.

**Q05:** tres canais igualmente espacados por area, escolhidos sem olhar os
resultados; media dos nove pares. Welch usa janelas Hann de 4 s e 50% de
sobreposicao, com multiplas janelas em cada bloco. O resultado nao tem a
degeneracao de coerencia igual a um por usar uma unica janela. A referencia
comum, conducao de volume e atividade evocada continuam sendo confundidores.
A media espectral considera os bins da FFT dentro de 1-100 Hz. Os espectros
por bloco e o numero de pares validos ficam em `q05.coerencia`.

**Q08:** mantem a banda solicitada de 4-10 Hz. PPC e comprimento vetorial R
satisfazem `PPC=(N*R^2-1)/(N-1)`. Fases sao interpoladas no sinal analitico;
as bordas de 2 s sao excluidas. Deslocamentos circulares independentes por
unidade ocorrem no intervalo util, com pelo menos 0,5 s de afastamento circular
em relacao ao deslocamento zero. Preservam a estrutura temporal salvo na emenda,
mas pressupostos de estacionariedade devem ser inspecionados. Os p-valores
unitarios sao exploratorios e nao corrigidos para multiplas comparacoes.
A ocupacao temporal em cada bin de fase fica disponivel para inspecao.

**Q11:** a estimativa principal continua sendo informacao decodificada do trial
inteiro. `q11.temporal` apresenta os tres segmentos sem escolher o vencedor a
posteriori. O estimador de taxa e `sum(p(A)*lambda(A)*log2(lambda(A)/lambda_media))`:
`p(A)` e a fracao do tempo observado naquela classe, nao a fracao de trials.
Dividir pela taxa media fornece bits/spike. Unidades sem spikes retornam NaN.
O estimador tem vies de amostra finita, nao e MI populacional; seus surrogates
deslocam os rotulos de trials e os p-valores nao sao corrigidos. Nao possui
IC separado nesta revisao. As unidades selecionadas sao as mesmas usadas na
analise principal, e duracoes dos segmentos afetam a precisao das taxas.

**Q13:** preserva a analise principal em covariancia bruta, com bins de 100 ms
inteiros dentro de cada trial. Acrescenta um subconjunto fixo de igual tamanho
para diagnosticar o espectro de correlacao. Remove a ambiguidade de ordenacao
explicitamente com `sort(diag(D),'descend')`. A borda superior teorica e
`(1+sqrt(N_unidades/N_bins))^2`; nao e um teste calibrado para bins dependentes.
O limiar empirico e o percentil 95 do maior autovalor de surrogates com shifts
independentes por unidade, dentro de cada trial. Essa escolha preserva as taxas
por trial. Componentes acima do limiar nao identificam automaticamente membros
de assemblies nem equivalem a comunidades de Q14.

## Limites para as respostas cientificas

- ICs sao descritivos dentro de uma gravacao: bootstrap de unidades, blocos ou
  trials conforme o estimador. Nao sao ICs entre os 18 animais. Dependencia
  residual entre unidades, blocos ou trials nao desaparece com reamostragem.
- Para a resposta final, compare diferencas **pareadas por animal** com um
  procedimento de comparacoes multiplas declarado. Esta revisao nao executa
  agregacao entre animais nem escolhe respostas categoricas automaticamente.
- Q3 exige inspecao de artefatos, sharp waves e sensibilidade ao numero de canais.
  Q6 exige verificacao de residuos, estacionariedade, ordem do VAR e vies positivo
  da estimativa em treino. Q7 nao valida identidade inibitoria.
- Q9 preserva infinitos nas reamostragens com denominador zero; nao estima um
  valor pontual quando nao ha unidades estreitas. Nao infere correntes sinapticas.
- Q10 exige pelo menos 20 baselines e seis atrasos validos; aceita tau 25-1000 ms
  e R2>=0,5. Resultados dependem dos criterios de selecao dos ajustes.
- Q11/Q12 usam ridge fixo e cinco particoes contiguas. ICs condicionam nos modelos
  ja ajustados; os escores softmax sao chamados `softmax_scores`, nao probabilidades
  calibradas. Comparar duracoes equivalentes e preservar a estrutura temporal
  sao verificacoes necessarias antes de inferencia conclusiva.
- Q13 compara populacoes do mesmo tamanho; covariancia bruta pesa unidades mais
  variaveis. Q14 descarta arestas negativas, usa resolucao 1 e algoritmo guloso,
  sem garantia de otimo global. Sua media por blocos difere de um grafo estatico.
- Q15 exclui empates e exige 100 padroes; nao adiciona filtro espectral. Ruido
  pode elevar a entropia. Ordem, atraso e duracao merecem analise de sensibilidade.
- Resultados antigos `qNN` no workspace nao sao apagados quando outro animal e
  carregado. Cada script refeito atualiza somente seu proprio resultado.

## Validacao e referencias

Requer MATLAB R2019a ou posterior e Signal Processing Toolbox. As funcoes locais
ficam depois de todo o corpo dos scripts, inclusive em Q11/Q13. Execute em uma
sessao separada, pois o teste cria um `data` sintetico:

```matlab
run('tests/smoke_questionnaire.m')
```

O teste verifica os 15 scripts, taxas e potencias conhecidas, razao de classes,
limites da coerencia, identidade PPC/R e ordenacao de autovalores. O ambiente de
autoria nao tem MATLAB nem gravacoes: a execucao MATLAB continua pendente.
A verificacao estatica cobre sintaxe, funcoes locais ao final e consistencia das
copias das rotinas comuns; nao substitui validacao numerica.

As referencias de aula e sua relacao com os scripts estao em
[reference/README.md](reference/README.md). Elas inspiram a revisao, sem copiar
rotinas de aquisicao ou incorporar `eegfilt` ao projeto.

- [Questionario](questionnaire/questionnaire.pdf).
- [Estrutura oficial](https://mchini.github.io/con2phys/data_structure.html).
- [Versao do dataset](https://mchini.github.io/con2phys/how_to_participate.html):
  verificar v1.1, que corrige LFP do animal 12 em 15 de julho de 2026.
