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
minimum_prominence_db = 3;
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

%% Funcoes locais
function result = spectral_peaks(data,area,channels,segment_seconds, ...
        overlap_fraction,frequency_limits,background_width_hz, ...
        minimum_prominence_db,minimum_distance_hz,remove_segment_mean)
    validateattributes(data.srate,{'numeric'},{'scalar','finite','positive'});
    validateattributes(area,{'numeric'},{'scalar','integer','>=',1,'<=',3});
    field = sprintf('lfp_%d',area);
    validateattributes(data.(field),{'numeric'},{'2d','real','nonempty'});
    validateattributes(channels,{'numeric'}, ...
        {'vector','numel',3,'integer','>=',1,'<=',size(data.(field),1)});
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
    fig = figure('Name','c00: Welch e picos espectrais','NumberTitle','off');
    fig.WindowStyle = 'docked';
    result = struct([]);
    for c = 1:3
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
        ax = subplot(3,2,2*c-1,'Parent',fig);
        plot(ax,f,db(mask),'b',f,background(mask),'k--');
        hold(ax,'on');
        plot(ax,location,interp1(freq,db,location),'rv','MarkerFaceColor','r');
        xlabel(ax,'Frequencia (Hz)'); ylabel(ax,'PSD (dB re 1 unidade^2/Hz)');
        title(ax,sprintf('Area %d | canal %d | Welch',area,channels(c)));
        legend(ax,{'PSD','Fundo heuristico','Picos'},'Location','best');
        grid(ax,'on'); xlim(ax,frequency_limits);
        ax = subplot(3,2,2*c,'Parent',fig);
        plot(ax,f,e,'b'); hold(ax,'on');
        plot(ax,location,height,'rv','MarkerFaceColor','r');
        plot(ax,frequency_limits,minimum_prominence_db*[1 1],'k--');
        for p = 1:numel(location)
            text(ax,location(p),height(p),sprintf(' %.2f Hz',location(p)));
        end
        xlabel(ax,'Frequencia (Hz)'); ylabel(ax,'Excesso sobre fundo (dB)');
        title(ax,'Picos candidatos; conferir harmonicos e artefatos');
        grid(ax,'on'); xlim(ax,frequency_limits);
    end
end
