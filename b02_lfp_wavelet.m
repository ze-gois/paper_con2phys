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
    fig = figure('Name','b02: LFP bruto e wavelet','NumberTitle','off');
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

    validateattributes(options.frequency_limits,{'numeric'}, ...
        {'vector','numel',2,'finite','positive','<=',fs/2});
    assert(diff(options.frequency_limits)>0,'Limites de frequencia invalidos.');
    validate_color_limits(options.color_limits);
    cone = gobjects(1,3);
    for c = 1:3
        panel(c) = subplot(4,3,9+c,'Parent',fig);
        % Surface respeita o espacamento nao uniforme das frequencias CWT.
        detail(c) = surface(panel(c),[0 1;0 1],[1 1;2 2],zeros(2),NaN(2), ...
            'EdgeColor','none','FaceColor','texturemap');
        view(panel(c),2); hold(panel(c),'on');
        cone(c) = plot(panel(c),NaN,NaN,'w--','LineWidth',1);
        set(panel(c),'YScale','log','YDir','normal');
        ylim(panel(c),options.frequency_limits);
        xlabel(panel(c),'Tempo (s)'); ylabel(panel(c),'Frequencia (Hz)');
    end
    colormap(fig,parula);

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

        low = Inf; high = -Inf;
        for j = 1:3
            y = double(data.(field)(channels(j),idx));
            assert(all(isfinite(y)),'Janela contem NaN/Inf; confira o dado bruto.');
            [wt,freq,coi] = cwt(y(:),fs, ...
                'FrequencyLimits',options.frequency_limits);
            [freq,order] = sort(freq,'ascend');
            power = abs(wt(order,:)).^2;
            db = 10*log10(max(power,realmin('double')));
            % f < coi: suporte afetado pelas bordas; nao interpretar.
            valid = bsxfun(@ge,freq(:),coi(:)');
            db(~valid) = NaN;
            set(detail(j),'XData',t,'YData',freq(:), ...
                'ZData',zeros(size(db)),'CData',db);
            set(cone(j),'XData',t,'YData',coi);
            values = db(isfinite(db));
            if ~isempty(values)
                low = min(low,min(values)); high = max(high,max(values));
            end
        end
        if isempty(options.color_limits)
            if ~isfinite(low), low=-1; high=1; end
            if high<=low, high=low+1; end
            limits = [low high];
        else
            limits = options.color_limits;
        end
        set(panel,'CLim',limits);
        for j = 1:3
            title(panel(j),sprintf('Canal %d | CWT dB [%.1f, %.1f]', ...
                channels(j),limits(1),limits(2)));
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

function validate_color_limits(value)
    if isempty(value), return; end
    validateattributes(value,{'numeric'},{'vector','numel',2,'finite'});
    assert(value(2)>value(1),'Limites de cor invalidos.');
end
