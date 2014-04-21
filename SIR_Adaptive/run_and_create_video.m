%devs = [5 5 0.2 1e-3 0.1 0.1 1e-4 1e-6]';
%devs = [15 15 0.5 0.5 1 1 0.05 0.05]';
%video_processing('..\sample_videos\movie02.avi', '..\gt\ferrari\movie02.txt', '..\gt\ferrari\ref_hist_02.jpg', 'results\movie02_400_non_adaptive_w5e-1_h5e-1.txt', 400, 8, 'ferrari', devs, 'mov2_frames', -1, false);
%createVideo('movie02_400_b8_2.avi', 'mov2_frames');
%video_processing('..\sample_videos\movie03.avi', '..\gt\ferrari\movie03.txt','..\gt\ferrari\ref_hist_01.jpg',  'results\movie03_adaptive.txt', 400, 8, 'ferrari', devs, 'mov3_frames', 5);
%createVideo('movie03_adaptive_1.avi', 'mov3_frames');
%createVideo('movie03_400_b8_2.avi', 'mov3_frames');
%video_processing('..\sample_videos\movie04.avi', '..\gt\ferrari\movie04.txt', 'results\movie04_400_b8_2.txt', 400, 8, 'ferrari', devs, 'mov4_frames');
%createVideo('movie04_400_b8_2.avi', 'mov4_frames');
devs = [15 15 0.5 0.5 1 1 0.05 0.05]';
video_processing('..\sample_videos\movie10.avi', '..\gt\ferrari\movie10.txt', '..\gt\ferrari\ref_hist_01.jpg', 'results\movie10_adaptive_w5e-1_h5e-1.txt', 400, 8, 'ferrari', devs, 'mov10_frames', -1, true, true);
video_processing('..\sample_videos\movie10.avi', '..\gt\ferrari\movie10.txt', '..\gt\ferrari\ref_hist_01.jpg', 'results\movie10_non_adaptive_w5e-1_h5e-1.txt', 400, 8, 'ferrari', devs, 'mov10_frames_na', -1, false, true);
createVideo('movie10_adaptive.avi', 'mov10_frames');
createVideo('movie10_non_adaptive.avi', 'mov10_frames_na');
%video_processing_estimation('..\sample_videos\Vid_A_ball.avi', '..\gt\bobot\Vid_A_ball_gt.txt', 'results\vidA_ball_800_20_2.txt', 20, 800, 8, 'bobot', devs);
%video_processing_estimation('..\sample_videos\Vid_A_ball.avi', '..\gt\bobot\Vid_A_ball_gt.txt', 'results\vidA_ball_400_20_2.txt', 20, 400, 8, 'bobot', devs);

%video_processing_estimation('..\sample_videos\movie02.avi', '..\gt\ferrari\movie02.txt', 'results\movie02_800_20_2.txt', 20, 800, 8, 'ferrari', devs);
%video_processing_estimation('..\sample_videos\movie02.avi', '..\gt\ferrari\movie02.txt', 'results\movie02_400_20_2.txt', 20, 400, 8, 'ferrari', devs);

%video_processing_estimation('..\sample_videos\movie03.avi', '..\gt\ferrari\movie03.txt', 'results\movie03_800_20_2.txt', 20, 800, 8, 'ferrari', devs);
%video_processing_estimation('..\sample_videos\movie03.avi', '..\gt\ferrari\movie03.txt', 'results\movie03_400_20_2.txt', 20, 400, 8, 'ferrari', devs);

%video_processing_estimation('..\sample_videos\movie04.avi', '..\gt\ferrari\movie04.txt', 'results\movie04_800_20_2.txt', 20, 800, 8, 'ferrari', devs);
%video_processing_estimation('..\sample_videos\movie04.avi', '..\gt\ferrari\movie04.txt', 'results\movie04_400_20_2.txt', 20, 400, 8, 'ferrari', devs);
%devs = [5 5 1e-6 1e-6 0.5 0.5 1e-8 1e-8]';
%video_processing('..\sample_videos\Vid_A_ball.avi', '..\gt\bobot\Vid_A_ball_gt.txt', 'results\Vid_A_Ball_200_b8_3.txt', 200, 8, 'bobot', devs, 'vidA_frames');
%createVideo('Vid_A_Ball_200_b8_3.avi', 'vidA_frames');

% video_processing_estimation('..\sample_videos\movie04.avi', '..\gt\ferrari\movie04.txt', 'results\movie04_800_20_na.txt', 20, 800, 8);
% video_processing_estimation('..\sample_videos\movie04.avi', '..\gt\ferrari\movie04.txt', 'results\movie04_400_20_na.txt', 20, 400, 8);
 
% 
%  video_processing_estimation('..\sample_videos\movie03.avi', '..\gt\ferrari\movie03.txt', 'results\movie03_800_20_na.txt', 20, 800, 8);
%  video_processing_estimation('..\sample_videos\movie03.avi', '..\gt\ferrari\movie03.txt', 'results\movie03_400_20_na.txt', 20, 400, 8);
%  
%  video_processing_estimation('..\sample_videos\movie02.avi', '..\gt\ferrari\movie02.txt', 'results\movie02_800_20_na.txt', 20, 800, 8);
%  video_processing_estimation('..\sample_videos\movie02.avi', '..\gt\ferrari\movie02.txt', 'results\movie02_400_20_na.txt', 20, 400, 8);
%  
%  video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', 'results\movie01_800_20_na.txt', 20, 800, 8);
%  video_processing_estimation('..\sample_videos\movie01.avi', '..\gt\ferrari\movie01.txt', 'results\movie01_400_20_na.txt', 20, 400, 8);



% fileID = fopen('error_log.txt', 'w');
% fileRes = fopen('results\devs_estimation.txt', 'w');
% for h = 0.1:0.1:1
%     for w = 0.1:0.1:1
%         try
%             w
%             h
%             
%             devs = [15 15 w h 1 1 w*0.1 h*0.1]';
%             qual = video_processing_estimation('..\sample_videos\movie02.avi', '..\gt\ferrari\movie02.txt', '..\gt\ferrari\ref_hist_02.jpg', fullfile('results', sprintf('movie02_400_adaptive_w%5.1f_h%5.1f.txt', w,h)), 10, 400, 8, 'ferrari', devs);
%             fprintf(fileRes, '%5.3f\t', qual); 
%         catch err
%             fprintf(fileID,'%f %f', w, h);
%             fprintf(fileID, '%s', err.message);
%         end
%     end
%     fprintf(fileRes, '\n');
% end
% fclose('all');

