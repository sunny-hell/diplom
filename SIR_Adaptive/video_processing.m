function video_processing(fname_src, fname_gt, fname_res, np, nb, ds, devs, fld)
    global Q_TEMPL KOEFF SIGMA N N_BINS R ALPHA BETA ERF_COEFF A DEVS;
   % clc;
    close all;
    N = np;
    SIGMA = 0.01; % сразу задаем квадрат
    KOEFF = 1/sqrt(2*pi*SIGMA);
    N_BINS = nb; %128;
    ALPHA = 8;
    BETA = 0.5;
    ERF_COEFF = 2/sqrt(pi); % коэффициент при функции ошибки erf
    A =  [eye(4) eye(4); zeros(4) eye(4)];
    DEVS = devs;%[5 0.3 0.2 0.05 0.5 0.08 0.05 0.005]';
    R = chol(diag(DEVS));
    hold off;

    videoObj = VideoReader(fname_src);
    width = videoObj.Width;
    height = videoObj.Height;
    
    isBobot = strcmp(ds, 'bobot');
    isFerrari = strcmp(ds, 'ferrari');
    if isBobot
        gt = readGroundTruthBobotDS(fname_gt);
        tstate = getFirstStateBobot(gt, width, height);
        
    else
        if isFerrari
            gt = readGroundTruthFerrariDS(fname_gt); 
            tstate = getFirstStateFerrari01(gt);
        end
    end
    %gt = readGroundTruthFerrariDS(fname_gt);
    
    %state = getFirstStateFerrari01(gt);
    nFrames = tstate.lastFrame - tstate.firstFrame + 1;
    disp('get first state'); 
    
    mov(1:nFrames) = struct('cdata', zeros(height, width, 3, 'uint8'),...
                           'colormap', []);
      
    mov(1).cdata = read(videoObj, tstate.firstFrame);
    
    disp('read first frame');
    %figure(100)
    imshow(mov(1).cdata);
    hold on;
    
    hsvI = rgb2hsv(mov(1).cdata);
    rect = [tstate.x, tstate.y, tstate.w, tstate.w*tstate.ar];
    rectangle('Position', rect, 'LineWidth',2, 'EdgeColor','b');
    templ_reg = imcrop(hsvI, rect);
    Q_TEMPL = getHSVHist(templ_reg);
    totalres = zeros(1,2);
        
    particles = prepareFirstSetAdaptiveSIR(tstate, width, height);
    fileID = fopen(fname_res, 'w');
    %scatter(particles(:,1), particles(:,2));
    disp('prepared first set');
    qInds = zeros(1, nFrames);
    h=figure('Visible', 'off');
    for k=1:nFrames
        % process current frame
        t_start = tic;
        [particles] = processFrameAdaptiveSIR(mov(k).cdata, particles, tstate);
        t_stop = toc(t_start);
        disp(sprintf('Frame %d: %5.2f sec\n', k, t_stop));
        tstate.x = sum(particles(:,1).*particles(:,9));
        tstate.y = sum(particles(:,2).*particles(:,9));
        tstate.w = sum(particles(:,3).*particles(:,9)); 
        tstate.ar = sum(particles(:,4).*particles(:,9));
            
        estH = tstate.w*tstate.ar;
        estRect = [tstate.x tstate.y tstate.w estH];
        
        imshow(mov(k).cdata);
        hold on;
        %scatter(particles(:,1), particles(:,2));
        rectangle('Position', estRect, 'LineWidth',2, 'EdgeColor','b');
        fname = fullfile('results', fld, sprintf('%d.jpg', k+tstate.firstFrame-1)); 
        saveas(h, fname, 'jpg');
        hold off;
%          if ((k == 1) || ...
%              (rem(k,10) == 0))  ...
%              ...
%              figure('Visible', 'on');
%          
%           
%         end
        if isBobot
            [gtRect estRect] = getRegionsForQualityIndexBobot(estRect, gt(k,:), width, height);
        else
            if isFerrari
                [gtRect estRect] = getRegionsForQualityIndexFerrari(estRect, gt(k,:));
            end
        end
        qInds(k) = qualityIndex(estRect, gtRect);
        fprintf(fileID, '%d %e %e %e %e %e\n', k+tstate.firstFrame-1, tstate.x, tstate.y, tstate.w, tstate.ar, qInds(k));
      % get next frame
        if (k < nFrames)
            mov(k+1).cdata = read(videoObj, k+tstate.firstFrame);
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
end
