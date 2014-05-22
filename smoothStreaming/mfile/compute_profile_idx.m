%% The function is to compute the maximum profile bitrates according to 
% the size of the frames.
% chunk_all_profiles : chunks in all profiles. Column indicates all the
% frame size in one chunk
% compute_profile_idx.m
% chenw@cmu.edu

function profile_idx = compute_profile_idx(chunk_all_profiles, chunk_play_seq, cur_play_TS, predict_bw, predict_latency)

profileNum = size(chunk_all_profiles, 2);
profile_idx = profileNum;
for i = 1 : profileNum
    cur_chunk = chunk_all_profiles(:, i);
    [violate, ~] = predict_violates(cur_chunk, chunk_play_seq, cur_play_TS, predict_bw, predict_latency);
    if ~violate
        profile_idx = i;
        break;
    end
end

end