%% The emulation of monitoring the bandwidth and the latency
% dynamic_bw : the real dynamical bandwidth
% TS : the time to estimate the bandwidth
% emulate_monitoring.m
% chenw@cmu.edu

function [predict_bw, predict_latency] = emulate_monitoring(dynamic_bw, TS)
     % The statistical features of bandwidth and latency
     bw_var = 1;
     latency_var = 0.05;
     latency_mean = 0.05;
     % bw_var_rand = rand .* bw_var - bw_var./2;
     bw_var_rand = -rand .* bw_var;
     if (TS < 5)
         predict_bw = mean(dynamic_bw(1 : 5)) + bw_var_rand;
     else
         int_ts = floor(TS);
         predict_bw = mean(dynamic_bw(int_ts - 4:int_ts)) + bw_var_rand;
     end
     
     predict_latency = latency_mean + rand .* latency_var - latency_var./2;
end