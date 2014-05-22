%% Select dropped frames optimally within a chunk according to important index
% and playback sequence.
% selectDrops.m
% chenw@cmu.edu

function droppedIdx = selectDrops_II_ALL(download_frm_size, download_play_seq, download_impIdx, cur_play_TS, predict_bw, predict_latency)
    global T;
    droppedIdx = [];
    [violate, violateIdx] = predict_violates(download_frm_size, download_play_seq, cur_play_TS, predict_bw, predict_latency);
    droppexIdx = [];
    check_range = 1 : length(download_frm_size);
    while violate
        check_range(check_range > violateIdx(end)) = [];
        if  ~isempty(check_range)
            check_range_sz = download_frm_size(check_range);
            check_range_impIdx = download_impIdx(check_range);      

            [~, sortFrmIdx] = sort(check_range_impIdx, 'ascend');
            dropped_frame = check_range(sortFrmIdx(1));
            check_range(sortFrmIdx(1)) = [];
            droppedIdx = [droppedIdx; dropped_frame];
            download_frm_size(droppedIdx) = 0;
            % update the dropped frames
            [violate, violateIdx] = predict_violates(download_frm_size, download_play_seq, cur_play_TS, predict_bw, predict_latency);        
        else
            break;
        end
    end
    
    droppedIdx = sort(droppedIdx, 'ascend');

end