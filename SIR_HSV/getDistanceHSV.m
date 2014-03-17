function D = getDistanceHSV(histT, hist)
    D = getDistance(histT(:, 1), hist(:,1)) + getDistance(histT(:,2), hist(:,2)); 
    
end
