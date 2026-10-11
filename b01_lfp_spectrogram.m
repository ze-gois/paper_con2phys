a00_startup
%% b01: inspecao do LFP bruto e espectrograma da janela visivel
% Execute o script de probing antes deste para obter data.
% Nenhuma filtragem, normalizacao ou dizimacao e aplicada ao LFP.
% Requer Signal Processing Toolbox (spectrogram).
area = 1;
channels = round(linspace(1,size(data.(sprintf('lfp_%d',area)),1),3));
window_seconds = 10;
amplitude_limits = 0.0002*[-1 1]; % Unidades originais; [] para escala automatica.
segment_seconds = 1; % Janela Hann da STFT; diferente da janela de navegacao.
overlap_fraction = 0.90;
frequency_limits = [0 data.srate/2];
color_limits = []; % []: escala comum aos tres canais, recalculada por trecho.
% Para comparar trechos com cores fixas, defina [min max] em dB.
view_lfp_spectrogram(data,area,channels,window_seconds,amplitude_limits, ...
    segment_seconds,overlap_fraction,frequency_limits,color_limits);
