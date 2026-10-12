%% a00: funcoes do questionario e metodos MATLAB de neuronal
% Caminhos relativos ao script; nao altera pwd nem salva o path global.
con2phys_neuronal_root = getenv('NEURONAL_ROOT');
if isempty(con2phys_neuronal_root)
    con2phys_neuronal_root = fullfile(fileparts(fileparts(mfilename('fullpath'))),'neuronal');
end
con2phys_matlab_path = fullfile(con2phys_neuronal_root,'matlab','path');
assert(isfile(fullfile(con2phys_matlab_path,'spike_counts_edges.m')), ...
    'CON2PHYS:MissingNeuronal', ...
    ['Metodos MATLAB nao encontrados em %s. Clone neuronal ao lado de ' ...
     'paper_con2phys ou defina NEURONAL_ROOT para a raiz do checkout neuronal.'], ...
    con2phys_matlab_path);
addpath(con2phys_matlab_path);
addpath(fullfile(fileparts(mfilename('fullpath')),'path'));
clear con2phys_neuronal_root con2phys_matlab_path
