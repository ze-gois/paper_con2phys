function result = lfp_envelope_moments(lfp,fs,varargin)
%LFP_ENVELOPE_MOMENTS Sliding moments of band-limited LFP Hilbert envelopes.
%   RESULT = LFP_ENVELOPE_MOMENTS(LFP,FS) accepts LFP as channels x samples
%   and computes the mean, population variance, skewness, and excess
%   kurtosis of amplitude envelopes for theta (4-12 Hz), beta (13-30 Hz),
%   and gamma (30-80 Hz), using 10 s complete windows every 0.1 s.
%
%   Name/value options:
%     'WindowSeconds'     - window length in seconds (default 10)
%     'StepSeconds'       - spacing in seconds (default 0.1)
%     'TimeOriginSeconds' - time of the first input sample (default 0)
%     'ChannelIds'        - per-row channel identifiers (default 1:nchannels)
%     'EdgeSeconds'       - flagged filtering edge margin (default 2)
%     'ChunkWindows'      - output windows per moment block (default 512)
%     'OutputClass'       - 'double' (default) or 'single'
%
%   All moment arrays have dimensions [windows x channels x bands].
%   RESULT.time_seconds is the center of each window, using actual sample
%   timestamps. The start is inclusive, the end time is exclusive; complete
%   windows only. 'WindowSeconds' and 'StepSeconds' are rounded to samples,
%   with effective values recorded in RESULT.config.
%
%   Filtering uses fourth-order Butterworth bandpasses in SOS form,
%   zero-phase FILTFILT, and ABS(HILBERT(...)). It operates on one entire
%   channel per band, avoiding a channels x samples x bands intermediate.
%   Moment extraction uses locally centered, scaled, prefix-summed powers
%   in blocks, O(samples + windows) for each band/channel.
%
%   A channel containing any NaN/Inf is not filtered; all its statistics
%   are NaN and RESULT.channel_valid marks it false. Zero-variance envelopes
%   have skewness/kurtosis = NaN (undefined). RESULT.edge_affected identifies
%   heuristic end effects; flagged outputs are retained, not zeroed.
%   Overlapping windows are statistically dependent.
%
%   Requires Signal Processing Toolbox (BUTTER, ZP2SOS, FILTFILT, HILBERT).
%
%   Example (after a01_probing and a00_startup):
%     moments = lfp_envelope_moments(data.lfp_1,data.srate);
%     plot(moments.time_seconds,moments.mean(:,1,1));
%
%   MATLAB R2019a+.
    validateattributes(lfp,{'numeric'},{'real','2d','nonempty'},mfilename,'lfp',1);
    validateattributes(fs,{'numeric'},{'scalar','real','finite','positive'},mfilename,'fs',2);
    fs = double(fs);

    p = inputParser;
    p.FunctionName = mfilename;
    addParameter(p,'WindowSeconds',10,@positive_scalar);
    addParameter(p,'StepSeconds',0.1,@positive_scalar);
    addParameter(p,'TimeOriginSeconds',0,@finite_scalar);
    addParameter(p,'ChannelIds',[],@(x) isnumeric(x) && isvector(x) && all(isfinite(x(:))));
    addParameter(p,'EdgeSeconds',2,@nonnegative_scalar);
    addParameter(p,'ChunkWindows',512,@(x) positive_scalar(x) && x==floor(x));
    addParameter(p,'OutputClass','double',@(x) ischar(x) || (isstring(x) && isscalar(x)));
    parse(p,varargin{:});
    cfg = p.Results;
    cfg.OutputClass = char(cfg.OutputClass);
    assert(ismember(cfg.OutputClass,{'double','single'}), ...
        'OutputClass must be ''double'' or ''single''.');

    band_names = {'theta','beta','gamma'};
    band_hz = [4 12;13 30;30 80];
    assert(fs/2>max(band_hz(:)), ...
        'Sampling rate must be greater than 160 Hz for gamma up to 80 Hz.');
    n_channels = size(lfp,1);
    n_samples = size(lfp,2);
    if isempty(cfg.ChannelIds), cfg.ChannelIds = 1:n_channels; end
    assert(numel(cfg.ChannelIds)==n_channels, ...
        'ChannelIds must contain one identifier per LFP row.');
    cfg.ChannelIds = reshape(cfg.ChannelIds,1,[]);

    n_window = round(cfg.WindowSeconds*fs);
    n_step = round(cfg.StepSeconds*fs);
    assert(n_window>=2 && n_step>=1, ...
        'Window and step must correspond to at least two and one samples.');
    assert(n_samples>=n_window,'Recording is shorter than one full window.');
    cfg.effective_window_seconds = n_window/fs;
    cfg.effective_step_seconds = n_step/fs;
    cfg.filter_order = 4;
    cfg.band_hz = band_hz;
    cfg.band_names = band_names;
    cfg.fs = fs;
    cfg.n_samples = n_samples;

    first_sample = (1:n_step:(n_samples-n_window+1))';
    last_sample = first_sample+n_window-1;
    n_frames = numel(first_sample);
    n_bands = size(band_hz,1);
    origin = cfg.TimeOriginSeconds;
    result = struct();
    result.mean = nan(n_frames,n_channels,n_bands,cfg.OutputClass);
    result.variance = nan(n_frames,n_channels,n_bands,cfg.OutputClass);
    result.skewness = nan(n_frames,n_channels,n_bands,cfg.OutputClass);
    result.excess_kurtosis = nan(n_frames,n_channels,n_bands,cfg.OutputClass);
    result.time_seconds = origin+(first_sample-1+(n_window-1)/2)/fs;
    result.window_start_seconds = origin+(first_sample-1)/fs;
    result.window_end_seconds = origin+last_sample/fs;
    result.window_start_sample = first_sample;
    result.window_end_sample = last_sample;
    result.channel_ids = cfg.ChannelIds;
    result.band_names = band_names;
    result.band_hz = band_hz;
    result.channel_valid = all(isfinite(lfp),2);
    edge_samples = ceil(cfg.EdgeSeconds*fs);
    result.edge_affected = first_sample<=edge_samples | ...
        last_sample>n_samples-edge_samples;
    result.config = cfg;
    result.method = ['SOS Butterworth 4th-order bandpass; zero-phase filtfilt; ' ...
        'Hilbert amplitude; population central moments; skewness = mu3/mu2^(3/2); ' ...
        'excess kurtosis = mu4/mu2^2 - 3'];
    result.time_reference = 'window center; recording first sample at TimeOriginSeconds';
    result.window_convention = '[window_start_seconds, window_end_seconds)';
    result.filter = repmat(struct('sos',[],'gain',[]),1,n_bands);

    for b = 1:n_bands
        [zeros_b,poles_b,gain_b] = butter(cfg.filter_order, ...
            band_hz(b,:)/(fs/2),'bandpass');
        [sos,gain] = zp2sos(zeros_b,poles_b,gain_b);
        result.filter(b).sos = sos;
        result.filter(b).gain = gain;
        for ch = 1:n_channels
            if ~result.channel_valid(ch), continue; end
            % Operate on one channel and band at a time; no copied tensor.
            signal = double(lfp(ch,:)).';
            filtered = filtfilt(sos,gain,signal);
            clear signal
            amplitude = abs(hilbert(filtered));
            clear filtered
            [mu,v,sk,ku] = sliding_moments(amplitude,first_sample, ...
                last_sample,n_window,cfg.ChunkWindows);
            result.mean(:,ch,b) = cast(mu,cfg.OutputClass);
            result.variance(:,ch,b) = cast(v,cfg.OutputClass);
            result.skewness(:,ch,b) = cast(sk,cfg.OutputClass);
            result.excess_kurtosis(:,ch,b) = cast(ku,cfg.OutputClass);
            clear amplitude
        end
    end

    result.provenance = struct( ...
        'original_input_class',class(lfp), ...
        'input_orientation','channels x samples', ...
        'time_origin_seconds',origin, ...
        'n_samples',n_samples, ...
        'n_channels',n_channels, ...
        'invalid_channel_ids',cfg.ChannelIds(~result.channel_valid), ...
        'n_edge_affected_windows',nnz(result.edge_affected), ...
        'edge_policy','Flag only: no filtered/Hilbert edge correction or removal', ...
        'window_overlap_fraction',max(0,1-n_step/n_window));
