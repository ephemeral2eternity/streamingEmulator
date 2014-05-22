%% Read mp4 files and drop frames 
% Then compute the psnr using the PSNR.exe
% mp4_dropframes.m
% chenw@cmu.edu


function out_mp4 = mp4_dropframes(videoName, expNum, org_mp4, out_dir)
    % Load needed data
    expData = ['../rst-mat/' videoName '-exp' num2str(expNum) '-cloud.mat'];
    load(expData);
    ofd_manifest = ['../mat/' videoName '-cs.mat'];
    load(ofd_manifest);
    
    % Create the file identifier to write output video
    out_mp4 = [out_dir videoName '-exp' num2str(expNum) '.mp4'];
    fout = fopen(out_mp4, 'w+');
    
    % Get the frame size of each frame.
    fp = fopen(org_mp4, 'r');
    frame_sz = cs(:, 2);
    frame_num = length(frame_sz);
    
    % Update the dropping vectors.
    if exist('dropEvents', 'var')
    % Decide whether variable dropEvents exist 
        dropFrames = dropEvents(:, 1);
        is_drop = zeros(frame_num, 1);
        is_drop(dropFrames) = 1;

        for i = 1 : frame_num
            frame_bytes = fread(fp, frame_sz(i), 'uint8');
            if is_drop(i) == 1
                frame_bytes = zeros(size(frame_bytes));
            end
            fwrite(fout, frame_bytes, 'uint8');
        end

        fclose(fp);
        fclose(fout);
    else
        % If dropEvents do not exist
        copyfile(org_mp4, org_mp4, 'f');
    end
end