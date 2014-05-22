%% The function is to record the elapsed time spending
% download_frm_idx : the indices of frames to be downloaded
% delta : the ratio of the duration of high bandwidth over one period
% hi_bw : the value of the high bandwidth
% lo_bw : the value of the low bandwidth
% get_dynamic_bw.m
% chenw@cmu.edu

function [dropped_frms, rec_TS] = chunk_download(download_frm_sz, play_seq, dynamic_bw, req_TS, cur_play_TS, drop_idx)
    global T;
    curTS = req_TS;
    
    frm_rec_TS = zeros(size(download_frm_sz));
    dropped_frms = [];
    for i = 1 : length(download_frm_sz)
        cur_frm_sz = download_frm_sz(i);
        cur_time_idx = floor(curTS + 1);
        cur_bw = dynamic_bw(cur_time_idx);
        elapsed_time = cur_frm_sz ./ cur_bw;
        frm_rec_TS(i) = curTS + elapsed_time;
        
        if drop_idx ~= 0
            if frm_rec_TS(i) - req_TS > play_seq(i)*T - cur_play_TS
                dropped_frms = [dropped_frms; i];
            end
        end
        curTS = curTS + elapsed_time;
    end
    
    rec_TS = curTS;
end