%% Test the adaptive smooth streaming algorithm
% testAS.m
% chenw@cmu.edu
clear all;
close all;
clc;

% vid_name = 'brave';
% profile_kbps = [5600; 2800; 1900; 950; 470; 230];
% 
% %% Testing methods on constant bandwidth with chunk 2 start cnt 5
% expNum = 1; chunkLen = 2; start_cnt = 5; bw_setting = 1;
% adaptiveStreaming(vid_name, expNum, chunkLen, start_cnt, bw_setting, profile_kbps);

vid_name = 'big-buck-bunny';
profile_kbps = [9700; 4840; 2415; 1205; 601; 300];

%% Testing methods on constant bandwidth with chunk 2 start cnt 5 with constant bw
expNum = 1; chunkLen = 2; start_cnt = 5; bw_setting = 4;
adaptiveStreaming(vid_name, expNum, chunkLen, start_cnt, bw_setting, profile_kbps);

%% Testing methods on constant bandwidth with chunk 2 start cnt 5 with large oscillating bw
expNum = 2; chunkLen = 2; start_cnt = 5; bw_setting = 5;
adaptiveStreaming(vid_name, expNum, chunkLen, start_cnt, bw_setting, profile_kbps);

%% Testing methods on constant bandwidth with chunk 2 start cnt 5 with small oscillating bw
expNum = 3; chunkLen = 2; start_cnt = 5; bw_setting = 6;
adaptiveStreaming(vid_name, expNum, chunkLen, start_cnt, bw_setting, profile_kbps);

%% Testing methods on constant bandwidth with chunk 2 start cnt 5 with constant bw
expNum = 4; chunkLen = 2; start_cnt = 5; bw_setting = 7;
adaptiveStreaming(vid_name, expNum, chunkLen, start_cnt, bw_setting, profile_kbps);



% %% Testing methods on constant bandwidth with chunk 2 start cnt 5 with small oscillating bw
% expNum = 6; chunkLen = 2; start_cnt = 5; bw_setting = 9;
% adaptiveStreaming(vid_name, expNum, chunkLen, start_cnt, bw_setting, profile_kbps);

% %% Testing methods on constant bandwidth with chunk 2 start cnt 5 with constant bw
% expNum = 101; chunkLen = 2; start_cnt = 5; bw_setting = 4;
% deadlineAS(vid_name, expNum, chunkLen, start_cnt, bw_setting, profile_kbps);
% 
% %% Testing methods on constant bandwidth with chunk 2 start cnt 5 with large oscillating bw
% expNum = 102; chunkLen = 2; start_cnt = 5; bw_setting = 5;
% deadlineAS(vid_name, expNum, chunkLen, start_cnt, bw_setting, profile_kbps);
% 
% %% Testing methods on constant bandwidth with chunk 2 start cnt 5 with small oscillating bw
% expNum = 103; chunkLen = 2; start_cnt = 5; bw_setting = 6;
% deadlineAS(vid_name, expNum, chunkLen, start_cnt, bw_setting, profile_kbps);