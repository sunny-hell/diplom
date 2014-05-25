function [x y] = readFile(f)
    res = fscanf(f, '%d %f', [2 inf])';
    fclose(f);
    x = res(:,1) + ones(size(res(:,1)));
    y = res(:,2);
end