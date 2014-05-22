%% Compute psnr for any number of experiments
% and compute psnr with the original video
% compute_psnr.m
% chenw@cmu.edu

clear all;
close all;
clc;

%% Parameter Setting
videoName = 'big-buck-bunny';
video_chunk_dir = 'D:\chenw\big_buck_bunny\adaptiveStreaming\';
out_vid_dir = 'D:\AS_YUV\';
org_video = 'D:\big-buck-bunny.yuv';
profiles = {'9700', '4840', '2415', '1205', '601', '300'};
ffmpeg = 'E:\ffmpeg\ffmpeg.exe';
psnr = 'E:\ffmpeg\PSNR.exe';

% Start computing the psnr for each experiment
expNum = 1;
stitch_profiles(videoName, expNum, video_chunk_dir, out_vid_dir, org_video, profiles, ffmpeg, psnr);

expNum = 2;
stitch_profiles(videoName, expNum, video_chunk_dir, out_vid_dir, org_video, profiles, ffmpeg, psnr);

expNum = 3;
stitch_profiles(videoName, expNum, video_chunk_dir, out_vid_dir, org_video, profiles, ffmpeg, psnr);

%% For deadline aware profile selection scheme
expNum = 4;
stitch_profiles(videoName, expNum, video_chunk_dir, out_vid_dir, org_video, profiles, ffmpeg, psnr);

% expNum = 5;
% stitch_profiles(videoName, expNum, video_chunk_dir, out_vid_dir, org_video, profiles, ffmpeg, psnr);

% expNum = 6;
% stitch_profiles(videoName, expNum, video_chunk_dir, out_vid_dir, org_video, profiles, ffmpeg, psnr);