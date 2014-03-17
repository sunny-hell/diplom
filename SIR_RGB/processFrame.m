function [newSet] = processFrame(I, k, curSet, q_templ_reg)
    %k = є кадра
    %curSet = текущий набор частиц
    global Q_TEMPL WIDTH HEIGHT KOEFF SIGMA N_BINS;
    hold off;
    weights = zeros(size(curSet,1), 1);
    t_start1 = tic;
    for i=1:size(curSet,1)
        rect = [curSet(i,1:2), WIDTH-1, HEIGHT-1];
        I2 = imcrop(I, rect);
        h = min(size(I2, 1), HEIGHT-1);
        w = min(size(I2, 2), WIDTH-1);
        if (h ~= HEIGHT-1 || w ~= WIDTH-1)
            rect = [0,0,w,h];
            q_templ_reg_crop = imcrop(q_templ_reg, rect);
            D = getDistanceRGB(q_templ_reg_crop, I2);
        else
            D = getDistanceRGB(q_templ_reg, I2);
        end
        %hist = getRGBHistogram(I2, w, h, N_BINS);
        %if (h ~= HEIGHT || w ~= WIDTH)
        %    q_templ = getRGBHistogram(q_templ_reg, w, h, N_BINS);
        %    D = getDistance(q_templ, hist);
        %else
        %    D = getDistance(Q_TEMPL, hist);
        %end
                
        weights(i) = curSet(i,3)*KOEFF*exp(-D/2/SIGMA);
    end
    curSet(:,3) = weights / sum(weights);
    t_end1 = toc(t_start1);
    t_start2 = tic;
    newSet = resample(curSet);
    t_end2 = toc(t_start2);
    t_start3 = tic;
    newSet = RWM(newSet);
    t_end3 = toc(t_start3);
    disp(sprintf('Ќа вычисление весов: %5.2f сек; на перевыборку: %5.2f сек; на предсказание: %5.2f сек.', ...
        t_end1, t_end2, t_end3));
    %rect = [state.x, state.y, state.width-1, state.height-1];
    %I2 = imcrop(I, rect);
    %figure(2);
    %imshow(I2);
    %
    %if (k == 1)
    %    q_templ = hist;
        
    %end
    
    %
    
end
