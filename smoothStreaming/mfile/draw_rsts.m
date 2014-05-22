%% Draw results for the smooth streaming vs. deadline aware bitrate selection
% draw_rsts.m
% chenw@cmu.edu

clc;
close all;
clear all;

symbols = {'-k', '--r', '-.b', '-+g', '-+c', '--m', '-og', '-*y', ':k'};

%% Draw the PSNR
videoName = 'big_buck_bunny';
as_psnr_1_name = ['../rst-mat/' videoName '-exp1-psnr.mat'];
as_psnr_1 = load(as_psnr_1_name); as_psnr_1 = as_psnr_1.psnr;
as_psnr_2_name = ['../rst-mat/' videoName '-exp2-psnr.mat'];
as_psnr_2 = load(as_psnr_2_name);as_psnr_2 = as_psnr_2.psnr;

as_psnr_1(as_psnr_1 == 1) = 100;
as_psnr_2(as_psnr_2 == 1) = 100;

deadlineAS_1_psnr_name = ['../rst-mat/' videoName '-exp101-psnr.mat'];
deadlineAS_1_psnr = load(deadlineAS_1_psnr_name);
deadlineAS_1_psnr = deadlineAS_1_psnr.psnr;
deadlineAS_1_psnr(deadlineAS_1_psnr == 1) = 100;

deadlineAS_2_psnr_name = ['../rst-mat/' videoName '-exp102-psnr.mat'];
deadlineAS_2_psnr = load(deadlineAS_2_psnr_name);
deadlineAS_2_psnr = deadlineAS_2_psnr.psnr;
deadlineAS_2_psnr(deadlineAS_2_psnr == 1) = 100;

R = 25;
t = (1 : length(as_psnr_1))./R;

f1 = figure(1); hold on;
plot(t, as_psnr_1, symbols{1}, 'LineWidth',2);
plot(t, deadlineAS_1_psnr, symbols{2}, 'LineWidth',2);
plot(t, as_psnr_2, symbols{3}, 'LineWidth',2);
plot(t, deadlineAS_2_psnr, symbols{4}, 'LineWidth',2);
xlabel('The time (secs)', 'fontsize', 12);
ylabel({'The Per Frame PSNR (db)', '100 db denotes the INF'}, 'fontsize', 12);
title('PSNR Comparison', 'fontsize', 12);
LG = legend('Adaptive Bitrate Streaming (BW1)', 'Deadline-Aware Bitrate Selection(BW1)', 'Adaptive Bitrate Streaming (BW2)', 'Deadline-Aware Bitrate Selection(BW2)', 'Location', 'SouthEast');
LEG_TXT = findobj(LG,'type','text');
set(LEG_TXT,'FontSize',12)
axis([0, length(as_psnr_1)./R, 0, 105]);
hold off;
print(f1, '-dpng', '-painters', '-r100', ['../exp/' videoName '-psnr.png']);

%% Draw the selected bitrates for each chunk
as_1 = load(['../rst-mat/' videoName '-exp1-as.mat']);
as_2 = load(['../rst-mat/' videoName '-exp2-as.mat']);
deadlineAS_1 = load(['../rst-mat/' videoName '-exp101-as.mat']);
deadlineAS_2 = load(['../rst-mat/' videoName '-exp102-as.mat']);
chunk_num = 100;

f2 = figure(2); hold on;
plot(as_1.download_kbps(1 : chunk_num), symbols{1}, 'LineWidth',2);
plot(deadlineAS_1.download_kbps(1:chunk_num), symbols{2}, 'LineWidth',2);
plot(as_2.download_kbps(1 : chunk_num), symbols{3}, 'LineWidth',2);
plot(deadlineAS_2.download_kbps(1:chunk_num), symbols{4}, 'LineWidth',2);
xlabel('The video chunk id', 'fontsize', 12);
ylabel('The bitrate of the chunk (kpbs)', 'fontsize', 12);
title('Selected Bitrates in the case of Constant Insufficient Bandwidth', 'fontsize', 12);
LG = legend('Adaptive Bitrate Streaming (BW1)', 'Deadline-Aware Bitrate Selection (BW1)', 'Adaptive Bitrate Streaming (BW2)', 'Deadline-Aware Bitrate Selection (BW2)',  'Location', 'SouthEast');
LEG_TXT = findobj(LG,'type','text');
set(LEG_TXT,'FontSize',12)
axis([0, chunk_num, 0, 10000]);
hold off;
print(f2, '-dpng', '-painters', '-r100', ['../exp/' videoName '-bitrates.png']);

%% Count the statistics of freezing
% 0 for all
