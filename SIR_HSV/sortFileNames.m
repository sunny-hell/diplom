function sortedNames = sortFileNames(dirList)
     % Convert the set of image names to a cell array.
     fNames = {dirList.name}';
     % match any file names that contain a sequence of numeric digits. Convert the strings to doubles.
     fStrings = regexp([fNames{:}],'(\d*)','match');
     fNumbers = str2double(fStrings);
    
    % Sort the frame numbers from lowest to highest. 
    % The sort function returns an index matrix that indicates how to order the associated files.
    [~,sortedIndices] = sort(fNumbers);
    sortedNames = fNames(sortedIndices);
end
