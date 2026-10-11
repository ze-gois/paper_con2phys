a00_startup
%% Shared SCRIPT preparation for q01:q15; run a01_probing first.
% Optional qcfg overrides persist. No data reload, clear, or figures.
assert(exist('data','var')==1 && isstruct(data),'Run a01_probing first.');
if ~exist('qcfg','var'), qcfg = struct(); end
qdefaults = struct('seed',42,'bootstrap',1000,'block_seconds',30, ...
    'waveform_srate',30000,'narrow_ms',0.4,'minimum_spikes',50, ...
    'matched_units',5,'trial_columns',[],'lfp_channels',[1 1 1]);
qnames = fieldnames(qdefaults);
for qi = 1:numel(qnames)
    if ~isfield(qcfg,qnames{qi}), qcfg.(qnames{qi}) = qdefaults.(qnames{qi}); end
end
validateattributes(qcfg.bootstrap,{'numeric'},{'scalar','integer','>=',20});
validateattributes(qcfg.block_seconds,{'numeric'},{'scalar','finite','>=',4});
validateattributes(qcfg.matched_units,{'numeric'},{'scalar','integer','positive'});
validateattributes(qcfg.waveform_srate,{'numeric'},{'scalar','finite','positive'});
validateattributes(qcfg.lfp_channels,{'numeric'},{'vector','numel',3,'integer','positive'});
qctx = struct();
qctx.fs = double(data.srate);
assert(isscalar(qctx.fs) && isfinite(qctx.fs) && qctx.fs>0);
qctx.n = size(data.lfp_1,2);
assert(size(data.lfp_2,2)==qctx.n && size(data.lfp_3,2)==qctx.n, ...
    'LFP recordings must share a time axis.');
qctx.duration = qctx.n/qctx.fs; % samples represent [0,T)
qctx.ids = double(data.waveform_cluster(:));
qctx.area = double(data.waveform_area(:));
assert(numel(unique(qctx.ids))==numel(qctx.ids),'Duplicate cluster IDs.');
assert(numel(qctx.area)==numel(qctx.ids) && all(ismember(qctx.area,1:3)));
assert(size(data.waveform,1)==numel(qctx.ids),'Waveform rows must match IDs.');
qst = double(data.spike_timestamp(:)); qsc = double(data.spike_cluster(:));
assert(numel(qst)==numel(qsc));
[qknown,qunit] = ismember(qsc,qctx.ids);
qvalid = qknown & isfinite(qst) & qst>=0 & qst<qctx.duration;
qctx.excluded_spikes = sum(~qvalid);
qctx.spikes = cell(numel(qctx.ids),1);
for qi = 1:numel(qctx.ids), qctx.spikes{qi} = sort(qst(qvalid & qunit==qi)); end
qctx.rate = cellfun(@numel,qctx.spikes)/qctx.duration;
qctx.labels = {'Area 1';'Area 2';'Area 3'};
qctx.config = qcfg;
qctx.provenance = struct('duration_seconds',qctx.duration,'lfp_samples',qctx.n, ...
    'lfp_srate',qctx.fs,'cluster_ids',qctx.ids,'excluded_spikes',qctx.excluded_spikes);
if isfield(data,'source'), qctx.provenance.source=data.source; end
if isfield(data,'trial_columns'), qctx.provenance.trial_columns=data.trial_columns; end
if ~isempty(qcfg.trial_columns), qctx.provenance.trial_columns=qcfg.trial_columns; end
clear qst qsc qknown qunit qvalid qi qnames qdefaults
