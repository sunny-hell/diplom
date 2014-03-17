function [gt] = readGroundTruthBobotDS(fName)
    disp(char(fName));
    f = fopen(char(fName));
    gt = fscanf(f, '%d %f %f %f %f', [5 inf])';
    gt(:, 1) = gt(:,1) + ones(size(gt,1),1);
    
    fclose(f);
end
