function video_processing_multitarget(M, fname_src, fnames_gt, fname_res, np, nb, ds, devs, fld)
    global Q_TEMPL KOEFF SIGMA N N_BINS R ALPHA BETA ERF_COEFF A DEVS;
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
    hold off;
    
    videoObj = VideoReader(fname_src);
    width = videoObj.Width;
    height = videoObj.Height;
    isBobot = strcmp(ds, 'bobot');
    isFerrari = strcmp(ds, 'ferrari');
    tstates(1:M) = struct('firstFrame', 0, 'x', 0, 'y', 0, 'w', 0, 'ar', 0,  'lastFrame', 0);
    
    if isBobot
        for i=1:M
            gt(:,:,i) = readGroundTruthBobotDS(fnames_gt(i,:));
            disp('tstates:');
            tstates(i)
            disp('get state:');
            getFirstStateBobot(gt(:,:,i), width, height)
            tstates(i) = getFirstStateBobot(gt(:,:,i), width, height);
        end
    else
        if isFerrari
            gt = readGroundTruthFerrariDS(fnames_gt(1)); 
            tstates = getFirstStateFerrari01(gt);
        end
    end
    nFrames = tstates(1).lastFrame - tstates(1).firstFrame + 1;
    disp('get first state'); 
    
    mov(1:nFrames) = struct('cdata', zeros(height, width, 3, 'uint8'),...
                           'colormap', []);
    mov(1).cdata = read(videoObj, tstates(1).firstFrame);
    disp('read first frame');
    imshow(mov(1).cdata);
    hold on;
    particles = prepareFirstSetMT_AdaptiveSIR(tstates, width, height);
    hsvI = rgb2hsv(mov(1).cdata);
    Q_TEMPL = zeros(N_BINS, 2, size(tstates,2));
     
    for i=1:M
        rect = [tstates(i).x, tstates(i).y, tstates(i).w, tstates(i).w*tstates(i).ar];
        Q_TEMPL(:,:,i) = getHSVHist(imcrop(hsvI, rect));
        %rectangle('Position', rects(i,:), 'LineWidth',2, 'EdgeColor','b');
    end
    
    particles = k_means_cluster(tstates, particles, hsvI);
    
%     t1_parts = particles(particles(:,11)==1,1:2);
%     t2_parts = particles(particles(:,11)==2,1:2);
%     
%     scatter(t1_parts(:,1), t1_parts(:,2), 'MarkerEdgeColor', 'b');
%     scatter(t2_parts(:,1), t2_parts(:,2), 'MarkerEdgeColor', 'r');
%     hsvI = rgb2hsv(mov(1).cdata);
    targetWeights = repmat(1/M, M, 1);
    for k=1:nFrames
        % process current frame
        t_start = tic;
        [particles] = processFrameMT_AdaptiveSIR(mov(k).cdata, particles, tstates);
        t_stop = toc(t_start);
        disp(sprintf('Frame %d: %5.2f sec\n', k, t_stop));
        imshow(mov(k).cdata);
        hold on;
        for t=1:M
            templ = particles(:,11)==t;
            tstates(t).x = sum(particles(templ, 1).*particles(templ, 9));
            tstates(t).y = sum(particles(templ, 2).*particles(templ, 9));
            tstates(t).w = sum(particles(templ, 3).*particles(templ, 9));
            tstates(t).ar = sum(particles(templ, 4).*particles(templ, 9));
            estH = tstates(t).w*tstates(t).ar;
            estRect = [tstates(t).x tstates(t).y tstates(t).w estH];
            rectangle('Position', estRect, 'LineWidth',2);
        end
%         tstate.x = sum(particles(:,1).*particles(:,9));
%         tstate.y = sum(particles(:,2).*particles(:,9));
%         tstate.w = sum(particles(:,3).*particles(:,9)); 
%         tstate.ar = sum(particles(:,4).*particles(:,9));
            
        
        
        
        %scatter(particles(:,1), particles(:,2));
        
        %fname = fullfile('results', fld, sprintf('%d.jpg', k+tstate.firstFrame-1)); 
        %saveas(h, fname, 'jpg');
        hold off;
%          if ((k == 1) || ...
%              (rem(k,10) == 0))  ...
%              ...
%              figure('Visible', 'on');
%          
%           
%         end
%         if isBobot
%             [gtRect estRect] = getRegionsForQualityIndexBobot(estRect, gt(k,:), width, height);
%         else
%             if isFerrari
%                 [gtRect estRect] = getRegionsForQualityIndexFerrari(estRect, gt(k,:));
%             end
%         end
%         qInds(k) = qualityIndex(estRect, gtRect);
        %fprintf(fileID, '%d %e %e %e %e %e\n', k+tstate.firstFrame-1, tstate.x, tstate.y, tstate.w, tstate.ar, qInds(k));
      % get next frame
        if (k < nFrames)
            mov(k+1).cdata = read(videoObj, k+tstates(1).firstFrame);
        end
    end
end
