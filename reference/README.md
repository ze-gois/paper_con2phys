# Referencias de scripting revisadas em 10/10/2026

Os dois conjuntos de scripts de aula enviados pelo usuario foram lidos como
referencias de estilo e metodo. Os originais nao foram modificados ou copiados
para o repositorio. Mantemos os nomes abaixo para rastrear as escolhas.

| Referencias | Aplicacao |
|---|---|
| Aula 01_11_2011.m; Aula 03_11_2011.m | N/T, ISI, raster e correlacoes: Q1, Q4, Q7 |
| 04-11-2011.m; 08-11-2011.m; 08-11-2011b.m | Fourier e espectros: Q2 |
| Aula_10-11.m | Coerencia com medias espectrais entre janelas: Q5 |
| 22-11-2011.m; 24-11-2011.m; 25-11-2011b.m | STA e surrogates: motivacao dos controles de Q8; STA nao implementada nesta revisao |
| 25-11-2011.m; eegfilt.m | Filtragem e Hilbert: Q3/Q8; nao confundir amplitude com PSD |
| 01-12-2011.m; 01-12-2011(1).m; 02-12-2011.m | Fase, comprimento vetorial e estatistica circular: Q8 |
| Aula_27_10_2011.m | Trials e PSTH: motivacao da separacao temporal de Q11/Q12 |
| 08-12-2011.m; 13-12-2011.m | Exposicao, taxa por condicao e informacao em bits/s: Q11 |
| SpikeClustering.m; classificacao.m; classificacao(1).m | Diagnosticos de waveform; distinguir agrupamento de identidade celular: Q7 |
| assemblies.m | Matriz de correlacao, autovalores e Marchenko-Pastur: Q13 |
| Aula3.m; Aula3t.m; Aula4.m; Aula4t.m | ICs, pareamento e comparacoes multiplas: orientacoes para futura agregacao |
| aula5a.m; aula5b.m; aula5c.m | Amostragem, aliasing e analise espectral |
| Aula1.m; Aula1t.m; Aula2.m; Aula2t.m; somardoisnumeros.m | Estilo de scripting e estatistica descritiva |
| daqtimerplot.m; daqtimerplot(1).m | Exemplo de aquisicao; nao utilizado na analise offline |

Cuidados incorporados: funcoes locais ao final; nenhuma dependencia de variaveis
`sig*` ou `eval`; nenhum `clear all` nas analises; contagem de spikes por exposicao;
coerencia calculada com mais de uma janela; eigenpares explicitamente ordenados;
spikes mapeados por ID; rejeicao de trials sobrepostos incluindo os aninhados.

Nao foram transportados: coerencia de uma unica janela, media do inverso dos
ISIs como taxa global, FFT truncada por usar srate como tamanho, selecao implicita
dos ultimos eigenvetores, ou classificacao de grupos como tipos celulares validados.

Referencias metodologicas adicionais:

- Vinck et al. (2010), PPC: https://pubmed.ncbi.nlm.nih.gov/20114076/
- Lopes-dos-Santos et al. (2011), assemblies e PCA:
  https://doi.org/10.1371/journal.pone.0020996
- MATLAB eig: https://www.mathworks.com/help/matlab/ref/eig.html
- MATLAB mscohere: https://www.mathworks.com/help/signal/ref/mscohere.html
