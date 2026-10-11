a00_startup
%% b04: LFP bruto e qualidade
% Execute o probing antes deste script. data permanece na RAM.
% Apenas a janela visivel e copiada para os objetos graficos.
area = 1;
field = sprintf('lfp_%d',area);
channels = round(linspace(1,size(data.(field),1),3));
window_seconds = 10; % Limitada a 60 s para manter o custo da inspecao previsivel.
amplitude_limits = 0.0002*[-1 1]; % [] para escala automatica.
% RMS inclui o offset DC; pico a pico = max - min. Sem toolbox adicional.
options.bin_seconds = .25; % Blocos nao sobrepostos; ultimo pode ser menor.
% Nenhuma exclusao automatica; NaN/Inf sao marcados, sem substituir amostras.
view_lfp_quality(data,area,channels,window_seconds,amplitude_limits,options);
