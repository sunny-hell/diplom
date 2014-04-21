devs = [5 5 1e-5 1e-5 0.5 0.5 1e-6 1e-6]';
fileID = fopen('errorLog.txt', 'w');
try
    video_processing_multitarget(2, '..\sample_videos\Vid_J_person_floor.avi', ...
        cellstr(['..\gt\bobot\Vid_Ja_person_floor_left.txt '; '..\gt\bobot\Vid_Jb_person_floor_right.txt']), ...
        cellstr(['results\vidJ_target1.txt'; 'results\vidJ_target2.txt']),  400, 8, 'bobot', devs, 'vidJ_frames');
    createVideo('vidJ_two_target.avi', 'vidJ_frames');
catch e
    fprintf(fileID, 'multitarget processing: %s\n', e.message);
end
% 
% curF = cd('..\SIR_HSV');
% try
%     video_processing('..\sample_videos\movie02.avi', '..\gt\ferrari\movie02.txt', 'results\movie02_400.txt', 400, 8, 'ferrari', 'movie02_frames');
%     createVideo('movie02_400.avi', 'movie02_frames');
% catch e
%     fprintf(fileID, 'movie02 processing: %s\n', e.message);
% end
% try
%     video_processing('..\sample_videos\movie03.avi', '..\gt\ferrari\movie03.txt', 'results\movie03_400.txt', 400, 8, 'ferrari', 'movie03_frames');
%     createVideo('movie03_400.avi', 'movie03_frames');
% catch e
%     fprintf(fileID, 'movie03 processing: %s\n', e.message);
% end
% try
%     video_processing('..\sample_videos\movie04.avi', '..\gt\ferrari\movie04.txt', 'results\movie04_400.txt', 400, 8, 'ferrari', 'movie04_frames');
%     createVideo('movie04_400.avi', 'movie04_frames');
% catch e
%     fprintf(fileID, 'movie04 processing: %s\n', e.message);
% end
% try
%     video_processing('..\sample_videos\movie05.avi', '..\gt\ferrari\movie02.txt', 'results\movie05_400.txt', 400, 8, 'ferrari', 'movie05_frames');
%     createVideo('movie05_400.avi', 'movie05_frames');
% catch e
%     fprintf(fileID, 'movie05 processing: %s\n', e.message);
% end
% try
%     video_processing('..\sample_videos\movie06.avi', '..\gt\ferrari\movie02.txt', 'results\movie06_400.txt', 400, 8, 'ferrari', 'movie06_frames');
%     createVideo('movie06_400.avi', 'movie06_frames');
% catch e
%     fprintf(fileID, 'movie06 processing: %s\n', e.message);
% end
% cd(curF);
fclose('all');
