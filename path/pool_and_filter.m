function [electrodes,pool,manifest,directory] = pool_and_filter(data,o,root)
    validateattributes(o.pool_span_hz,{'numeric'},{'scalar','finite','positive'});
    validateattributes(o.minimum_electrodes,{'numeric'},{'scalar','integer','positive'});
    validateattributes(o.band_half_width_hz,{'numeric'},{'scalar','finite','positive'});
    validateattributes(o.filter_order,{'numeric'},{'scalar','integer','positive'});
    fs = data.srate;
    electrodes = struct([]);
    records = zeros(0,4); % frequencia, area, canal, proeminencia
    for area = 1:3
        field = sprintf('lfp_%d',area);
        channels = 1:size(data.(field),1);
        fprintf('Detectando picos: area %d, %d eletrodos\n',area,numel(channels));
        part = electrode_peaks(data,area,channels,o.segment_seconds, ...
            o.overlap_fraction,o.frequency_limits,o.background_width_hz, ...
            o.minimum_prominence_db,o.minimum_distance_hz,true);
        electrodes = [electrodes part]; %#ok<AGROW>
        for c = 1:numel(part)
            p = part(c).peaks;
            records = [records; p.frequency_hz, ...
                area*ones(height(p),1),channels(c)*ones(height(p),1), ...
                p.prominence_db]; %#ok<AGROW>
        end
    end
    records = sortrows(records,1);
    rows = zeros(0,7);
    members = cell(0,1);
    first = 1;
    while first<=size(records,1)
        % Nao usar encadeamento por vizinhos: evita grupos de largura ilimitada.
        last = first;
        while last<size(records,1) && ...
                records(last+1,1)-records(first,1)<=o.pool_span_hz
            last = last+1;
        end
        group = records(first:last,:);
        pairs = unique(group(:,2:3),'rows');
        if size(pairs,1)>=o.minimum_electrodes
            center = median(group(:,1)); % Cada pico contribui igualmente.
            % Bandas limitadas explicitamente ao intervalo analisado.
            lo = max(o.frequency_limits(1),center-o.band_half_width_hz);
            hi = min(o.frequency_limits(2),center+o.band_half_width_hz);
            assert(lo>0 && hi<fs/2, ...
                'Banda %.3f-%.3f Hz fora de (0,Nyquist); ajuste parametros.',lo,hi);
            rows(end+1,:) = [center lo hi size(pairs,1) ...
                size(group,1) min(group(:,1)) max(group(:,1))]; %#ok<AGROW>
            members{end+1,1} = group; %#ok<AGROW>
        end
        first = last+1;
    end
    pool = array2table(rows,'VariableNames',{'center_hz','low_hz','high_hz', ...
        'electrode_count','peak_count','minimum_peak_hz','maximum_peak_hz'});
    pool.members = members; % Colunas: frequencia, area, canal, proeminencia.
    % Cria saida exclusiva: nenhum resultado anterior e sobrescrito.
    if ~exist(root,'dir'), mkdir(root); end
    directory = tempname(root);
    mkdir(directory);
    manifest = struct([]);
    save(fullfile(directory,'analysis.mat'),'electrodes','pool','o','fs','-v7.3');
    index = 0;
    for b = 1:height(pool)
        [z,p,k] = butter(o.filter_order,[pool.low_hz(b) pool.high_hz(b)]/(fs/2));
        [sos,gain] = zp2sos(z,p,k);
        for area = 1:3
            field = sprintf('lfp_%d',area);
            for channel = 1:size(data.(field),1)
                % Apenas um canal e um componente completo por vez na RAM.
                signal = double(data.(field)(channel,:));
                assert(all(isfinite(signal)), ...
                    'Area %d canal %d contem NaN/Inf; filtragem interrompida.',area,channel);
                component = filtfilt(sos,gain,signal);
                metadata = struct('area',area,'channel',channel,'band_id',b, ...
                    'srate',fs,'time_origin_seconds',0, ...
                    'center_hz',pool.center_hz(b), ...
                    'band_hz',[pool.low_hz(b) pool.high_hz(b)], ...
                    'sos',sos,'gain',gain,'zero_phase',true, ...
                    'edge_policy','No samples discarded; inspect boundary transients');
                path = fullfile(directory,sprintf('band%03d_area%d_ch%03d.mat', ...
                    b,area,channel));
                save(path,'component','metadata','-v7.3');
                index = index+1;
                manifest(index).path = path;
                manifest(index).area = area;
                manifest(index).channel = channel;
                manifest(index).band_id = b;
                clear signal component
            end
        end
        fprintf('Filtrada banda %d/%d: %.3f-%.3f Hz\n', ...
            b,height(pool),pool.low_hz(b),pool.high_hz(b));
    end
    save(fullfile(directory,'manifest.mat'),'manifest','-v7.3');
    % manifest so existe ao concluir: pasta sem manifest indica execucao parcial.
    % Bandas podem se sobrepor. Componentes nao formam decomposicao aditiva.
end
