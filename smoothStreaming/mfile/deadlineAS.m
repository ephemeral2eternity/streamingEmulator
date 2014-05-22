%% The emulation of the adaptive smooth streaming algorithm
% adaptiveStreaming.m
% chenw@cmu.edu

%% Logistics
% clear all;
% close all;
% clc;
function deadlineAS(vid_name, exp_num, chunkLen, start_cnt, bw_setting, profile_kbps)

global symbols;
global vidName;
global T;
global exp_num;

vidName = vid_name;
symbols = {'-k', '--r', '-.b', '-+g', '-+c', '--m', '-og', '-*y', ':k'};

%% Compute the propagation factor.
% Load the video frame info.
load(['../mat/' vidName '-as.mat']);
profile_num = length(profile_kbps);
decode_seq = as_manifest(:, 1);
play_seq = as_manifest(:, 2);        
frm_profiles = as_manifest(:, 3 : end);        
bufSz = 20;     % The maximum seconds of frames that can be saved in the buffer.
frmRate = 25;
profile_byterates = profile_kbps .* 1024 ./ 8;
% profile_kbps = [5600; 2800; 1900; 950; 470; 230];
% profile_bitrates = [9700; 4840; 2415; 1205; 601; 300];

%% Construct the estimated available bandwidth
total_time = 5*length(decode_seq)./frmRate;
dynamic_bw = get_exp_bw(total_time, bw_setting);

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
vid_len = size(as_manifest, 1);
curBufSz = 0;

profile_idx = profile_num;

theta_1 = chunkLen; % The threshold to enter "PANIC" mode.                
%theta_2 = bufSz ./ 2; % The threshold of buffer accupancy that is considered low and decreasing bitrate by one profile at each chunk.
download_profiles = [];
download_kbps = [];
while i < vid_len
    if strcmp(state, 'Buffering')
        download_frm_idx = i : i + start_cnt * frmRate - 1;
        
        % Emulating the downloading period.
        chunk_size = frm_profiles(download_frm_idx, profile_idx);
        rec_TS = chunk_download(chunk_size, dynamic_bw, TS);
        
        for s = 1 : start_cnt
            download_profiles = [download_profiles; profile_idx];
            download_kbps = [download_kbps; profile_kbps(profile_idx)];
        end
        
        % Estimate the available bandwidth for last request.
        [predict_bw, predict_latency] = emulate_monitoring(dynamic_bw, rec_TS);
        bufferingTime = rec_TS - TS - curBufSz;
        bufEvents = [bufEvents; i bufferingTime];
        
        % update the status of all parameters
        preTS = TS;        
        TS = rec_TS - curBufSz;    %?????profile_idx
        state = 'Steady';
        curBufSz = start_cnt;
                        
        % Write the log;
        disp(['======= The player is buffering with period ' num2str(bufferingTime) ' at frame ' num2str(i) '!!!! ======']);
        % fprintf(fp_buf, '%d , %f \n', i, bufferingTime);
        pre_play_TS = cur_play_TS;
        i = i + start_cnt * frmRate;
    elseif strcmp(state, 'Steady') 
        if (i + chunkLen * frmRate - 1 < vid_len)        
            download_frm_idx = i : i + chunkLen * frmRate - 1;
        else
            download_frm_idx = i : vid_len;
        end
        if (curBufSz > 0)
            if (curBufSz <= theta_1)
                % Enter "PANIC" mode, to download a chunk as fast as
                % possible with the lowest profile.method_ind10
                profile_idx = profile_num;
                
                chunk_size = frm_profiles(download_frm_idx, profile_idx);
                rec_TS = chunk_download(chunk_size, dynamic_bw, TS);
                download_profiles = [download_profiles; profile_idx];
                download_kbps = [download_kbps; profile_kbps(profile_idx)];
                
                % Writing the log
                disp(['======= downloading chunk from frame ' num2str(i) ' with the bitrate ' num2str(profile_kbps(profile_idx))]);

                % Estimate the available bandwidth for last request.
                [predict_bw, predict_latency] = emulate_monitoring(dynamic_bw, rec_TS);
                
                % Update all the parameters after downloading
                pre_play_TS = cur_play_TS;
                cur_play_TS = cur_play_TS + (rec_TS - TS);
                curBufSz = curBufSz + chunkLen - (rec_TS - TS);
                i = i + length(download_frm_idx);
                preTS = TS;                
                TS = rec_TS;
            elseif (curBufSz <= bufSz - chunkLen)
                % Compute the profile_idx through computing the deadlines.
                
                chunk_all_profiles = frm_profiles(download_frm_idx, :);
                chunk_play_seq = play_seq(download_frm_idx);
                
                % Compute the maximum chunk profile that satisfy all
                % deadlines.
                profile_idx = compute_profile_idx(chunk_all_profiles, chunk_play_seq, cur_play_TS, predict_bw, predict_latency);
                
                chunk_size = chunk_all_profiles(:, profile_idx);
                rec_TS = chunk_download(chunk_size, dynamic_bw, TS);
                download_profiles = [download_profiles; profile_idx];
                download_kbps = [download_kbps; profile_kbps(profile_idx)];
                
                % Writing the log
                disp(['======= downloading chunk from frame ' num2str(i) ' with the bitrate ' num2str(profile_kbps(profile_idx))]);

                % Estimate the available bandwidth for last request.
                [predict_bw, predict_latency] = emulate_monitoring(dynamic_bw, rec_TS);
                
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
                
                % Writing the log
                disp(['======= Wait ' num2str(waitTime) '(secs) for the player to consume more bitrates ========= ']);
            end   
        else
            state = 'Buffering';
            profile_idx = profile_num;
            cur_play_TS = cur_play_TS + curBufSz;
        end
    end
    % disp(['playback time increment: ' num2str(cur_play_TS - pre_play_TS) '     Absolute time increment: ' num2str(TS - preTS)]);
    disp(['buffer size ' num2str(curBufSz) '     last received deadline ' num2str(play_seq(i - 1)*T - cur_play_TS) '     Difference ' num2str(curBufSz - (play_seq(i - 1)*T - cur_play_TS))]);
