%% Decode and Stitch different profiles of chunks into one yuv 
% and compute psnr with the original video
% stitch_profiles.m
% chenw@cmu.edu

function stitch_profiles(videoName, expNum, video_chunk_dir, out_vid_dir, org_video, profiles, ffmpeg, psnr)

% Load 'bufEvents', 'download_profiles', 'download_kbps'.
load(['../rst-mat/' videoName '-exp' num2str(expNum) '-as.mat']);

% The width and height of the yuv file
w = 1920;
h = 1080;
chunk_num = length(download_profiles);
% chunk_num = 100;
frame_sz = w*h*3/2;
chunk_sz = 50;
total_frm_num = chunk_num*chunk_sz;
t = 2;

rec_yuv = [out_vid_dir videoName '-exp' num2str(expNum) '.yuv'];
fp = fopen(rec_yuv, 'w+');

for i = 1 : chunk_num
    input_video = [video_chunk_dir videoName '_' profiles{download_profiles(i)} '.mp4'];
    ss = (i - 1) * 2;  
    out_chunk = [out_vid_dir num2str(i - 1) '.yuv'];
    exec_command = [ffmpeg ' -ss ' num2str(ss) ' -t ' num2str(t) ' -i ' input_video ' ' out_chunk ' > ../decode_log.txt'];
    system(exec_command);
    fid = fopen(out_chunk, 'r');
    for j = 1 : chunk_sz
        frame_bytes = fread(fid, frame_sz, 'uint8');
        fwrite(fp, frame_bytes, 'uint8');
    end
    fclose(fid);
    delete(out_chunk);
    disp(['Chunk profiles: ' num2str(profiles{download_profiles(i)})]);
end
fclose(fp);

psnr_command = [psnr ' ' org_video ' ' rec_yuv ' ' num2str(h) ' ' num2str(w) ' ' num2str(total_frm_num)];
system(psnr_command);

psnr_csv = ['../data/' videoName '-psnr-' num2str(expNum) '.csv'];
psnr_mat = ['../rst-mat/' videoName '-exp' num2str(expNum) '-psnr.mat'];
movefile('./psnr.txt', psnr_csv);
psnr = load(psnr_csv);
save(psnr_mat, 'psnr');

% delete(rec_yuv);
clear all;
end
