%% Get one of the preset experimental environment of the bandwidth
% get_exp_bw.m
% chenw@cmu.edu

function dynamic_bw = get_exp_bw(total_time, setting, exp_num, cn)


Period = 200;
bytesRate = 1024.*1024./8;

switch setting
    case 1
        hi_bw = 5.*bytesRate; lo_bw = 5.*bytesRate;
        delta = 0.5;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num, cn);
    case 2
        hi_bw = 6.*bytesRate; lo_bw = 4.*bytesRate;
        delta = 0.5;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num, cn);
    case 3
        hi_bw = 7.*bytesRate; lo_bw = 3.*bytesRate;
        delta = 0.5;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num, cn);
    case 4
        hi_bw = 10.*bytesRate; lo_bw = 2.*bytesRate;
        delta = 0.99;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num, cn);
    case 5
        hi_bw = 10.*bytesRate; lo_bw = 2.*bytesRate;
        delta = 0.975;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num, cn);
    case 6
        hi_bw = 10.*bytesRate; lo_bw = 5.*bytesRate;
        delta = 0.95;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num, cn);
    case 7
        hi_bw = 10.*bytesRate; lo_bw = 5.*bytesRate;
        delta = 0.9;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num, cn);
    case 8
        hi_bw = 10.*bytesRate; lo_bw = 5.*bytesRate;
        delta = 0.85;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num, cn);
    case 9
        hi_bw = 13.*bytesRate; lo_bw = 5.*bytesRate;
        Period = 10;
        delta = 0.5;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num, cn);
    otherwise
        error('Unknown experimental setting for the bandwidth.');
end

end