function [gt] = readGroundTruthFerrariDS(fName)
    f = fopen(fName);
    gt = fscanf(f, '%d %f %f %f %f %*f %*f %*f %*f %*f', [5 inf])';
    fclose(f);
    
end
