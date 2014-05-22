%% The emulation of multiple connection based streaming in Cloud or p2p
% Assumption: all the source servers have the content
% cloudStreaming.m
% chenw@cmu.edu


function cloudStreaming(vidName, exp_num, chunkLen, start_cnt, method_ind, bw_setting, drop_idx)

global frame_size;
global frame_typ;
global frame_imp_idx;
global play_seq;
global vidName;
global symbols;
global frmRate;
global T;

symbols = {'-k', '--r', '-.b', '-+g', '-+c', '--m', '-og', '-*y', ':k'};
frm_str_typs = {'I', 'P', 'B'};

%% Compute the propagation factor.
% Load the video frame info.
load(['../mat/' vidName '-cs.mat']);
frame_size = cs(:, 2);
frame_typ = cs(:, 3);
frame_imp_idx = cs(:, 4);
play_seq = cs(:, 1);
frmRate = 25;
bufSz = 20;     % The maximum seconds of frames that can be saved in the buffer.
drop_methods = {'II_ALL', 'II_PB', 'II_B', 'II_Th'};

conn_num = length(bw_setting);


%% Construct the estimated available bandwidth
total_time = 5*length(frame_size)./frmRate;

dynamic_bw = [];
for cn = 1 : length(bw_setting)
    dynamic_bw = [dynamic_bw get_exp_bw(total_time, bw_setting(cn), exp_num)];
end

%% Emulate the streaming according to the available bandwidth
% Get the 5 sec buffer filled as fast as possible
bufEvents = [];
dropEvents = [];

%% Variable initialization
state = 'Buffering';
T = 1 ./ frmRate;  % The time period for each frame to be displayed

%% Parameters Initialization
TS = 0;     % The Time Stamp will be got based on the start playing timestamp
preTS = 0;
i = 1;      % Download Chunk Index
cur_play_TS = 0;     % The frame that is played now
pre_play_TS = 0;
downloadLen = 0;    % The time period that is used to download the chunk.
bufferingTime = 0;
vid_len = length(frame_size);
curBufSz = 0;
monitored_bw = [5*1024*1024/8 5*1024*1024/8; 1 1; 0.05 0.05];
all_dropped_frames = [];

while i < vid_len
    if strcmp(state, 'Buffering')
        % Determine which frame is downloaded from which connection
        download_frm_idx = updateConnChunks(1, monitored_bw, i, start_cnt, cur_play_TS);
        
        % Emulating the downloading period.
        rec_TS = zeros(conn_num, 1);
        for c = 1 : conn_num
            % Download chunks for each connection.
            chunk_size = frame_size(download_frm_idx{c});
            chunk_play_seq = play_seq(download_frm_idx{c});
            rec_TS(c) = chunk_download(chunk_size,  dynamic_bw(:, c), TS);
            % disp(['Downloading chunk starting with frame' num2str(i) ' at connection ' num2str(c) ' !!!']);
            
            [predict_bw, predict_latency] = emulate_monitoring(dynamic_bw(:, c), rec_TS);
            
            % Update the monitored bandwidth.
            bw_var = abs(predict_bw - monitored_bw(1, c));
            monitored_bw(1, c) = predict_bw;
            monitored_bw(2, c) = predict_latency;
            monitored_bw(3, c) = bw_var;
        end 
        
        % Estimate the buffering time.
        max_rec_TS = max(rec_TS);
        
        bufferingTime = max_rec_TS - TS - curBufSz;
        bufEvents = [bufEvents; i bufferingTime];
        
        % update the status of all parameters
        preTS = TS;        
        TS = max_rec_TS - curBufSz;    %?????profile_idx
        state = 'Steady';
        curBufSz = start_cnt;
                        
        % Write the log;
        % disp(['======= The player is buffering with period ' num2str(bufferingTime) ' at frame ' num2str(i) '!!!! ======']);
        pre_play_TS = cur_play_TS;
        i = i + start_cnt * frmRate;
    elseif strcmp(state, 'Steady') 
        if (i + chunkLen * frmRate - 1 < vid_len)        
            download_len = chunkLen;
        else
            download_len = (vid_len - i + 1)./frmRate;
        end
        if (curBufSz <= bufSz - chunkLen)
            % Enter the "Request" mode, to download the next chunk from
            % multiple connections
            download_frm_idx = updateConnChunks(mod(method_ind, 2), monitored_bw, i, download_len, cur_play_TS);

            % Emulating the downloading period.
            rec_TS = zeros(conn_num, 1);

            
            for c = 1 : conn_num
                % Preventatively Drop frames
                
                if (drop_idx == 1)
                    droppedIdx = drop_frames(download_frm_idx{c}, cur_play_TS, monitored_bw(1,c) - monitored_bw(3,c), monitored_bw(2, c), 'II_ALL');
                    if ~isempty(droppedIdx)
                        dropped_frames = download_frm_idx{c}(droppedIdx)';

                        % update the frames to download after dropping
                        all_dropped_frames = [all_dropped_frames; dropped_frames];
                        download_frm_idx{c}(droppedIdx) = [];
                    end
                end
                
                chunk_size = frame_size(download_frm_idx{c});
                rec_TS(c) = chunk_download(chunk_size, dynamic_bw(:, c), TS);

                [predict_bw, predict_latency] = emulate_monitoring(dynamic_bw(:, c), rec_TS);

                % Update the monitored bandwidth.
                bw_var = abs(predict_bw - monitored_bw(1, c));
                monitored_bw(1, c) = predict_bw;
                monitored_bw(2, c) = predict_latency;
                monitored_bw(3, c) = bw_var;
            end          

            % Update all the parameters after downloading
            max_rec_TS = max(rec_TS);
            pre_play_TS = cur_play_TS;
            cur_play_TS = cur_play_TS + (max_rec_TS - TS);
            curBufSz = curBufSz + download_len - (max_rec_TS - TS);
            i = i + download_len * frmRate;
            preTS = TS;
            TS = max_rec_TS;

            if (curBufSz < 0)
                state = 'Buffering';
                if rec_TS(1) > rec_TS(2)
                    disp('Freeze because response time in connection 1 too large.');
                else
                    disp('Freeze because response time in connection 2 too large.');
                end
            end
        else
           
            waitTime = curBufSz - (bufSz - chunkLen);
            pre_play_TS = cur_play_TS;
            cur_play_TS = cur_play_TS + waitTime;
            preTS = TS;
            TS = TS + waitTime;
            curBufSz = curBufSz - waitTime;

            % Writing the log
            % disp(['======= Wait ' num2str(waitTime) '(secs) for the player to consume more bitrates ========= ']);
        end   
    end
    %disp(['playback time increment: ' num2str(cur_play_TS - pre_play_TS) '     Absolute time increment: ' num2str(TS - preTS)]);
    %disp(['buffer size ' num2str(curBufSz) '     last received deadline ' num2str(play_seq(i - 1)*T - cur_play_TS) '     Difference ' num2str(curBufSz - (play_seq(i - 1)*T - cur_play_TS))]);