end

save(['../rst-mat/' vidName '-exp' num2str(exp_num) '-as.mat'], 'bufEvents', 'download_profiles', 'download_kbps');
dlmwrite(['../data/' vidName '-buf-' num2str(exp_num) '.csv'], bufEvents, 'precision', '%10d');
dlmwrite(['../data/' vidName '-download_profiles-' num2str(exp_num) '.csv'], download_profiles, 'precision', '%d');

%% Plot buffering events
if ~isempty(bufEvents)
    f1 = figure(1);
    bufPlot = zeros(length(decode_seq), 1);
    bufPlot(bufEvents(:, 1) + 1) = bufEvents(:, 2);
    stem((1 : length(bufPlot))./frmRate, bufPlot, 'k-', 'Marker','none');
    xlabel('The time (secs)');
    ylabel('The freezing period (secs)');
    hold on;
    hold off;
    print(f1, '-dpng', '-painters', '-r100', ['../exp/' vidName '-exp' num2str(exp_num) '-buf.png']);
end

%% Plot Profiles and Bitrates for each frame
f2 = figure(2);
hold on;
plot((1 : length(download_profiles)).*chunkLen, download_profiles, symbols{2});
xlabel('The time (secs)');
ylabel('The profiles chosen to download in smooth streaming');
axis([0 ceil(length(download_profiles).*chunkLen) 0 length(profile_kbps) + 1]);
hold off;
print(f2, '-dpng', '-painters', '-r100', ['../exp/' vidName '-exp' num2str(exp_num) '-profiles.png']);

%% Plot Profiles and Bitrates for each frame
f3 = figure(3);
hold on;
plot((1 : length(download_kbps)).*chunkLen, download_kbps, symbols{2});
xlabel('The time (secs)');
ylabel('The kbps chosen to download in smooth streaming');
axis([0 ceil(length(download_kbps).*chunkLen) 0 profile_kbps(1) + 300]);
hold off;
print(f3, '-dpng', '-painters', '-r100', ['../exp/' vidName '-exp' num2str(exp_num) '-kbps.png']);

clear all;
close all;
end