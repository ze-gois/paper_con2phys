function fig = lfp_inspector(data)
%LFP_INSPECTOR Inspect raw LFP using bounded sliding windows (MATLAB R2019a).
% After a01_probing: fig = lfp_inspector(data);
% No toolboxes required. Signals remain in data; only visible samples are
% copied into graphics. Time zero is assumed to be the first LFP sample.
% Slider updates on release; arrow keys/buttons move half a window.
% Window is capped at 60 seconds. No filtering or display decimation.
validateattributes(data.srate, {'numeric'}, ...
    {'scalar','real','finite','positive'});
fs = data.srate;
fields = {'lfp_1','lfp_2','lfp_3'};
for k = 1:3
    validateattributes(data.(fields{k}), {'numeric'}, ...
        {'2d','real','nonempty'});
    assert(size(data.(fields{k}),2) >= 2, 'Need at least two samples.');
end
area = 1;
first = 1;
windowSeconds = 10;
channels = [];
busy = false;
fig = figure('Name','LFP: sliding window','NumberTitle','off', ...
    'Color','w','KeyPressFcn',@keyPressed);
axesHandles = gobjects(1,3);
lines = gobjects(1,3);
for k = 1:3
    axesHandles(k) = subplot(3,1,k,'Parent',fig);
    set(axesHandles(k),'Position',[.10 .76-(k-1)*.25 .86 .20]);
    lines(k) = plot(axesHandles(k),NaN,NaN);
    grid(axesHandles(k),'on');
    ylabel(axesHandles(k),'Amplitude (original units)');
end
xlabel(axesHandles(3),'Time (s)');
% Navigation is controlled below so built-in pan cannot expose unloaded data.
zoom(fig,'off'); pan(fig,'off');
slider = uicontrol(fig,'Style','slider','Units','normalized', ...
    'Position',[.10 .08 .68 .035],'Min',0,'Max',1,'Value',0, ...
    'Callback',@slide);
uicontrol(fig,'Style','pushbutton','String','<','Units','normalized', ...
    'Position',[.80 .08 .07 .035],'Callback',@(s,e) move(-1));
uicontrol(fig,'Style','pushbutton','String','>','Units','normalized', ...
    'Position',[.89 .08 .07 .035],'Callback',@(s,e) move(1));
areaMenu = uicontrol(fig,'Style','popupmenu','String', ...
    {'Area 1','Area 2','Area 3'},'Units','normalized', ...
    'Position',[.10 .025 .12 .035],'Callback',@changeArea);
uicontrol(fig,'Style','text','String','Window (s)', ...
    'Units','normalized','Position',[.23 .025 .10 .035]);
windowEdit = uicontrol(fig,'Style','edit','String','10', ...
    'Units','normalized','Position',[.34 .025 .07 .035], ...
    'Callback',@changeWindow);
uicontrol(fig,'Style','text','String','Channels', ...
    'Units','normalized','Position',[.43 .025 .09 .035]);
channelEdit = uicontrol(fig,'Style','edit','Units','normalized', ...
    'Position',[.53 .025 .18 .035],'Callback',@changeChannels);
status = uicontrol(fig,'Style','text','Units','normalized', ...
    'Position',[.72 .025 .25 .035],'HorizontalAlignment','left');
resetChannels();
refresh();

    function resetChannels()
        nc = size(data.(fields{area}),1);
        channels = round(linspace(1,nc,3));
        set(channelEdit,'String',sprintf('%d %d %d',channels));
    end

    function [n, count, lastStart] = bounds()
        n = size(data.(fields{area}),2);
        count = min(n,max(2,round(windowSeconds*fs)));
        lastStart = n-count+1;
    end

    function refresh()
        if busy || ~isgraphics(fig), return; end
        busy = true;
        cleanup = onCleanup(@unlock); %#ok<NASGU>
        [n,count,lastStart] = bounds();
        first = min(lastStart,max(1,round(first)));
        idx = first:first+count-1;
        t = (idx-1)/fs; % Allocate only the visible time vector.
        for j = 1:3
            y = data.(fields{area})(channels(j),idx);
            set(lines(j),'XData',t,'YData',y);
            set(axesHandles(j),'XLim',[t(1) t(end)],'YLimMode','auto');
            title(axesHandles(j),sprintf('Area %d | channel %d',area,channels(j)));
        end
        set(slider,'Value',(first-1)/max(1,lastStart-1));
        if lastStart == 1
            set(slider,'Enable','off');
        else
            small = min(1,max(1,round(count/2))/(lastStart-1));
            set(slider,'Enable','on','SliderStep',[small min(1,2*small)]);
        end
        set(status,'String',sprintf('%.3f-%.3f / %.3f s', ...
            t(1),t(end),(n-1)/fs));
        drawnow limitrate;
    end

    function unlock()
        busy = false;
    end

    function slide(src,~)
        [~,~,lastStart] = bounds();
        first = 1+round(get(src,'Value')*(lastStart-1));
        refresh();
    end

    function move(direction)
        [~,count,~] = bounds();
        first = first+direction*max(1,round(count/2));
        refresh();
    end

    function keyPressed(~,event)
        % Do not intercept arrow keys while typing into an edit field.
        focus = get(fig,'CurrentObject');
        if isgraphics(focus,'uicontrol') && strcmp(get(focus,'Style'),'edit')
            return;
        end
        switch event.Key
            case 'rightarrow', move(1);
            case 'leftarrow', move(-1);
        end
    end

    function changeArea(src,~)
        area = get(src,'Value');
        resetChannels();
        refresh();
    end

    function changeWindow(src,~)
        value = str2double(get(src,'String'));
        if isscalar(value) && isfinite(value) && value > 0
            windowSeconds = min(60,max(2/fs,value));
        end
        set(windowEdit,'String',num2str(windowSeconds));
        refresh();
    end

    function changeChannels(src,~)
        tokens = regexp(strtrim(get(src,'String')),'[,;\s]+','split');
        value = str2double(tokens);
        nc = size(data.(fields{area}),1);
        if numel(value) == 3 && all(isfinite(value)) && ...
                all(value == round(value)) && all(value >= 1 & value <= nc)
            channels = value;
        end
        set(channelEdit,'String',sprintf('%d %d %d',channels));
        refresh();
    end
end
