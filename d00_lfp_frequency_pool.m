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

%% Funcoes locais
function [electrodes,pool,manifest,directory] = pool_and_filter(data,o,root)
    validateattributes(o.pool_span_hz,{'numeric'},{'scalar','finite','positive'});
    validateattributes(o.minimum_electrodes,{'numeric'},{'scalar','integer','positive'});
    validateattributes(o.band_half_width_hz,{'numeric'},{'scalar','finite','positive'});
    validateattributes(o.filter_order,{'numeric'},{'scalar','integer','positive'});
    fs = data.srate;
    electrodes = struct([]);
    records = zeros(0,4); % frequencia, area, canal, proeminencia
    for area = 1:3
        field = sprintf('lfp_%d',area);
        channels = 1:size(data.(field),1);
        fprintf('Detectando picos: area %d, %d eletrodos\n',area,numel(channels));
        part = electrode_peaks(data,area,channels,o.segment_seconds, ...
            o.overlap_fraction,o.frequency_limits,o.background_width_hz, ...
            o.minimum_prominence_db,o.minimum_distance_hz,true);
        electrodes = [electrodes part]; %#ok<AGROW>
        for c = 1:numel(part)
            p = part(c).peaks;
            records = [records; p.frequency_hz, ...
                area*ones(height(p),1),channels(c)*ones(height(p),1), ...
                p.prominence_db]; %#ok<AGROW>
        end
    end
    records = sortrows(records,1);
    rows = zeros(0,7);
    members = cell(0,1);
    first = 1;
    while first<=size(records,1)
        % Nao usar encadeamento por vizinhos: evita grupos de largura ilimitada.
        last = first;
        while last<size(records,1) && ...
                records(last+1,1)-records(first,1)<=o.pool_span_hz
            last = last+1;
        end
        group = records(first:last,:);
        pairs = unique(group(:,2:3),'rows');
        if size(pairs,1)>=o.minimum_electrodes
            center = median(group(:,1)); % Cada pico contribui igualmente.
            % Bandas limitadas explicitamente ao intervalo analisado.
            lo = max(o.frequency_limits(1),center-o.band_half_width_hz);
            hi = min(o.frequency_limits(2),center+o.band_half_width_hz);
            assert(lo>0 && hi<fs/2, ...
                'Banda %.3f-%.3f Hz fora de (0,Nyquist); ajuste parametros.',lo,hi);
            rows(end+1,:) = [center lo hi size(pairs,1) ...
                size(group,1) min(group(:,1)) max(group(:,1))]; %#ok<AGROW>
            members{end+1,1} = group; %#ok<AGROW>
        end
        first = last+1;
    end
    pool = array2table(rows,'VariableNames',{'center_hz','low_hz','high_hz', ...
        'electrode_count','peak_count','minimum_peak_hz','maximum_peak_hz'});
    pool.members = members; % Colunas: frequencia, area, canal, proeminencia.
    % Cria saida exclusiva: nenhum resultado anterior e sobrescrito.
    if ~exist(root,'dir'), mkdir(root); end
    directory = tempname(root);
    mkdir(directory);
    manifest = struct([]);
    save(fullfile(directory,'analysis.mat'),'electrodes','pool','o','fs','-v7.3');
    index = 0;
    for b = 1:height(pool)
        [z,p,k] = butter(o.filter_order,[pool.low_hz(b) pool.high_hz(b)]/(fs/2));
        [sos,gain] = zp2sos(z,p,k);
        for area = 1:3
            field = sprintf('lfp_%d',area);
            for channel = 1:size(data.(field),1)
                % Apenas um canal e um componente completo por vez na RAM.
                signal = double(data.(field)(channel,:));
                assert(all(isfinite(signal)), ...
                    'Area %d canal %d contem NaN/Inf; filtragem interrompida.',area,channel);
                component = filtfilt(sos,gain,signal);
                metadata = struct('area',area,'channel',channel,'band_id',b, ...
                    'srate',fs,'time_origin_seconds',0, ...
                    'center_hz',pool.center_hz(b), ...
                    'band_hz',[pool.low_hz(b) pool.high_hz(b)], ...
                    'sos',sos,'gain',gain,'zero_phase',true, ...
                    'edge_policy','No samples discarded; inspect boundary transients');
                path = fullfile(directory,sprintf('band%03d_area%d_ch%03d.mat', ...
                    b,area,channel));
                save(path,'component','metadata','-v7.3');
                index = index+1;
                manifest(index).path = path;
                manifest(index).area = area;
                manifest(index).channel = channel;
                manifest(index).band_id = b;
                clear signal component
            end
        end
        fprintf('Filtrada banda %d/%d: %.3f-%.3f Hz\n', ...
            b,height(pool),pool.low_hz(b),pool.high_hz(b));
    end
    save(fullfile(directory,'manifest.mat'),'manifest','-v7.3');
    % manifest so existe ao concluir: pasta sem manifest indica execucao parcial.
    % Bandas podem se sobrepor. Componentes nao formam decomposicao aditiva.
