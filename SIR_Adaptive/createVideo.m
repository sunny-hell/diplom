function createVideo(res_name, fld)
    % Find all the JPEG file names in the specified folder. Convert the set of image names to a cell array.
    imageNames = dir(fullfile('results', fld, '*.jpg'));
    % Convert the set of image names to a cell array.
    imageNames = {imageNames.name}';
    
    % match any file names that contain a sequence of numeric digits. Convert the strings to doubles.
    imageStrings = regexp([imageNames{:}],'(\d*)','match');
    imageNumbers = str2double(imageStrings);
    
    % Sort the frame numbers from lowest to highest. 
    % The sort function returns an index matrix that indicates how to order the associated files.
    [~,sortedIndices] = sort(imageNumbers);
    sortedImageNames = imageNames(sortedIndices);
    
    % Construct a VideoWriter object, which creates a Motion-JPEG AVI file by default.
    outputVideo = VideoWriter(fullfile('results', res_name));
    open(outputVideo);
    
    % Loop through the image sequence, load each image, and then write it to the video.
    for ii = 1:length(sortedImageNames)
        img = imread(fullfile('results', fld, sortedImageNames{ii}));
        writeVideo(outputVideo,img);
    end
    
    close(outputVideo);
end
