%% The emulation of the progressive downloading algorithm
% progressiveDownloading.m
% chenw@cmu.edu

%% Logistics
% clear all;
% close all;
% clc;
function progressiveDownloading(vid_name, exp_num, chunkLen, start_cnt, bw_setting)

global symbols;
global vidName;
global T;

vidName = vid_name;
symbols = {'-k', '--r', '-.b', '-+g', '-+c', '--m', '-og', '-*y', ':k'};

load(['../mat/' vidName '-progressive.mat']);
frame_size = pg(:, 2);
play_seq = pg(:, 1);
bufSz = 10;     % The maximum seconds of frames that can be saved in the buffer.
frmRate = 25;

%% Construct the estimated available bandwidth
total_time = 5*length(frame_size)./frmRate;
dynamic_bw = get_exp_bw(total_time, bw_setting, exp_num);

%% Emulate the streaming according to the available bandwidth
% Get the 5 sec buffer filled as fast profile_idxas possible
bufEvents = [];

%% Variable initialization
state = 'Buffering';
T = 1 ./ frmRate;  % The time period for each frame to be displayed

TS = 0;     % The Time Stamp will be got based on the start playing timestamp
preTS = 0;
cur_play_TS = 0;     % The frame that is played now
pre_play_TS = 0;
i = 1;      % Download Chunk Index
vid_len = length(frame_size);
curBufSz = 0;

chunk_id = 0;

while i < vid_len
    if strcmp(state, 'Buffering')
        download_frm_idx = i : i + start_cnt * frmRate - 1;
        
        % Emulating the downloading period.
        chunk_size = frame_size(download_frm_idx);
        rec_TS = chunk_download(chunk_size, dynamic_bw, TS);
        
        % Write the Log file to record the buffering events
        bufferingTime = rec_TS - TS - curBufSz;
        bufEvents = [bufEvents; i bufferingTime];
        
        % update the status of all parameters
        preTS = TS;        
        TS = rec_TS - curBufSz;    %?????profile_idx
        state = 'Steady';
        curBufSz = start_cnt;
                        
        % Write the log;
        % disp(['======= The player is buffering with period ' num2str(bufferingTime) ' at frame ' num2str(i) '!!!! ======']);
        % fprintf(fp_buf, '%d , %f \n', i, bufferingTime);
        pre_play_TS = cur_play_TS;
        i = i + + start_cnt * frmRate;
    elseif strcmp(state, 'Steady') 
        if (i + chunkLen * frmRate - 1 < vid_len)        
            download_frm_idx = i : i + chunkLen * frmRate - 1;
        else
            download_frm_idx = i : vid_len;
        end
        if (curBufSz > 0) 
            if (curBufSz <= bufSz - chunkLen)
                chunk_size = frame_size(download_frm_idx);
                rec_TS = chunk_download(chunk_size, dynamic_bw, TS);
                chunk_id = chunk_id + 1;

                % Update all the parameters after downloading
                pre_play_TS = cur_play_TS;
                cur_play_TS = cur_play_TS + (rec_TS - TS);
                curBufSz = curBufSz + chunkLen - (rec_TS - TS);
                i = i + length(download_frm_idx);
                preTS = TS;                
                TS = rec_TS;
            else
                waitTime = curBufSz - (bufSz - chunkLen);
                preTS = TS;
                TS = TS + waitTime;
                curBufSz = curBufSz - waitTime;
                
                pre_play_TS = cur_play_TS;
                cur_play_TS = cur_play_TS + waitTime;
                
                % Writing the log
                % disp(['======= Wait ' num2str(waitTime) '(secs) for the player to consume more bitrates ========= ']);
            end   
        else
            state = 'Buffering';
            cur_play_TS = cur_play_TS + curBufSz;
        end
    end
    % disp(['playback time increment: ' num2str(cur_play_TS - pre_play_TS) '     Absolute time increment: ' num2str(TS - preTS)]);
    disp(['buffer size ' num2str(curBufSz) '     last received deadline ' num2str(play_seq(i - 1)*T - cur_play_TS) '     Difference ' num2str(curBufSz - (play_seq(i - 1)*T - cur_play_TS))]);
end

save(['../rst-mat/' vidName '-exp' num2str(exp_num) '-progressive.mat'], 'bufEvents');
dlmwrite(['../data/' vidName '-buf-' num2str(exp_num) '.csv'], bufEvents, 'precision', '%10d');

%% Plot buffering events
if ~isempty(bufEvents)
    f1 = figure(1);
    bufPlot = zeros(length(frame_size), 1);
    bufPlot(bufEvents(:, 1) + 1) = bufEvents(:, 2);
    stem((1 : length(bufPlot))./frmRate, bufPlot, 'k-', 'Marker','none');
    xlabel('The time (secs)');
    ylabel('The freezing period (secs)');
    hold on;
    hold off;
    print(f1, '-dpng', '-painters', '-r100', ['../exp/' vidName '-exp' num2str(exp_num) '-buf.png']);
end

end