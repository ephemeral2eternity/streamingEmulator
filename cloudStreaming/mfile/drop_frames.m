%% Select dropped frames optimally within a chunk to avoid freezing
% drop_frames.m
% chenw@cmu.edu

function droppedIdx = drop_frames(download_frm_idx, cur_play_TS, predict_bw, predict_latency, drop_method)

global frame_size;
global frame_typ;
global frame_imp_idx;
global play_seq;

download_frm_size = frame_size(download_frm_idx);
download_play_seq = play_seq(download_frm_idx);
download_impIdx = frame_imp_idx(download_frm_idx);
download_frm_typ = frame_typ(download_frm_idx);

droppedIdx = [];

switch drop_method
    case 'II_ALL'
        droppedIdx = selectDrops_II_ALL(download_frm_size, download_play_seq, download_impIdx, cur_play_TS, predict_bw, predict_latency);
    case 'II_PB'
        droppedIdx = selectDrops_II_PB(download_frm_size, download_play_seq, download_impIdx, download_frm_typ, cur_play_TS, predict_bw, predict_latency);
    case 'II_B'
        droppedIdx = selectDrops_II_B(download_frm_size, download_play_seq, download_impIdx, download_frm_typ, cur_play_TS, predict_bw, predict_latency);
    case 'II_Th'
        impIdx_Th = 8;
        droppedIdx = selectDrops_II_Th(download_frm_size, download_play_seq, download_impIdx, cur_play_TS, impIdx_Th, predict_bw, predict_latency);
    otherwise
        error('Unknown dropping method.');
end


end
