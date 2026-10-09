%% b03: LFP bruto e distribuicao espacial
% Execute o probing antes deste script. data permanece na RAM.
% Apenas a janela visivel e copiada para os objetos graficos.
area = 1;
field = sprintf('lfp_%d',area);
channels = round(linspace(1,size(data.(field),1),3));
window_seconds = 10; % Limitada a 60 s para manter o custo da inspecao previsivel.
amplitude_limits = 0.0002*[-1 1]; % [] para escala automatica.
% Mapas mostram todos os canais de cada area; sem toolbox adicional.
options.color_limits = 0.0002*[-1 1]; % Unidades originais, mesma escala nas areas.
% Canal e indice, nao profundidade fisica. Nao e uma estimativa de CSD.
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
    fig = figure('Name','b03: LFP bruto e distribuicao espacial','NumberTitle','off');
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

    validateattributes(options.color_limits,{'numeric'}, ...
        {'vector','numel',2,'finite'});
    assert(diff(options.color_limits)>0,'Limites de cor invalidos.');
    for c = 1:3
        name = sprintf('lfp_%d',c);
        validateattributes(data.(name),{'numeric'},{'2d','real','nonempty'});
        assert(size(data.(name),2)==n,'As areas devem ter a mesma duracao.');
        panel(c) = subplot(4,3,9+c,'Parent',fig);
        detail(c) = imagesc(panel(c),[0 1],[1 size(data.(name),1)],NaN(2));
        set(panel(c),'YDir','normal','CLim',options.color_limits);
        ylim(panel(c),[.5 size(data.(name),1)+.5]);
        title(panel(c),sprintf('Area %d | amplitude [%.3g, %.3g]', ...
            c,options.color_limits(1),options.color_limits(2)));
        xlabel(panel(c),'Tempo (s)'); ylabel(panel(c),'Canal');
    end
    % Azul-branco-vermelho: zero branco, quando os limites sao simetricos.
    v = linspace(0,1,128)';
    colormap(fig,[v v ones(128,1);ones(128,1) flipud(v) flipud(v)]);

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

        for j = 1:3
            name = sprintf('lfp_%d',j);
            block = data.(name)(:,idx);
            set(detail(j),'XData',[t(1) t(end)], ...
                'YData',[1 size(block,1)],'CData',block);
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
