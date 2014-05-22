%% The function is to predict whether there will be frames violating the deadline
% in the chunk to be downloade
% download_frm_idx : the indices of frames to be downloaded
% cur_play_TS : the playing timestamp
% predict_bw : the bandwidth that is predicted from last chunk
% predict_violates.m
% chenw@cmu.edu

function [violate, violateIdx] = predict_violates(download_frm_size, download_play_seq, cur_play_TS, predict_bw, predict_latency)
    global T;
    
    violate = false;
    deadline = download_play_seq.* T - cur_play_TS;
    predict_arrival = cumsum(download_frm_size) ./ predict_bw + predict_latency;

    diffTS = deadline - predict_arrival; % The expected TS should be later than the predicted TS, otherwise the player will drop frames or freeze

    violateIdx = find(diffTS < 0);
    
    if ~isempty(violateIdx)
        violate = true;
    end
end