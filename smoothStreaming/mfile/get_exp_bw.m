%% Get one of the preset experimental environment of the bandwidth
% get_exp_bw.m
% chenw@cmu.edu

function dynamic_bw = get_exp_bw(total_time, setting, exp_num)


Period = 100;
bytesRate = 1024.*1024./8;

switch setting
    case 1
        hi_bw = 5.*bytesRate; lo_bw = 5.*bytesRate;
        delta = 0.5;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num);
    case 2
        hi_bw = 6.*bytesRate; lo_bw = 4.*bytesRate;
        delta = 0.5;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num);
    case 3
        hi_bw = 5.*bytesRate; lo_bw = 4.*bytesRate;
        delta = 0.8;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num);
    case 4
        % The insufficient bandwidth lasts about 100 seconds.
        hi_bw = 10.*bytesRate; lo_bw = 9.*bytesRate;
        delta = 1/3;
        Period = 150;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num);
    case 5
        % The insufficient bandwidth lasts about 50 seconds.
        hi_bw = 10.*bytesRate; lo_bw = 9.*bytesRate;
        delta = 1/2;
        Period = 100;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num);
    case 6
        % The insufficient bandwidth lasts about 20 seconds.
        hi_bw = 10.*bytesRate; lo_bw = 9.*bytesRate;
        delta = 4/5;
        Period = 100;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num);
    case 7
        % The insufficient bandwidth lasts about 10 seconds.
        hi_bw = 10.*bytesRate; lo_bw = 9.*bytesRate;
        delta = 9/10;
        Period = 100;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num);
    case 9
        % The available bandwidth oscillates with 10 second period
        hi_bw = 11.*bytesRate; lo_bw = 9.*bytesRate;
        Period = 10;
        delta = 0.5;
        dynamic_bw = gen_dynamic_bw(Period, delta, hi_bw, lo_bw, total_time, exp_num);
    otherwise
        error('Unknown experimental setting for the bandwidth.');
end

end