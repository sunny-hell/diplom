fileID = fopen('results\error_log.txt', 'w');
devs = [15 15 0.1 1 1 1 0.01 0.1]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w1e-1_h1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.1, 1);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.2 0.3 1 1 0.02 0.03]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w2e-1_h3e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.2, 0.3);
    fprintf(fileID, '%s', err.message);
end


devs = [15 15 0.2 0.5 1 1 0.02 0.05]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w2e-1_h5e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.2, 0.5);
    fprintf(fileID, '%s', err.message);
end


devs = [15 15 0.2 0.7 1 1 0.02 0.07]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w2e-1_h7e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.2, 0.7);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.3 0.7 1 1 0.03 0.07]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w3e-2_h7e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.3, 0.7);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.3 0.8 1 1 0.03 0.08]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w3e-2_h8e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.3, 0.8);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.4 0.9 1 1 0.04 0.09]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w4e-1_h9e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.4, 0.9);
    fprintf(fileID, '%s', err.message);
end


devs = [15 15 0.5 0.9 1 1 0.05 0.09]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w5e-1_h9e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.5, 0.9);
    fprintf(fileID, '%s', err.message);
end


devs = [15 15 0.6 0.6 1 1 0.06 0.06]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w6e-1_h6e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.6, 0.6);
    fprintf(fileID, '%s', err.message);
end


devs = [15 15 0.6 1 1 1 0.06 0.1]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w6e-1_h1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.6, 1);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.7 0.3 1 1 0.07 0.03]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w7e-1_h3e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.7, 0.3);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.7 0.4 1 1 0.07 0.04]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w7e-1_h4e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.7, 0.4);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.7 0.6 1 1 0.07 0.06]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w7e-1_h6e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.7, 0.6);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.7 0.9 1 1 0.07 0.09]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w7e-1_h9e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.7, 0.9);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.8 0.2 1 1 0.08 0.02]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w8e-1_h2e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.8, 0.2);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.8 0.5 1 1 0.08 0.05]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w8e-1_h5e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.8, 0.5);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.8 0.6 1 1 0.08 0.06]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w8e-1_h6e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.8, 0.6);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.8 0.7 1 1 0.08 0.07]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w8e-1_h7e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.8, 0.7);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 0.8 0.9 1 1 0.08 0.09]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w8e-1_h9e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.8, 0.9);
    fprintf(fileID, '%s', err.message);
end


devs = [15 15 0.9 0.1 1 1 0.09 0.01]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w9e-1_h1e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 0.9, 0.1);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 1 0.4 1 1 0.1 0.04]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w1_h4e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 1, 0.4);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 1 0.5 1 1 0.1 0.05]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w1_h5e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 1, 0.5);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 1 0.6 1 1 0.1 0.06]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w1_h6e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 1, 0.6);
    fprintf(fileID, '%s', err.message);
end

devs = [15 15 1 0.9 1 1 0.1 0.09]';
try
    video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', '..\gt\ferrari\ref_hist_01.jpg', fullfile('results', 'movie01_400_5_w1_h9e-1.txt'), 5, 400, 8, 'ferrari', devs);
catch err
    fprintf(fileID, '%e %e', 1, 0.9);
    fprintf(fileID, '%s', err.message);
end
fclose('all');
