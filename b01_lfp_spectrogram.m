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
lfp_viewer(data,area,channels,window_seconds,amplitude_limits, ...
    segment_seconds,overlap_fraction,frequency_limits,color_limits);

%% Funcoes locais
function lfp_viewer(data,area,channels,window_seconds,amplitude_limits, ...
        segment_seconds,overlap_fraction,frequency_limits,color_limits)
    validateattributes(data.srate,{'numeric'},{'scalar','finite','positive'});
    validateattributes(area,{'numeric'},{'scalar','integer','>=',1,'<=',3});
    field = sprintf('lfp_%d',area);
    n = size(data.(field),2);
    validateattributes(channels,{'numeric'}, ...
        {'vector','numel',3,'integer','>=',1,'<=',size(data.(field),1)});
    validateattributes(window_seconds,{'numeric'},{'scalar','finite','positive'});
    validateattributes(segment_seconds,{'numeric'},{'scalar','finite','positive'});
    validateattributes(overlap_fraction,{'numeric'},{'scalar','>=',0,'<',1});
    validateattributes(frequency_limits,{'numeric'}, ...
        {'vector','numel',2,'finite','>=',0,'<=',data.srate/2});
    assert(frequency_limits(2)>frequency_limits(1),'Limites de frequencia invalidos.');
    if ~isempty(color_limits)
        validateattributes(color_limits,{'numeric'},{'vector','numel',2,'finite'});
        assert(color_limits(2)>color_limits(1),'Limites de cor invalidos.');
    end
    assert(n >= 2,'O LFP deve conter pelo menos duas amostras.');
    fs = data.srate;
    count = min(n,max(2,round(window_seconds*fs)));
    last_start = n-count+1;
    first = 1;
    fig = figure('Name','b01: LFP bruto e espectrograma','NumberTitle','off');
    fig.WindowStyle = 'docked';
    ax = gobjects(1,3);
    spectrum_ax = gobjects(1,3);
    trace = gobjects(1,3);
    spectrum = gobjects(1,3);
    for c = 1:3
        ax(c) = subplot(4,1,c,'Parent',fig);
        trace(c) = plot(ax(c),NaN,NaN);
        ylabel(ax(c),'Amplitude');
        grid(ax(c),'on');
        if ~isempty(amplitude_limits), ylim(ax(c),amplitude_limits); end
    end
    set(ax(1:2),'XTickLabel',{});
    xlabel(ax(3),'Tempo (s)');
    for c = 1:3
        spectrum_ax(c) = subplot(4,3,9+c,'Parent',fig);
        spectrum(c) = imagesc(spectrum_ax(c),[0 1],[0 fs/2],NaN(2));
        set(spectrum_ax(c),'YDir','normal');
        xlabel(spectrum_ax(c),'Tempo (s)');
        ylabel(spectrum_ax(c),'Frequencia (Hz)');
        ylim(spectrum_ax(c),frequency_limits);
        grid(spectrum_ax(c),'on');
        title(spectrum_ax(c),sprintf('espectrograma | canal %d',channels(c)));
    end
    linkaxes([ax spectrum_ax],'x');
    colormap(fig,parula);
    % Cor: 10*log10(PSD / 1 unidade^2/Hz), sem baseline.
    % Reserva uma faixa inferior para a navegacao.
    for c = 1:3
        p = get(spectrum_ax(c),'Position');
        p(2) = p(2)+.04; p(4) = max(.05,p(4)-.04);
        set(spectrum_ax(c),'Position',p);
    end
    slider = uicontrol(fig,'Style','slider','Units','normalized', ...
        'Position',[.13 .015 .65 .025],'Min',0,'Max',1, ...
        'Value',0,'Callback',@slide);
    uicontrol(fig,'Style','pushbutton','String','<', ...
        'Units','normalized','Position',[.80 .015 .06 .025], ...
        'Callback',@(s,e) move(-1));
    uicontrol(fig,'Style','pushbutton','String','>', ...
        'Units','normalized','Position',[.88 .015 .06 .025], ...
        'Callback',@(s,e) move(1));
    if last_start == 1
        set(slider,'Enable','off');
    else
        step = min(1,max(1,round(count/2))/(last_start-1));
        set(slider,'SliderStep',[step min(1,2*step)]);
    end
    zoom(fig,'off'); pan(fig,'off');
    refresh();

    function refresh()
        first = min(last_start,max(1,round(first)));
        idx = first:first+count-1;
        t = (idx-1)/fs; % Somente o vetor temporal da janela.
        % STFT calculada somente sobre o trecho visivel.
        length_segment = min(count,max(2,round(segment_seconds*fs)));
        taper = hann(length_segment,'periodic');
        overlap = min(length_segment-1,floor(overlap_fraction*length_segment));
        low = Inf; high = -Inf;
        nfft = max(256,2^nextpow2(length_segment));
        for j = 1:3
            y = data.(field)(channels(j),idx);
            set(trace(j),'XData',t,'YData',y);
            xlim(ax(j),[t(1) t(end)]);
            title(ax(j),sprintf('Area %d | canal %d | %.3f - %.3f s', ...
                area,channels(j),t(1),t(end)));
            [~,freq,relative_time,power] = spectrogram(y(:),taper,overlap,nfft,fs);
            absolute_time = t(1)+relative_time;
            db = 10*log10(max(power,realmin('double')));
            if numel(absolute_time)==1
                % A single time bin spans the segment represented by it.
                image_time = [t(1) t(end)];
            else
                image_time = [absolute_time(1) absolute_time(end)];
            end
            set(spectrum(j),'XData',image_time, ...
                'YData',[freq(1) freq(end)],'CData',db);
            selected = db(freq>=frequency_limits(1) & freq<=frequency_limits(2),:);
            finite_values = selected(isfinite(selected));
            if ~isempty(finite_values)
                low = min(low,min(finite_values));
                high = max(high,max(finite_values));
            end
            xlim(spectrum_ax(j),[t(1) t(end)]);
        end
        if isempty(color_limits)
            if ~isfinite(low), low = -1; high = 1; end
            if high<=low, high = low+1; end
            limits = [low high];
        else
            limits = color_limits;
        end
        set(spectrum_ax,'CLim',limits);
        for j = 1:3
            title(spectrum_ax(j),sprintf('Canal %d | PSD dB [%.1f, %.1f]', ...
                channels(j),limits(1),limits(2)));
        end
        set(slider,'Value',(first-1)/max(1,last_start-1));
        drawnow;
    end

    function slide(src,~)
        first = 1+round(get(src,'Value')*(last_start-1));
        refresh();
    end

    function move(direction)
        first = first+direction*max(1,round(count/2));
        refresh();
    end
end
