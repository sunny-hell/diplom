devs = [10 10 1e-5 1e-5 1 1 1e-6 1e-6]';
%video_processing('..\sample_videos\movie02.avi', '..\gt\ferrari\movie02.txt', 'results\movie02_400_b8_2.txt', 400, 8, 'ferrari', devs, 'mov2_frames');
%createVideo('movie02_400_b8_2.avi', 'mov2_frames');
%video_processing('..\sample_videos\movie03.avi', '..\gt\ferrari\movie03.txt', 'results\movie03_400_b8_2.txt', 400, 8, 'ferrari', devs, 'mov3_frames');
%createVideo('movie03_400_b8_2.avi', 'mov3_frames');
%video_processing('..\sample_videos\movie04.avi', '..\gt\ferrari\movie04.txt', 'results\movie04_400_b8_2.txt', 400, 8, 'ferrari', devs, 'mov4_frames');
%createVideo('movie04_400_b8_2.avi', 'mov4_frames');
%video_processing('..\sample_videos\movie05.avi', '..\gt\ferrari\movie05.txt', 'results\movie05_400_b8_2.txt', 400, 8, 'ferrari', devs, 'mov5_frames');
%createVideo('movie04_400_b8_2.avi', 'mov5_frames');

%video_processing_estimation('..\sample_videos\Vid_A_ball.avi', '..\gt\bobot\Vid_A_ball_gt.txt', 'results\vidA_ball_800_20_2.txt', 20, 800, 8, 'bobot', devs);
%video_processing_estimation('..\sample_videos\Vid_A_ball.avi', '..\gt\bobot\Vid_A_ball_gt.txt', 'results\vidA_ball_400_20_2.txt', 20, 400, 8, 'bobot', devs);

%video_processing_estimation('..\sample_videos\movie02.avi', '..\gt\ferrari\movie02.txt', 'results\movie02_800_20_2.txt', 20, 800, 8, 'ferrari', devs);
%video_processing_estimation('..\sample_videos\movie02.avi', '..\gt\ferrari\movie02.txt', 'results\movie02_400_20_2.txt', 20, 400, 8, 'ferrari', devs);

%video_processing_estimation('..\sample_videos\movie03.avi', '..\gt\ferrari\movie03.txt', 'results\movie03_800_20_2.txt', 20, 800, 8, 'ferrari', devs);
%video_processing_estimation('..\sample_videos\movie03.avi', '..\gt\ferrari\movie03.txt', 'results\movie03_400_20_2.txt', 20, 400, 8, 'ferrari', devs);

%video_processing_estimation('..\sample_videos\movie04.avi', '..\gt\ferrari\movie04.txt', 'results\movie04_800_20_2.txt', 20, 800, 8, 'ferrari', devs);
%video_processing_estimation('..\sample_videos\movie04.avi', '..\gt\ferrari\movie04.txt', 'results\movie04_400_20_2.txt', 20, 400, 8, 'ferrari', devs);
devs = [5 5 1e-6 1e-6 0.5 0.5 1e-8 1e-8]';
video_processing('..\sample_videos\Vid_A_ball.avi', '..\gt\bobot\Vid_A_ball_gt.txt', 'results\Vid_A_Ball_200_b8_3.txt', 200, 8, 'bobot', devs, 'vidA_frames');
createVideo('Vid_A_Ball_200_b8_3.avi', 'vidA_frames');

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
