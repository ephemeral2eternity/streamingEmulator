%% Drop frames from mp4 files and decode it into yuv using ffmpeg.exe.
% Then compute the psnr using the PSNR.exe
% compute_psnr.m
% chenw@cmu.edu
clear all;
close all;
clc;

global videoName;
global expNum;

%% Parameter Setting
videoName = 'big-buck-bunny';
org_mp4 = 'E:\Dropbox\videoDataSet\OFD\big-buck-bunny.mp4';
org_yuv = 'D:\big-buck-bunny.yuv';
out_dir = '../rec_mp4/';
tmp_dir = 'D:\temp\';

%% Experiment Environment.
ffmpeg_exe = 'E:\ffmpeg\ffmpeg.exe';
psnr_exe = 'E:\ffmpeg\PSNR.exe';
w = 1920;
h = 1080;
frame_num = 14900;
frame_rate = 25;

for expNum = 2 : 3
    %% Reconstruct mp4 video tolerating dropped frames
    % out_mp4 = mp4_dropframes(videoName, expNum, org_mp4, out_dir);
    if expNum == 2
        out_mp4 = ['../rec_mp4/big-buck-bunny-exp' num2str(expNum), '.mp4'];
    else
        out_mp4 = mp4_dropframes(videoName, expNum, org_mp4, out_dir);
    end

    %% Decode the out_mp4
    out_yuv = decode_mp4(ffmpeg_exe, out_mp4, tmp_dir, expNum, frame_num./frame_rate);

    %% Compute the psnr
    psnr = get_psnr(psnr_exe, org_yuv, out_yuv, w, h, frame_num);

    %% Delete the giant yuv file
    delete(out_yuv);
end