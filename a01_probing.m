clc
clear all
[~,arquivos] = system('find ../data');
arquivos = split(arquivos);
arquivos = arquivos(2:end-1);

% %

animal = struct();
g = 1;
for a = 1 : 18
    animal(a).directory = arquivos{g};
    animal(a).file.trial_data = arquivos{g+1};
    animal(a).file.brain_area = arquivos{g+2};
    animal(a).file.clusters = arquivos{g+3};
    animal(a).file.lfp_1 = arquivos{g+4};
    animal(a).file.lfp_2 = arquivos{g+5};
    animal(a).file.lfp_3 = arquivos{g+6};
    animal(a).file.spikes = arquivos{g+7};
    animal(a).file.waveforms = arquivos{g+8};
    g = g + 9;
end

%%
data = load_all_animal_data(animal, 1);

%%
data

%%
% LFP
    % Channels within a brain area are contiguous in space, but channels from different brain areas are not.
    % Channels within a brain area are ordered from the deepest to the most superficial with respect to the brain surface.
    % The dataset includes every other channel from the Neuropixels probe. The vertical spacing between recording sites is 20 µm.
    % The signal has been recorded with an external reference and has already undergone a preprocessing pipeline.
    % Sampling rate: 500 Hz.
%%
function data = load_all_animal_data(animal, number)
    validateattributes(number, {'numeric'}, ...
        {'scalar', 'integer', '>=', 1, '<=', numel(animal)});

    files = animal(number).file;

    data = struct();
    data.source = struct('animal_number',number,'files',files);
    
    [data.trial,~,trial_raw] = xlsread(files.trial_data);
    % Retain explicit column semantics for questionnaire analyses. Numeric
    % spreadsheets sometimes contain an extra index column: never guess it.
    data.trial_columns = struct();
    required = {'trial_start','stim_start','outcome','trial_end','A','C'};
    normalized = {'trialstart','stimstart','outcome','trialend','variablea','variablec'};
    if size(trial_raw,2)==size(data.trial,2)
        for row = 1:min(5,size(trial_raw,1))
            names = repmat({''},1,size(trial_raw,2));
            for col = 1:numel(names)
                if ischar(trial_raw{row,col})
                    names{col} = regexprep(lower(trial_raw{row,col}),'[^a-z]','');
                end
            end
            candidate = struct();
            for key = 1:numel(required)
                idx = find(strcmp(names,normalized{key}));
                if numel(idx)==1, candidate.(required{key}) = idx; end
            end
            if numel(fieldnames(candidate))==numel(required)
                data.trial_columns = candidate;
                break
            end
        end
    end
    
    data.srate = 500;
    data.lfp_1 = load(files.lfp_1);
    data.lfp_2 = load(files.lfp_2);
    data.lfp_3 = load(files.lfp_3);
    
    
    data.spike_cluster   = load(files.clusters);
    data.spike_timestamp = load(files.spikes);
    
    data.waveform = load(files.waveforms);
    
    data_area             = load(files.brain_area);
    data.waveform_cluster = data_area.brain_areas.cluster_id';
    data.waveform_area    = data_area.brain_areas.brain_area';
    
    fields   = {'spike_cluster','lfp_1','lfp_2','lfp_3','spike_timestamp','waveform'};
    subfield = {'clusters','lfp1','lfp2','lfp3','spikes','wf'};

    for f = 1 : length(fields)
        data.(fields{f}) = data.(fields{f}).(subfield{f});
    end
end