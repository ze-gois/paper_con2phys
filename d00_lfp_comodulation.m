clc
clear
a01_probing
%%



%%
clf
x=0
%%
imagesc(data.lfp_3)
xlim([0,100]+x)
x = x+25
colormap hsv
colorbar
caxis([-1 1]*0.0005)

%%
data = data.lfp_3([33,15],:)
%%

15

%%
ch = 13
t0 = 0;
tf = 100;
dt = 1/data.srate;
t = t0:dt:tf;
id = 1:tf*data.srate;

signal = data.lfp_3(ch,id);

f0 = 0;
ff = 150;
df = 3;
fw = 5;

freqs = f0:df:ff;
%%

proc = struct();
proc.filt = struct();
proc.filt(1).area = 3;
proc.filt(1).time = t;
proc.filt(1).frequencies = [freqs;freqs+fw];
proc.filt(1).lfp = zeros(length(freqs),length(id)); 


parfor f = freqs
    [z,p,k] = butter(4,[f,f+fw]/(data.srate/2));
    [sos,gain] = zp2sos(z,p,k);

    proc.filt(1).lfp(freqs,:) = filtfilt(sos,gain,signal);
end
%filtfilt(

