end

function result = electrode_peaks(data,area,channels,segment_seconds, ...
        overlap_fraction,frequency_limits,background_width_hz, ...
        minimum_prominence_db,minimum_distance_hz,remove_segment_mean)
    validateattributes(data.srate,{'numeric'},{'scalar','finite','positive'});
    validateattributes(area,{'numeric'},{'scalar','integer','>=',1,'<=',3});
    field = sprintf('lfp_%d',area);
    validateattributes(data.(field),{'numeric'},{'2d','real','nonempty'});
    validateattributes(channels,{'numeric'}, ...
        {'vector','integer','>=',1,'<=',size(data.(field),1)});
    validateattributes(segment_seconds,{'numeric'},{'scalar','finite','positive'});
    validateattributes(overlap_fraction,{'numeric'},{'scalar','>=',0,'<',1});
    validateattributes(background_width_hz,{'numeric'},{'scalar','finite','positive'});
    validateattributes(minimum_prominence_db,{'numeric'},{'scalar','finite','positive'});
    validateattributes(minimum_distance_hz,{'numeric'},{'scalar','finite','positive'});
    fs = data.srate;
    validateattributes(frequency_limits,{'numeric'}, ...
        {'vector','numel',2,'finite','positive','<=',fs/2});
    assert(diff(frequency_limits)>0,'Limites de frequencia invalidos.');
    n = size(data.(field),2);
    length_segment = max(4,round(segment_seconds*fs));
    assert(n>=length_segment,'Registro menor que o segmento Welch solicitado.');
    overlap = floor(overlap_fraction*length_segment);
    hop = length_segment-overlap;
    starts = 1:hop:n-length_segment+1;
    taper = hann(length_segment,'periodic');
    nfft = 2^nextpow2(length_segment);
    result = struct([]);
    for c = 1:numel(channels)
        total = zeros(nfft/2+1,1);
        valid = 0;
        for first = starts
            y = double(data.(field)(channels(c),first:first+length_segment-1));
            if any(~isfinite(y)), continue; end
            if remove_segment_mean, y = y-mean(y); end
            % Um periodograma modificado por segmento; media em escala linear.
            [power,freq] = pwelch(y(:),taper,0,nfft,fs);
            total = total+power;
            valid = valid+1;
        end
        assert(valid>0,'Canal %d sem segmentos validos.',channels(c));
        psd = total/valid;
        db = 10*log10(max(psd,realmin('double')));
        df = freq(2)-freq(1);
        width = max(3,2*floor(background_width_hz/(2*df))+1);
        background = movmedian(db,width);
        excess = db-background;
        mask = freq>=frequency_limits(1) & freq<=frequency_limits(2);
        f = freq(mask); e = excess(mask);
        assert(numel(f)>=3,'Intervalo de frequencias muito estreito.');
        [height,location,peak_width,prominence] = findpeaks(e,f, ...
            'MinPeakProminence',minimum_prominence_db, ...
            'MinPeakDistance',minimum_distance_hz);
        % Exige excesso positivo alem de proeminencia local.
        keep = height>=minimum_prominence_db;
        height = height(keep); location = location(keep);
        peak_width = peak_width(keep); prominence = prominence(keep);
        peak_psd = interp1(freq,psd,location);
        peaks = table(location(:),peak_psd(:),height(:),prominence(:), ...
            peak_width(:),'VariableNames', ...
            {'frequency_hz','psd_original_units2_per_hz','excess_db', ...
             'prominence_db','residual_width_hz'});
        result(c).area = area;
        result(c).channel = channels(c);
        result(c).frequency_hz = freq;
        result(c).psd = psd;
        result(c).background_db = background;
        result(c).excess_db = excess;
        result(c).peaks = peaks;
        result(c).valid_segments = valid;
        result(c).excluded_segments = numel(starts)-valid;
        result(c).unused_tail_samples = n-(starts(end)+length_segment-1);
        result(c).parameters = struct('segment_samples',length_segment, ...
            'overlap_samples',overlap,'nfft',nfft, ...
            'background_width_hz',background_width_hz, ...
            'frequency_limits',frequency_limits, ...
            'minimum_prominence_db',minimum_prominence_db, ...
            'minimum_distance_hz',minimum_distance_hz, ...
            'remove_segment_mean',remove_segment_mean);
    end
end
