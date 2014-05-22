%% Call the ffmpeg.exe to decode the rec_mp4 to rec_yuv
% decode_mp4.m
% chenw@cmu.edu


function out_yuv = decode_mp4(ffmpeg_exe, out_mp4, tmp_dir, expNum, period)
    out_yuv = [tmp_dir 'cloud-rec-' num2str(expNum) '.yuv'];
    decode_cmd = [ffmpeg_exe ' -ss 0 -t ' num2str(period) ' -i ' out_mp4 ' ' out_yuv];
    system(decode_cmd);
end