end

all_dropped_frames = sort(all_dropped_frames, 'ascend');
dropped_impIdx = frame_imp_idx(all_dropped_frames);
dropped_frame_size = frame_size(all_dropped_frames);
dropped_frame_type = frame_typ(all_dropped_frames);
dropEvents = [all_dropped_frames dropped_impIdx dropped_frame_size dropped_frame_type];

% for x = 1 : length(all_dropped_frames)
%     disp(['Dropping frame, ' num2str(all_dropped_frames(x)) ', ' num2str(dropped_impIdx(x)) ...
%         ' , ' num2str(dropped_frame_size(x)) ', ' frm_str_typs{frame_typ(all_dropped_frames(x))}]);
% end     


save(['../rst-mat/' vidName '-exp' num2str(exp_num) '-cloud.mat'], 'bufEvents', 'dropEvents');
dlmwrite(['../data/' vidName '-buf-' num2str(exp_num) '.csv'], bufEvents, 'precision', '%10d');
dlmwrite(['../data/' vidName '-drop-' num2str(exp_num) '.csv'], dropEvents, 'precision', '%10d');

%% Plot buffering events
if ~isempty(bufEvents)
    f2 = figure(2);
    bufPlot = zeros(length(frame_size), 1);
    bufPlot(bufEvents(:, 1) + 1) = bufEvents(:, 2);
    stem((1 : length(bufPlot))./frmRate, bufPlot, 'k-', 'Marker','none');
    xlabel('The time (secs)');
    ylabel('The freezing period (secs)');
    hold on;
    hold off;
    print(f2, '-dpng', '-painters', '-r100', ['../exp/' vidName '-exp' num2str(exp_num) '-buf.png']);
end

%% Plot dropping events
if ~isempty(dropEvents)
    f3 = figure(3);
    hold on;
    dropPlot = zeros(length(frame_size), 1);
    dropPlot(dropEvents(:, 1)) = dropEvents(:, 3);
    plot((1 : length(dropPlot))./frmRate, frame_size, symbols{2});
    stem((1 : length(dropPlot))./frmRate, dropPlot, 'b', 'Marker','square');
    xlabel('The time (secs)');
    ylabel('The frame size of dropped frame');
    hold off;
    print(f3, '-dpng', '-painters', '-r100', ['../exp/' vidName '-exp' num2str(exp_num) '-drop.png']);
end

clear all;
close all;

end