function D = getDistanceRGB(It, I)
    global N_BINS;
    
    rHistT = imhist(It(:,:,1), N_BINS);
    rHistT = rHistT / sum(rHistT);
    gHistT = imhist(It(:,:,2), N_BINS);
    gHistT = gHistT / sum(gHistT);
    bHistT = imhist(It(:,:,3), N_BINS);
    bHistT = bHistT / sum(bHistT);
    
    rHist = imhist(I(:,:,1), N_BINS);
    rHist = rHist / sum(rHist);
    gHist = imhist(I(:,:,2), N_BINS);
    gHist = gHist / sum(gHist);
    bHist = imhist(I(:,:,3), N_BINS);
    bHist = bHist / sum(bHist);
    D = getDistance(rHistT, rHist) + getDistance(gHistT, gHist) + getDistance(bHistT, bHist);
end
