%% Test the progressive downloading scheme
% testProgressiveDownloading.m
% chenw@cmu.edu
clear all;
close all;
clc;

vid_name = 'big-buck-bunny';

% Testing methods on constant bandwidth with chunk 2 start cnt 5 with constant bw
expNum = 1; chunkLen = 2; start_cnt = 5; bw_setting = 9;
progressiveDownloading(vid_name, expNum, chunkLen, start_cnt, bw_setting);

% % Testing methods on constant bandwidth with chunk 2 start cnt 5 with constant bw
% expNum = 2; chunkLen = 2; start_cnt = 5; bw_setting = 5;
% progressiveDownloading(vid_name, expNum, chunkLen, start_cnt, bw_setting);