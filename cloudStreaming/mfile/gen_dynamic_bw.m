%% The function to generate dynamic changing bandwidth
% T : the period of the changing (has to be an integer)
% delta : the ratio of the duration of high bandwidth over one period
% hi_bw : the value of the high bandwidth
% lo_bw : the value of the low bandwidth
% get_dynamic_bw.m
% chenw@cmu.edu


function dynamic_bw = gen_dynamic_bw(T, delta, hi_bw, lo_bw, total_time, exp_num)

    global symbols;
    global vidName;
    dynamic_bw = zeros(ceil(total_time), 1);
    time_idx = 0 : total_time - 1;
    high_T = floor(delta * T);
    highIdx = (mod(time_idx, T) < high_T);
    lowIdx = ~highIdx;
    dynamic_bw(lowIdx) = lo_bw;
    dynamic_bw(highIdx) = hi_bw;
    f = figure(1);
    plot(time_idx(1 : 2*T), dynamic_bw(1 : 2*T).*8./(1024*1024), symbols{1});
    xlabel('The time (secs)');
    ylabel('The available bandwidth (Mbps)');
    axis([0 2*T - 1 lo_bw*0.8.*8./(1024*1024) hi_bw*1.2.*8./(1024*1024)]);
    print(f, '-dpng', '-painters', '-r100', ['../exp/' vidName '-exp-' num2str(exp_num) '-bw.png']);
end