%% b04: LFP bruto e qualidade
% Execute o probing antes deste script. data permanece na RAM.
% Apenas a janela visivel e copiada para os objetos graficos.
area = 1;
field = sprintf('lfp_%d',area);
channels = round(linspace(1,size(data.(field),1),3));
window_seconds = 10; % Limitada a 60 s para manter o custo da inspecao previsivel.
amplitude_limits = 0.0002*[-1 1]; % [] para escala automatica.
% RMS inclui o offset DC; pico a pico = max - min. Sem toolbox adicional.
options.bin_seconds = .25; % Blocos nao sobrepostos; ultimo pode ser menor.
% Nenhuma exclusao automatica; NaN/Inf sao marcados, sem substituir amostras.
inspect(data,area,channels,window_seconds,amplitude_limits,options);

%% Funcoes locais
function inspect(data,area,channels,window_seconds,amplitude_limits,options)
    validateattributes(data.srate,{'numeric'},{'scalar','real','finite','positive'});
    validateattributes(area,{'numeric'},{'scalar','integer','>=',1,'<=',3});
    field = sprintf('lfp_%d',area);
    validateattributes(data.(field),{'numeric'},{'2d','real','nonempty'});
    validateattributes(channels,{'numeric'}, ...
        {'vector','numel',3,'integer','>=',1,'<=',size(data.(field),1)});
    validateattributes(window_seconds,{'numeric'},{'scalar','finite','positive'});
    fs = data.srate;
    n = size(data.(field),2);
    assert(n>=4,'Sao necessarias pelo menos quatro amostras.');
    count = min(n,max(4,round(min(60,window_seconds)*fs)));
    last_start = n-count+1;
    first = 1;
    fig = figure('Name','b04: LFP bruto e qualidade','NumberTitle','off');
    fig.WindowStyle = 'docked';
    ax = gobjects(1,3); panel = gobjects(1,3);
    trace = gobjects(1,3); detail = gobjects(1,3);
    for c = 1:3
        ax(c) = subplot(4,1,c,'Parent',fig);
        trace(c) = plot(ax(c),NaN,NaN);
        ylabel(ax(c),'Amplitude'); grid(ax(c),'on');
        if ~isempty(amplitude_limits), ylim(ax(c),amplitude_limits); end
    end
    set(ax(1:2),'XTickLabel',{}); xlabel(ax(3),'Tempo (s)');

    validateattributes(options.bin_seconds,{'numeric'},{'scalar','finite','positive'});
    rms_line = gobjects(1,3); invalid_line = gobjects(1,3);
    for c = 1:3
        panel(c) = subplot(4,3,9+c,'Parent',fig);
        detail(c) = plot(panel(c),NaN,NaN,'Color',[.8 .2 .1]);
        hold(panel(c),'on');
        rms_line(c) = plot(panel(c),NaN,NaN,'Color',[.1 .3 .8]);
        invalid_line(c) = plot(panel(c),NaN,NaN,'kx','LineWidth',1.5);
        grid(panel(c),'on');
        xlabel(panel(c),'Tempo (s)'); ylabel(panel(c),'Amplitude');
        legend(panel(c),{'Pico a pico','RMS','NaN/Inf'},'Location','best');
    end

    linkaxes([ax panel],'x');
    for c = 1:3
        p = get(panel(c),'Position');
        p(2) = p(2)+.04; p(4) = max(.05,p(4)-.04);
        set(panel(c),'Position',p);
    end
    slider = uicontrol(fig,'Style','slider','Units','normalized', ...
        'Position',[.13 .015 .65 .025],'Min',0,'Max',1,'Value',0, ...
        'Callback',@slide);
    uicontrol(fig,'Style','pushbutton','String','<','Units','normalized', ...
        'Position',[.80 .015 .06 .025],'Callback',@(s,e) move(-1));
    uicontrol(fig,'Style','pushbutton','String','>','Units','normalized', ...
        'Position',[.88 .015 .06 .025],'Callback',@(s,e) move(1));
    if last_start==1
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
        t = (idx-1)/fs;
        for j = 1:3
            y = data.(field)(channels(j),idx);
            set(trace(j),'XData',t,'YData',y);
            title(ax(j),sprintf('Area %d | canal %d | %.3f - %.3f s', ...
                area,channels(j),t(1),t(end)));
            xlim(ax(j),[t(1) t(end)]);
        end

        bin = max(1,round(options.bin_seconds*fs));
        starts = 1:bin:count;
        centers = zeros(size(starts));
        for j = 1:3
            y = data.(field)(channels(j),idx);
            pp = NaN(size(starts)); rms_value = pp;
            invalid = false(size(starts));
            for b = 1:numel(starts)
                stop = min(count,starts(b)+bin-1);
                segment = y(starts(b):stop);
                centers(b) = (t(starts(b))+t(stop))/2;
                invalid(b) = any(~isfinite(segment));
                if ~invalid(b)
                    pp(b) = max(segment)-min(segment);
                    % Escalonamento evita overflow ao elevar amplitudes ao quadrado.
                    scale = max(abs(segment));
                    if scale==0, rms_value(b)=0;
                    else, rms_value(b)=scale*sqrt(mean((segment/scale).^2)); end
                end
            end
            set(detail(j),'XData',centers,'YData',pp);
            set(rms_line(j),'XData',centers,'YData',rms_value);
            set(invalid_line(j),'XData',centers(invalid), ...
                'YData',zeros(1,sum(invalid)));
            title(panel(j),sprintf('Canal %d | %d blocos NaN/Inf', ...
                channels(j),sum(invalid)));
        end

        for j = 1:3, xlim(panel(j),[t(1) t(end)]); end
        set(slider,'Value',(first-1)/max(1,last_start-1));
        drawnow;
    end
    function slide(src,~)
        first = 1+round(get(src,'Value')*(last_start-1)); refresh();
    end
    function move(direction)
        first = first+direction*max(1,round(count/2)); refresh();
    end
end
