function video_processing(fname_src, fname_gt, fname_templ, fname_res, np, nb, ds, devs, fld, hist_int, adaptive, save_frames)
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
    templ_reg = rgb2hsv(imread(fname_templ));
    
    %hdl = figure(2);
  %  mov(49).cdata = read(videoObj, tstate.firstFrame+49);
  %  imshow(mov(49).cdata);
  %  hold on;
    %saveas(h, 'ref_hist', 'jpg');
    
    %hsvI = rgb2hsv(mov(1).cdata);
    
  %  rect = [215, 481, 127, 87];
  %  rectangle('Position', rect, 'LineWidth',2, 'EdgeColor','b');
    %templ_reg = imcrop(hsvI, rect);
    Q_TEMPL = getHSVHist(templ_reg);
    totalres = zeros(1,2);
        
    particles = prepareFirstSetAdaptiveSIR(tstate, width, height);
    fileID = fopen(fname_res, 'w');
    %scatter(particles(:,1), particles(:,2));
    disp('prepared first set');
    qInds = zeros(1, nFrames);
    %h=figure('Visible', 'off');
    for k=1:nFrames
        % process current frame
        t_start = tic;
        if adaptive
            [particles] = processFrameAdaptiveSIR(mov(k).cdata, particles, tstate);
        else
            [particles] = processFrameSimpleSIR(mov(k).cdata, particles, tstate);
        end
        t_stop = toc(t_start);
        disp(sprintf('Frame %d: %5.2f sec\n', k, t_stop));
        tstate.x = sum(particles(:,1).*particles(:,9));
        tstate.y = sum(particles(:,2).*particles(:,9));
        tstate.w = sum(particles(:,3).*particles(:,9)); 
        tstate.h = sum(particles(:,4).*particles(:,9));
            
        %estH = tstate.w*tstate.ar;
        estRect = [tstate.x tstate.y tstate.w tstate.h];
        
        imshow(mov(k).cdata);
        hold on;
     %   scatter(particles(:,1), particles(:,2));
        rectangle('Position', estRect, 'LineWidth',2, 'EdgeColor','b');
        if save_frames
            fname = fullfile('results', fld, sprintf('%d.jpg', k+tstate.firstFrame-1)); 
            hdl = gcf;
            saveas(hdl, fname, 'jpg');
        end
        hold off;
        
        if hist_int > 0 && rem(k,hist_int) == 0 
            draw_hists(particles, 25, estRect, 3, fullfile('results', fld, 'hists', sprintf('hist_%d.jpg', k+tstate.firstFrame-1))); 
            figure(hdl);
        end
        if isBobot
            [gtRect estRect] = getRegionsForQualityIndexBobot(estRect, gt(k,:), width, height);
        else
            if isFerrari
                [gtRect estRect] = getRegionsForQualityIndexFerrari(estRect, gt(k,:));
            end
        end
        qInds(k) = qualityIndex(estRect, gtRect);
        fprintf(fileID, '%d %e %e %e %e %e\n', k+tstate.firstFrame-1, tstate.x, tstate.y, tstate.w, tstate.h, qInds(k));
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
    fclose('all');
end
