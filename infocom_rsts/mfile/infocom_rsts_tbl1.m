%% Draw graphs and count statistics for infocom paper
% July 28, 2013
% infocom_rsts.m

clear all;
close all;
clc;

mat_dir = '../mat/';
symbols = {'-k', '--r', '-.b', '-+g', '-+c', '--m', '-og', '-*y', ':k'};


%% Load the PSNR and save the MOS for all ABS experiments.
exp_name = 'CLOUD-DAFS';
psnr = load([mat_dir exp_name '-PSNR.mat']);
psnr = psnr.psnr; psnr(psnr == 1) = 1000;

mos = zeros(size(psnr));
mos(psnr == 1000) = 6;
mos((psnr > 37) & (psnr < 500)) = 5;
mos((psnr > 31) & (psnr <= 37)) = 4;
mos((psnr > 25) & (psnr <= 31)) = 3;
mos((psnr > 20) & (psnr <= 25)) = 2;
mos(psnr <= 20) = 1;

f = figure(1); plot(mos);
print(f, '-dpng', '-painters', '-r100', ['../img/' exp_name '-MOS.png']);

save([mat_dir exp_name '-MOS.mat'], 'mos');
dlmwrite(['../data/' exp_name '-MOS.csv'], mos, 'precision', '%d');

% %% Draw PSNR Comparison
% psnr_abs = load('../mat/ABS-T100.mat'); psnr_abs = psnr_abs.psnr; psnr_abs(psnr_abs == 1) = 1000;
% psnr_dafd = load('../mat/DAFD1-T100.mat'); psnr_dafd = psnr_dafd.psnr; psnr_dafd(psnr_dafd == 1) = 1000;
% R = 25;
% 
% frms_range = 8125 : 12500;
% drop_range = (8750 : 11250) - 8125 + 1;
% bw = ones(size(frms_range)) .* 10;
% bw(drop_range) = 9;
% time_range = frms_range ./ R;
% figure(2); hold on;
% plot(time_range, psnr_abs(frms_range), symbols{1}, 'linewidth', 2);
% plot(time_range, psnr_dafd(frms_range), symbols{2}, 'linewidth', 2);
% LG = legend('Adaptive Bitrate Streaming', 'DAFD (Condition 1)');
% LEG_TXT = findobj(LG,'type','text');
% set(LEG_TXT,'FontSize',12)
% xlabel('Time (seconds)', 'FontSize',12);
% ylabel('PSNR (db)', 'FontSize',12);
% axis([min(time_range) max(time_range) 0 100]);
% hold off;

%% Count the average MOS Comparison
% ABS-T100
% mos_abs = load('../mat/ABS-T100-MOS.mat'); mos_abs = mos_abs.mos;
% R = 25;
% 
% period = 100*25;
% seg1 = 1250 : 5000;
% seg2 = 5001 : 8500;
% seg3 = 8501 : 12500;
% 
% % Segment 1
% mos_seg1 = mos_abs(seg1); down_period1 = sum(mos_seg1 < 6) ./ period;
% idx = find(mos_seg1 < 6);
% period_start = idx(1);
% period_end = idx(end);
% seg1_mean_mos = mean(mos_seg1(period_start:period_end));
% 
% % Segment 2
% mos_seg2 = mos_abs(seg2); down_period2 = sum(mos_seg2 < 6) ./ period;
% idx = find(mos_seg2 < 6);
% period_start = idx(1);
% period_end = idx(end);
% seg2_mean_mos = mean(mos_seg2(period_start:period_end));
% 
% % Segment 3
% mos_seg3 = mos_abs(seg3); down_period3 = sum(mos_seg3 < 6) ./ period;
% idx = find(mos_seg3 < 6);
% period_start = idx(1);
% period_end = idx(end);
% seg3_mean_mos = mean(mos_seg3(period_start:period_end));


% %% Count the average MOS Comparison
% % ABS-T50
% mos_abs = load('../mat/ABS-T10-MOS.mat'); mos_abs = mos_abs.mos;
% R = 25;
% 
% period = 10*25;
% seg1 = 1250 : 3750;
% seg2 = 3750 : 6250;
% seg3 = 8750 : 11250;
% 
% % Segment 1
% mos_seg1 = mos_abs(seg1); down_period1 = sum(mos_seg1 < 6) ./ period;
% idx = find(mos_seg1 < 6);
% period_start = idx(1);
% period_end = idx(end);
% seg1_mean_mos = mean(mos_seg1(period_start:period_end));
% 
% % Segment 2
% mos_seg2 = mos_abs(seg2); down_period2 = sum(mos_seg2 < 6) ./ period;
% idx = find(mos_seg2 < 6);
% period_start = idx(1);
% period_end = idx(end);
% seg2_mean_mos = mean(mos_seg2(period_start:period_end));
% 
% % Segment 3
% mos_seg3 = mos_abs(seg3); down_period3 = sum(mos_seg3 < 6) ./ period;
% idx = find(mos_seg3 < 6);
% period_start = idx(1);
% period_end = idx(end);
% seg3_mean_mos = mean(mos_seg3(period_start:period_end));


% %% Count the average MOS Comparison
% % DAFD1-T100
% mos_dafd = load('../mat/DAFD1-T10-MOS.mat'); mos_dafd = mos_dafd.mos;
% R = 25;
% 
% % period = 100*25;
% % seg1 = 1250 : 3750;
% % seg2 = 5000 : 7500;
% % seg3 = 8750 : 11250;
% 
% period = 10*25;
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
% 
% 

