%% This scrift tests the idea of Importance Index and Deadline Awared 
% Video Streaming on Cloud or P2P
% We assume that all the sources have the content and one user set up
% multiple connections to download the content, so the viewer needs to
% determine what content to ask from which server.
% testCloudStreaming.m
% chenw@cmu.edu

clc;
close all;
clear all;


vidName = 'big-buck-bunny';
conn_num = 2;

%% Testing methods on constant bandwidth with chunk 2 start cnt 5
expNum = 1; chunkLen = 2; start_cnt = 5; method_ind = 1; bw_setting = [1 2]; drop_idx = 0;
cloudStreaming(vidName, expNum, chunkLen, start_cnt, method_ind, bw_setting, drop_idx);

%% Testing methods on constant bandwidth with chunk 2 start cnt 5
expNum = 2; chunkLen = 2; start_cnt = 5; method_ind = 2; bw_setting = [1 2]; drop_idx = 1;
cloudStreaming(vidName, expNum, chunkLen, start_cnt, method_ind, bw_setting, drop_idx);

%% Testing methods on constant bandwidth with chunk 2 start cnt 5
expNum = 3; chunkLen = 2; start_cnt = 5; method_ind = 1; bw_setting = [1 2]; drop_idx = 1;
cloudStreaming(vidName, expNum, chunkLen, start_cnt, method_ind, bw_setting, drop_idx);