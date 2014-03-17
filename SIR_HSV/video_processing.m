function video_processing(fname_src, fname_gt, fname_res, np, nb, ds)
    global Q_TEMPL WIDTH HEIGHT KOEFF SIGMA N N_BINS R;
    N = np;
    SIGMA = 0.01; % сразу задаем квадрат
    KOEFF = 1/sqrt(2*pi*SIGMA);
    N_BINS = nb;
    R = chol(diag([60 60]));
    
    hold off
    
    videoObj = VideoReader(fname_src);
    width = videoObj.Width;
    height = videoObj.Height;
    
    isBobot = strcmp(ds, 'bobot');
    isFerrari = strcmp(ds, 'ferrari');
    if isBobot
        gt = readGroundTruthBobotDS(fname_gt);
        state = getFirstStateBobot(gt, width, height);
        
    else
        if isFerrari
            gt = readGroundTruthFerrariDS(fname_gt); 
            state = getFirstStateFerrari01(gt);
        end
    end
    
    disp('get first state'); 
    
    nFrames = state.lastFrame - state.firstFrame + 1;
    mov(1:nFrames) = struct('cdata', zeros(height, width, 3, 'uint8'),...
                           'colormap', []);
    mov(1).cdata = read(videoObj, state.firstFrame);
    disp('read first frame');
    
    hsvI = rgb2hsv(mov(1).cdata);
    rect = [state.x, state.y, state.w, state.h];
    templ_reg = imcrop(hsvI, rect);
    Q_TEMPL = getHSVHist(templ_reg);
    
    imshow(mov(1).cdata);
    hold on;
    rectangle('Position', rect, 'LineWidth',2, 'EdgeColor','b');
        
    particles = prepareFirstSetSIR(state, width, height);
    disp('prepared first set');
    fileID = fopen(fname_res, 'w');
    qInds = zeros(1, nFrames);
    h=figure('Visible', 'off');
    for k=1:nFrames
        % process current frame
        t_start = tic;
        [particles] = processFrame(mov(k).cdata, state, particles);
        t_stop = toc(t_start);
        disp(sprintf('Frame %d: %5.2f sec\n', k, t_stop));
        state.x = sum(particles(:,1).*particles(:,3));
        state.y = sum(particles(:,2).*particles(:,3));
        estRect = [state.x state.y state.w state.h];
        imshow(mov(k).cdata);
        hold on;
        rectangle('Position', estRect, 'LineWidth',2, 'EdgeColor','b');
        fname = fullfile('results', sprintf('%d.jpg', k+state.firstFrame-1)); 
        saveas(h, fname, 'jpg');
        hold off;
        if isBobot
            [gtRect estRect] = getRegionsForQualityIndexBobot(estRect, gt(k,:), width, height);
        else
            if isFerrari
                [gtRect estRect] = getRegionsForQualityIndexFerrari(estRect, gt(k,:));
            end
        end
        
        qInds(k) = qualityIndex(estRect, gtRect);
        fprintf(fileID, '%d %e %e %e %e %e\n', k+state.firstFrame-1, state.x, state.y, state.w, state.h, qInds(k));
          
        % get next frame
        if (k < nFrames)
            mov(k+1).cdata = read(videoObj, k+state.firstFrame);
        end
    end
    totalres(1) = sum(qInds)/nFrames;
    qsum = 0;
    for k=1:nFrames
        qsum = qsum + (qInds(k)-totalres(1)).^2;
    end
    totalres(2) = sqrt(qsum/nFrames);
    fprintf(fileID, '%e %e\n', totalres(1), totalres(2));
    disp('iteration results: ');
    disp(totalres(:));
    fclose(fileID);
    %fclose(fileID);
    %movie(hf, mov, 1, xyloObj.FrameRate);
    %processFrame(mov(1).cdata, 0, info, state);
end
