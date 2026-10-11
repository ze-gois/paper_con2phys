clc
clear all
a00_startup

paper_path = '/home/gois/Insync/jhenriquetdg@gmail.com/Google Drive/matlab/paper_con2phys';
data_path = fullfile(paper_path ,'..','data');
[~,arquivos] = system(sprintf('find "%s"',data_path));
arquivos = splitlines(arquivos);
arquivos = arquivos(2:end-1);
arquivos = arquivos(~contains(arquivos,'derived'));
arquivos = sort(arquivos);
%%
% %

animal = struct();
g = 1;
for a = 1 : 18
    animal(a).directory = arquivos{g};
    
    animal(a).file.trial_data = arquivos{g+7};
    animal(a).file.brain_area = arquivos{g+1};
    animal(a).file.clusters = arquivos{g+2};
    animal(a).file.lfp_1 = arquivos{g+3};
    animal(a).file.lfp_2 = arquivos{g+4};
    animal(a).file.lfp_3 = arquivos{g+5};
    animal(a).file.spikes = arquivos{g+6};
    animal(a).file.waveforms = arquivos{g+8};
    g = g + 9;
end
clear g a
%%
%data = load_all_animal_data(animal, 1);

%%
%data

%%
% LFP
    % Channels within a brain area are contiguous in space, but channels from different brain areas are not.
    % Channels within a brain area are ordered from the deepest to the most superficial with respect to the brain surface.
    % The dataset includes every other channel from the Neuropixels probe. The vertical spacing between recording sites is 20 µm.
    % The signal has been recorded with an external reference and has already undergone a preprocessing pipeline.
    % Sampling rate: 500 Hz.
%%
