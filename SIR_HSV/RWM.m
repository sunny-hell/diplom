function [newSet] = RWM(curSet)
    % Random Walk Model
    global R;
    newSet(:,1:2) = curSet(:, 1:2) + randn(size(curSet, 1), 2)*R;
    newSet(:,3) = curSet(:,3);
end
