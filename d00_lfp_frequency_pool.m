a00_startup
%% d00: pool de picos por eletrodo e componentes filtrados
% Execute o probing antes. Requer Signal Processing Toolbox.
% Analisa todas as areas e eletrodos, nao apenas os tres canais do c00.
% Sem graficos. Fundo e limiares sao heuristicos; harmonicos nao sao removidos.
options.segment_seconds = 4;
options.overlap_fraction = .5;
options.frequency_limits = [1 min(200,data.srate/2)];
options.background_width_hz = 10;
options.minimum_prominence_db = 3;
options.minimum_distance_hz = 2;
options.pool_span_hz = 2; % Amplitude MAXIMA de frequencias dentro de um grupo.
options.minimum_electrodes = 1; % Conta pares unicos (area,canal).
options.band_half_width_hz = 2; % Banda exploratoria, nao largura do pico.
options.filter_order = 4; % Butterworth: ordem bandpass 8, antes de filtfilt.
% A saida e salva fora do repositorio, em uma pasta exclusiva por execucao.
output_root = fullfile('..','data','derived','d00');
[peaks_by_electrode,frequency_pool,filtered_manifest,output_directory] = ...
    pool_and_filter(data,options,output_root);
disp(frequency_pool);
fprintf('Componentes salvos em: %s\n',output_directory);
