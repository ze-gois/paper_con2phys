a00_startup
%% b02: LFP bruto e wavelet
% Execute o probing antes deste script. data permanece na RAM.
% Apenas a janela visivel e copiada para os objetos graficos.
area = 1;
field = sprintf('lfp_%d',area);
channels = round(linspace(1,size(data.(field),1),3));
window_seconds = 10; % Limitada a 60 s para manter o custo da inspecao previsivel.
amplitude_limits = 0.0002*[-1 1]; % [] para escala automatica.
% Requer Wavelet Toolbox. Potencia CWT nao e PSD em unidade^2/Hz.
options.frequency_limits = [1 min(150,data.srate/2)];
options.color_limits = []; % Escala comum por trecho; [min max] fixa em dB.
% Wavelet Morse padrao; regioes abaixo do cone sao ocultadas.
view_lfp_wavelet(data,area,channels,window_seconds,amplitude_limits,options);
