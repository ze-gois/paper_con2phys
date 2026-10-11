a00_startup
%% c00: espectro Welch e deteccao de picos
% Execute o probing antes. Requer Signal Processing Toolbox.
% Analise de toda a sessao, sem copiar canais inteiros para os graficos.
% Picos espectrais nao identificam automaticamente frequencias fundamentais.
area = 3;
field = sprintf('lfp_%d',area);
channels = round(linspace(1,size(data.(field),1),3));
segment_seconds = 4;          % Resolucao depende desta duracao, nao so do nfft.
overlap_fraction = .50;
frequency_limits = [1 min(200,data.srate/2)];
background_width_hz = 10;     % Fundo heuristico: mediana movel da PSD em dB.
minimum_prominence_db = 1;
minimum_distance_hz = 2;
remove_segment_mean = true;   % Declarado; nao altera data.
spectral = spectral_peaks(data,area,channels,segment_seconds, ...
    overlap_fraction,frequency_limits,background_width_hz, ...
    minimum_prominence_db,minimum_distance_hz,remove_segment_mean);
for c = 1:numel(spectral)
    fprintf('\nArea %d | canal %d | %d segmentos validos\n', ...
        area,spectral(c).channel,spectral(c).valid_segments);
    disp(spectral(c).peaks);
end

%%
for ch = 1 : size(data.lfp_3,1)
WINDOW = 5000
NOVERLAP= 2500
NFFT = 1000
Fs = 500
[Pxx,F] = pwelch(data.lfp_3(ch,:),WINDOW,NOVERLAP,NFFT,Fs)
plot(F,Pxx.*F)
pause()
end
