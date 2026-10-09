clc
close all
clear all 
a01_probing

%%

lfp_viewer(data)
%%

function lfp_viewer(data)
%%
close all
    fig = figure();
    fig.WindowStyle = 'docked'
    
    ax = zeros(1,4);
    ax(1) = subplot(4,1,1);
    ax(2) = subplot(4,1,2);
    ax(3) = subplot(4,1,3);
    
    set(ax(1:2),'XTickLabel',{})
    
    ch = floor(1:size(data.lfp_1,1)/3:size(data.lfp_1,1));
    
    for c = 1:length(ch)
        plot(ax(c),data.lfp_1(ch(c),:))
    end
    
    linkaxes(ax)
    axis tight
    ylim(0.0002*[-1 1])
    
    xlim([0,5000])
    
end