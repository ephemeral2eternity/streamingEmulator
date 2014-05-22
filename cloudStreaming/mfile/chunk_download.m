%% The function is to record the elapsed time spending
% download_frm_idx : the indices of frames to be downloaded
% delta : the ratio of the duration of high bandwidth over one period
% hi_bw : the value of the high bandwidth
% lo_bw : the value of the low bandwidth
% get_dynamic_bw.m
% chenw@cmu.edu

function rec_TS = chunk_download(download_frm_sz, dynamic_bw, req_TS)
    total_size = sum(download_frm_sz);
    data_tobe_downloaded = total_size;
    curTS = req_TS;
    while (data_tobe_downloaded > 0)
        cur_time_idx = floor(curTS + 1);
        left_time = cur_time_idx - curTS;
        cur_bw = dynamic_bw(cur_time_idx);
        possible_data_downloaded = left_time * cur_bw;
        
        if possible_data_downloaded > data_tobe_downloaded
            elapsed_time = data_tobe_downloaded./cur_bw;
            curTS = curTS + elapsed_time;
            data_tobe_downloaded = 0;
            break;
        else
            data_tobe_downloaded = data_tobe_downloaded - possible_data_downloaded;
            curTS = curTS + left_time;
        end
    end
    rec_TS = curTS;
end