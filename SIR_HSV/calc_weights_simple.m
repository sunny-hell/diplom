function [weights] = calc_weights_simple(curSet, I, state)
    global KOEFF SIGMA Q_TEMPL
    weights = zeros(size(curSet,1), 1);
    hsvI = rgb2hsv(I);
    for i=1:size(curSet,1)
        rect = [curSet(i,1:2), state.w, state.h];
        histI2 = getHSVHist(imcrop(hsvI, rect));
        D = getDistanceHSV(Q_TEMPL, histI2);
                
        weights(i) = curSet(i,3)*KOEFF*exp(-D/2/SIGMA);
    end
end
