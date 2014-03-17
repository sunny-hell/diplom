function [hist] = getHSVHist(hsvI)
    global N_BINS;
    
    hist = zeros(N_BINS, 2);
    hist(:, 1) = imhist(hsvI(:,:,1), N_BINS);
    hist(:,1) = hist(:,1)./sum(hist(:,1));
    hist(:, 2) = imhist(hsvI(:,:,2), N_BINS);
    hist(:,2) = hist(:,2)./sum(hist(:,2));
end
