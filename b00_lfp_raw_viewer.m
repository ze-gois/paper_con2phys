%% b00: inspecao do LFP bruto e PSD da janela visivel
% Execute o script de probing antes deste para obter data.
% Nenhuma filtragem, normalizacao ou dizimacao e aplicada ao LFP.
% Requer Signal Processing Toolbox (pwelch).
area = 1;
channels = round(linspace(1,size(data.lfp_1,1),3));
window_seconds = 10;
amplitude_limits = 0.0002*[-1 1]; % Unidades originais; [] para escala automatica.
lfp_viewer(data,area,channels,window_seconds,amplitude_limits);

%% Funcoes locais
function lfp_viewer(data,area,channels,window_seconds,amplitude_limits)
    validateattributes(data.srate,{'numeric'},{'scalar','finite','positive'});
    validateattributes(area,{'numeric'},{'scalar','integer','>=',1,'<=',3});
    field = sprintf('lfp_%d',area);
    n = size(data.(field),2);
    validateattributes(channels,{'numeric'}, ...
        {'vector','numel',3,'integer','>=',1,'<=',size(data.(field),1)});
    validateattributes(window_seconds,{'numeric'},{'scalar','finite','positive'});
    assert(n >= 2,'O LFP deve conter pelo menos duas amostras.');
    fs = data.srate;
    count = min(n,max(2,round(window_seconds*fs)));
    last_start = n-count+1;
    first = 1;
    fig = figure('Name','b00: LFP bruto e Welch','NumberTitle','off');
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
        spectrum(c) = plot(spectrum_ax(c),NaN,NaN);
        xlabel(spectrum_ax(c),'Frequencia (Hz)');
        ylabel(spectrum_ax(c),'PSD (unidade^2/Hz)');
        set(spectrum_ax(c),'YScale','log');
        xlim(spectrum_ax(c),[0 fs/2]);
        grid(spectrum_ax(c),'on');
        title(spectrum_ax(c),sprintf('Welch | canal %d',channels(c)));
    end
    linkaxes(ax,'x'); % Apenas os tracos temporais.
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
        % Welch: segmentos Hann de ate 2 s; sobreposicao de 50%.
        length_segment = min(count,max(2,round(2*fs)));
        taper = hann(length_segment,'periodic');
        overlap = floor(length_segment/2);
        nfft = max(256,2^nextpow2(length_segment));
        for j = 1:3
            y = data.(field)(channels(j),idx);
            set(trace(j),'XData',t,'YData',y);
            xlim(ax(j),[t(1) t(end)]);
            title(ax(j),sprintf('Area %d | canal %d | %.3f - %.3f s', ...
                area,channels(j),t(1),t(end)));
            [power,freq] = pwelch(y(:),taper,overlap,nfft,fs);
            set(spectrum(j),'XData',freq,'YData',power);
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
