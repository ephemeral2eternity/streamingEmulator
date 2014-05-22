%% Call the ffmpeg.exe to decode the rec_mp4 to rec_yuv
% get_psnr.m
% chenw@cmu.edu

function psnr = get_psnr(psnr_exe, org_yuv, out_yuv, w, h, frame_num)
    global videoName;
    global expNum;

    psnr_cmd = [psnr_exe ' ' org_yuv ' ' out_yuv ' ' num2str(h) ' ' num2str(w) ' ' num2str(frame_num)];
    system(psnr_cmd);
    
    psnr_csv = ['../data/' videoName '-psnr-' num2str(expNum) '.csv'];
    psnr_mat = ['../rst-mat/' videoName '-exp' num2str(expNum) '-psnr.mat'];
    
    movefile('./psnr.txt', psnr_csv);
    psnr = load(psnr_csv);
    save(psnr_mat, 'psnr');
end
