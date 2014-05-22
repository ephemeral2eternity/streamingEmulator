%% Draw graphs and count statistics for infocom paper
% July 28, 2013
% infocom_rsts_tbl2.m

clear all;
close all;
clc;

mat_dir = '../mat/';
symbols = {'-k', '--r', '-.b', '-+g', '-+c', '--m', '-og', '-*y', ':k'};


%% Load the PSNR and save the MOS for all ABS experiments.
exp_name = 'PG';
ofd = load([mat_dir exp_name '-BUF.mat']); 
buf = ofd.bufEvents;
buf_ind = buf(:, 1);


% %% Count the average MOS Comparison
% % DAFD1-T100
% mos_dafd = load('../mat/DAFD4-T50-MOS.mat'); mos_dafd = mos_dafd.mos;
% R = 25;
% 
% % period = 100*25;
% % seg1 = 1250 : 3750;
% % seg2 = 5000 : 7500;
% % seg3 = 8750 : 11250;
% 
% period = 50*25;
% seg1 = 1 : 2500;
% seg2 = 2501 : 5000;
% seg3 = 5001 : 7500;
% seg4 = 7501 : 10000;
% 
% % period = 20*25;
% % seg1 = 2000 : 2500;
% % seg2 = 4500 : 5000;
% % seg3 = 7000 : 7500;
% 
% % Segment 1
% mos_seg1 = mos_dafd(seg1); down_period1 = sum(mos_seg1 < 6) ./ period;
% seg1_mean_mos = mean(mos_dafd(seg1));
% 
% % Segment 2
% mos_seg2 = mos_dafd(seg2); down_period2 = sum(mos_seg2 < 6) ./ period;
% seg2_mean_mos = mean(mos_dafd(seg2));
% 
% % Segment 3
% mos_seg3 = mos_dafd(seg3); down_period3 = sum(mos_seg3 < 6) ./ period;
% seg3_mean_mos = mean(mos_dafd(seg3));
% 
% % Segment 4
% mos_seg4 = mos_dafd(seg4); down_period4 = sum(mos_seg4 < 6) ./ period;
% seg4_mean_mos = mean(mos_dafd(seg4));
% 
% % ave_mos = (seg1_mean_mos + seg2_mean_mos + seg3_mean_mos)/3
% % ave_down_period = (down_period1+down_period2+down_period3)/3
% 
% ave_mos = (seg1_mean_mos + seg2_mean_mos + seg3_mean_mos + seg4_mean_mos)/4
% ave_down_period = (down_period1+down_period2+down_period3 + down_period4)/4

% %% Count the MOS Comparison for multiple connections
% % DAFD1-T100
% mod_cloud = load('../mat/CLOUD-RR-DAFD-MOS.mat'); mod_cloud = mod_cloud.mos;
% R = 25;
% 
% period = length(mod_cloud);
% 
% % Segment 1
% down_period = sum(mod_cloud < 6) ./ period
% mean_mos = mean(mod_cloud)

%% MOS Hist Comparison
mos_dafs = load('../mat/CLOUD-DAFS-MOS.mat'); mos_dafs = mos_dafs.mos;
mos_rr = load('../mat/CLOUD-RR-DAFD-MOS.mat'); mos_rr = mos_rr.mos;

hist_mos_dafs = hist(mos_dafs, 6);
hist_mos_rr = hist(mos_rr, 6);



