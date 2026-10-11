a00_startup
%% b00: inspecao do LFP bruto e PSD da janela visivel
% Execute o script de probing antes deste para obter data.
% Nenhuma filtragem, normalizacao ou dizimacao e aplicada ao LFP.
% Requer Signal Processing Toolbox (pwelch).
area = 1;
channels = round(linspace(1,size(data.lfp_1,1),3));
window_seconds = 10;
amplitude_limits = 0.0002*[-1 1]; % Unidades originais; [] para escala automatica.
view_lfp_raw(data,area,channels,window_seconds,amplitude_limits);
