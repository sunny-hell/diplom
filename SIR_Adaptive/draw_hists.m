function draw_hists(curSet, nBins, est_rect, fig_num, fname)
    hh = figure(fig_num);
    subplot(4, 2, 1);
    hist(curSet(:,1), nBins);
    grid on;
    title('x');
   
    [X,I] = sort(curSet(:,1));
    W = curSet(I,9);
    subplot(4, 2, 2);
    
    [AX, H1, H2] = plotyy(X, W, [est_rect(1), est_rect(1)], [0,1]);
    set(H2, 'color', 'r');
    set(H2, 'linewidth', 2);
%     
    grid on;
    title('weights of x');

    
    subplot(4, 2, 3);
    hist(curSet(:,2), nBins);
    grid on;
    title('y');
    
    [Y,I] = sort(curSet(:,2));
    W = curSet(I,9);
    subplot(4, 2, 4);
    
    [AX, H1, H2] = plotyy(Y, W, [est_rect(2), est_rect(2)], [0,1]);
    set(H2, 'color', 'r');
    set(H2, 'linewidth', 2);
%   
    grid on;
    title('weights of y');
%     
    
    subplot(4, 2, 5);
    hist(curSet(:,3), nBins);
    grid on;
    title('width');
    
    [WW,I] = sort(curSet(:,3));
    W = curSet(I,9);
    
    subplot(4, 2, 6);
    [AX, H1, H2] = plotyy(WW, W, [est_rect(3), est_rect(3)], [0,1]);
    set(H2, 'color', 'r');
    set(H2, 'linewidth', 2);
%   
    grid on;
    title('weights of width');
%     
    
    subplot(4, 2, 7);
    hist(curSet(:,4), nBins);
    grid on;
    title('height');
    
    [H, I] = sort(curSet(:,4));
    W = curSet(I, 9);
    subplot(4, 2, 8);
    [AX, H1, H2] = plotyy(H, W, [est_rect(4), est_rect(4)], [0,1]);
    set(H2, 'color', 'r');
    set(H2, 'linewidth', 2);
%   
    grid on;
    title('weights of height');
    
    saveas(hh, fname, 'jpg');
    hold off;
end
