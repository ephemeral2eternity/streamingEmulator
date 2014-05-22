%% Get one of the preset experimental environment of the bandwidth
% get_exp_bw.m
% chenw@cmu.edu

function dynamic_bw = get_exp_bw(total_time, setting, exp_num)

delta = 0.5;
Period = 10;
bytesRate = 1024.*1024./8;

switch setting
    case 1
        hi_bw = 5.*bytesRate; lo_bw = 5.*bytesRate;
    case 2
        hi_bw = 8.*bytesRate; lo_bw = 2.*bytesRate;
    case 3
        hi_bw = 6.*bytesRate; lo_bw = 5.*bytesRate;
    case 4
        hi_bw = 9.*bytesRate; lo_bw = 9.*bytesRate;
    case 5
        hi_bw = 13.*bytesRate; lo_bw = 5.*bytesRate;
    case 9
        hi_bw = 11.*bytesRate; lo_bw = 9.*bytesRate;
    otherwise
        error('Unknown experimental setting for the bandwidth.');
end
dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num);
end