end

function [mean_out,var_out,skew_out,kurt_out] = sliding_moments(a,starts,ends,n_window,block_size)
    n = numel(starts);
    mean_out = nan(n,1);
    var_out = nan(n,1);
    skew_out = nan(n,1);
    kurt_out = nan(n,1);

    for base = 1:block_size:n
        idx = base:min(n,base+block_size-1);
        offset = starts(idx(1))-1;
        segment = a(offset+1:ends(idx(end)));
        location = mean(segment);
        scale = std(segment,1);
        if scale==0
            mean_out(idx) = location;
            var_out(idx) = 0;
            continue
        end
        z = (segment-location)/scale;
        lo = starts(idx)-offset;
        hi = ends(idx)-offset;
        r1 = local_window_mean(z,lo,hi,n_window,1);
        r2 = local_window_mean(z,lo,hi,n_window,2);
        r3 = local_window_mean(z,lo,hi,n_window,3);
        r4 = local_window_mean(z,lo,hi,n_window,4);
        central2 = max(0,r2-r1.^2);
        central3 = r3-3*r1.*r2+2*r1.^3;
        central4 = r4-4*r1.*r3+6*r1.^2.*r2-3*r1.^4;

        mean_out(idx) = location+scale*r1;
        var_out(idx) = scale^2*central2;
        % Very small variances relative to block scale cannot reliably
        % distinguish shape from numerical roundoff.
        reliable = central2>128*eps(max(1,max(abs(r2))));
        skew_out(idx(reliable)) = central3(reliable)./central2(reliable).^(3/2);
        kurt_out(idx(reliable)) = central4(reliable)./central2(reliable).^2-3;
    end
end

function avg = local_window_mean(z,lo,hi,n_window,order)
    if order>1, z = z.^order; end
    prefix = [0;cumsum(z)];
    avg = (prefix(hi+1)-prefix(lo))/n_window;
end

function ok = positive_scalar(x)
    ok = isnumeric(x) && isscalar(x) && isreal(x) && isfinite(x) && x>0;
end

function ok = nonnegative_scalar(x)
    ok = isnumeric(x) && isscalar(x) && isreal(x) && isfinite(x) && x>=0;
end

function ok = finite_scalar(x)
    ok = isnumeric(x) && isscalar(x) && isreal(x) && isfinite(x);
end
