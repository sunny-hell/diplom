function [qual] = video_processing_estimation(fname_src, fname_gt, fname_templ, fname_res, niter, np, nb, ds, devs)
    global Q_TEMPL KOEFF SIGMA N N_BINS R ALPHA BETA ERF_COEFF A DEVS;
    clc;
    close all;
    N = np;
    SIGMA = 0.01; % сразу задаем квадрат
    KOEFF = 1/sqrt(2*pi*SIGMA);
    N_BINS = nb;
    ALPHA = 8;
    BETA = 0.5;
    ERF_COEFF = 2/sqrt(pi); % коэффициент при функции ошибки erf
    A =  [eye(4) eye(4); zeros(4) eye(4)];
    DEVS = devs;%[5.2 0.8 0.02 0.02 0.8 0.08 0.001 0.001]';
    %R = chol(diag(DEVS));
    hold off;
    
  %  fname_src = '..\sample_videos\movie01.avi';
  %  fname_gt = '..\gt\ferrari\movie01.txt';

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
    
    %gt = readGroundTruthFerrariDS(fname_gt);
    
    %  state = getFirstStateFerrari01(gt);
    nFrames = state.lastFrame - state.firstFrame + 1;
    disp('get first state'); 
    mov(1:nFrames) = struct('cdata', zeros(height, width, 3, 'uint8'),...
                           'colormap', []);
      
    mov(1).cdata = read(videoObj, state.firstFrame);
    
    disp('read first frame');
    templ_reg = rgb2hsv(imread(fname_templ));
    
    Q_TEMPL = getHSVHist(templ_reg);
    totalres = zeros(niter, 2);
    %fileID = fopen('mov01_non_adaptive_results.txt', 'w');
    fileID = fopen(fname_res, 'w');
    for iter=1:niter
      
        if isBobot
            state = getFirstStateBobot(gt, width, height);
        
        else
            if isFerrari
                state = getFirstStateFerrari01(gt);
            end
        end
        %state = getFirstStateFerrari01(gt);
        particles = prepareFirstSetAdaptiveSIR(state, width, height);
        disp('prepared first set');
        qInds = zeros(1, nFrames);
        fprintf(fileID, 'iter %d\n', iter);
        for k=1:nFrames
            % process current frame
            t_start = tic;
            [particles] = processFrameAdaptiveSIR(mov(k).cdata, particles, state);
            t_stop = toc(t_start);
            disp(sprintf('iter %d Frame %d: %5.2f sec\n', iter, k, t_stop));
            state.x = sum(particles(:,1).*particles(:,9));
            state.y = sum(particles(:,2).*particles(:,9));
            state.w = sum(particles(:,3).*particles(:,9)); 
            state.h = sum(particles(:,4).*particles(:,9));
            
            estRect = [state.x state.y state.w state.h];
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
            if (k < nFrames && iter==1)
                mov(k+1).cdata = read(videoObj, k+state.firstFrame);
            end
        end
        totalres(iter,1) = sum(qInds)/nFrames;
        qsum = 0;
        for k=1:nFrames
            qsum = qsum + (qInds(k)-totalres(iter,1)).^2;
        end
        totalres(iter,2) = sqrt(qsum/nFrames);
        fprintf(fileID, 'result for iter %d: %e %e\n', iter, totalres(iter, 1), totalres(iter,2));
        disp('iteration results: ');
        disp(totalres(iter,:));
        
    end
    qual = sum(totalres(:,1)/niter);
    fprintf(fileID, 'total result: %f\n', qual); 
    fclose(fileID);
end
