%% Determine which frame will be requested from which connection in one GoP
% updateConnChunks.m
% chenw@cmu.edu

function download_frm_idx = updateConnChunks(method_ind, monitored_bw, start_frm, chunkLen, cur_play_TS)

global frame_size;
global frame_imp_idx;
global play_seq;
global frmRate;

    download_frm_idx = cell(2, 1);
    conn_num = length(download_frm_idx);
    chunk_imp_idx = frame_imp_idx(start_frm : start_frm + chunkLen*frmRate - 1);
    chunk_idx = start_frm : start_frm + chunkLen*frmRate - 1;
    switch method_ind
        case 0
            %% Priority Based Scheduling allowing frame drops in the most unreliable connection.
            avail_bw = monitored_bw(1, :);
            latencies = monitored_bw(2, :);
            bw_var = monitored_bw(3, :);

            
            [~, sort_bw_var_ix] = sort(bw_var, 'ascend');
            [~, sort_frame_imp_idx] = sort(chunk_imp_idx, 'descend');
            
            for i = 1 : length(sort_bw_var_ix) - 1
                cur_bw = avail_bw(sort_bw_var_ix(i)) .* 0.9;
                cur_latency = latencies(sort_bw_var_ix(i));
                conn_idx = sort_bw_var_ix(i);
                download_frm_idx{conn_idx} = [];
                
                violate = false;
                
                local_frm_idx = [];
                while ~violate && (length(local_frm_idx) < chunkLen*frmRate/conn_num)
                    local_frm_idx = [local_frm_idx; sort_frame_imp_idx(1)];
                    tmp_download_idx = chunk_idx(local_frm_idx);
                    download_frm_size = frame_size(tmp_download_idx);
                    download_play_seq = play_seq(tmp_download_idx);
                    [violate, ~] = predict_violates(download_frm_size, download_play_seq, cur_play_TS, cur_bw, cur_latency);
                    
                    if violate
                        local_frm_idx = local_frm_idx(1 : end - 1);
                    end
                    sort_frame_imp_idx(1) = [];
                end
                tmp_download_idx = chunk_idx(local_frm_idx);
                [download_frm_idx{conn_idx}, ~] = sort(tmp_download_idx, 'ascend');
            end
            
            if ~isempty(sort_frame_imp_idx)
                [download_frm_idx{length(sort_bw_var_ix)}, ~] = sort(chunk_idx(sort_frame_imp_idx), 'ascend');
            end
        case 1
            %% Round-robin case without frame drops
            for i = 1 : length(download_frm_idx)
                download_frm_idx{i} = start_frm + i - 1 : conn_num  : start_frm + chunkLen*frmRate - 1;
            end
        otherwise
        error('Unknown experimental setting for the bandwidth.');
    end

end