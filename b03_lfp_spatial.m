a00_startup
%% b03: LFP bruto e distribuicao espacial
% Execute o probing antes deste script. data permanece na RAM.
% Apenas a janela visivel e copiada para os objetos graficos.
area = 1;
field = sprintf('lfp_%d',area);
channels = round(linspace(1,size(data.(field),1),3));
window_seconds = 10; % Limitada a 60 s para manter o custo da inspecao previsivel.
amplitude_limits = 0.0002*[-1 1]; % [] para escala automatica.
% Mapas mostram todos os canais de cada area; sem toolbox adicional.
options.color_limits = 0.0002*[-1 1]; % Unidades originais, mesma escala nas areas.
% Canal e indice, nao profundidade fisica. Nao e uma estimativa de CSD.
view_lfp_spatial(data,area,channels,window_seconds,amplitude_limits,options);
