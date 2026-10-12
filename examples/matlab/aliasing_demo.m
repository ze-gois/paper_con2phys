% ALIASING_DEMO Reproducible synthetic sampling illustration.
% No toolbox, data file, graphics display or user workspace is required.
% MATLAB R2019a+; execution with run('examples/matlab/aliasing_demo.m').
fs = 100;                         % samples per second
duration_s = 0.20;
t = 0:1/10000:duration_s;         % finely resolved reference grid
n = 0:round(duration_s*fs);
f_low = 15;
f_alias = f_low + fs;
x_low = sin(2*pi*f_low*t);
x_high = sin(2*pi*f_alias*t);
samples_low = sin(2*pi*f_low*n/fs);
samples_high = sin(2*pi*f_alias*n/fs);
assert(max(abs(samples_low-samples_high)) < 1e-12, ...
    'Integer sampling should alias f and f+fs.');
fig = figure('Visible','off','Color','w');
plot(t,x_low,'LineWidth',1.4);
hold on;
plot(t,x_high,'LineWidth',0.8);
plot(n/fs,samples_low,'ko','MarkerFaceColor','k');
xlabel('Time (s)');
ylabel('Amplitude (a.u.)');
title('Two distinct continuous frequencies, identical sampled values');
legend('15 Hz','115 Hz','Samples','Location','best');
grid on;
destination = fullfile('books','electrophysiology','figures','generated');
if ~exist(destination,'dir'), mkdir(destination); end
exportgraphics(fig,fullfile(destination,'aliasing_demo.pdf'),'ContentType','vector');
exportgraphics(fig,fullfile(destination,'aliasing_demo.png'),'Resolution',180);
close(fig);
