function video_processing()
    global Q_TEMPL WIDTH HEIGHT KOEFF SIGMA N N_BINS R;
    N = 200;
    SIGMA = 0.01; % сразу задаем квадрат
    KOEFF = 1/sqrt(2*pi*SIGMA);
    N_BINS = 128;
    R = chol([15 0; 0 15]);
    videoObj = VideoReader('Vid_D_person.avi');
    %videoObj = VideoReader('Vid_A_ball.avi');
    nFrames = videoObj.NumberOfFrames;
    width = videoObj.Width;
    height = videoObj.Height;
    mov(1:nFrames) = struct('cdata', zeros(height, width, 3, 'uint8'),...
                           'colormap', []);

    state = getFirstState(width, height);
    rect = [state.x, state.y, WIDTH, HEIGHT];
    mov(1).cdata = read(videoObj, 1);
    I2 = imcrop(mov(1).cdata, rect);
    imshow(I2);
    %Q_TEMPL = getRGBHistogram(I2, WIDTH, HEIGHT, N_BINS);
    
    particles = sampleUniform(width, height);
        
    %figure(2);
    %imshow(mov(1).cdata);
    %hold on;
    %scatter(particles(:,1), particles(:,2));
    %processFrame(mov(1).cdata, 1, particles, weights);
    
    for k=1:500
        if ((k == 1) || (rem(k,25) == 0))
            figure(k);
            imshow(mov(k).cdata);
            hold on;
            x = particles(:,1);
            y = particles(:,2);
            scatter(x,y);
        end
        % process current frame
        t_start = tic;
        [particles] = processFrame(mov(k).cdata, k, particles, I2);
        t_stop = toc(t_start);
        disp(sprintf('Frame %d: %5.2f sec\n', k, t_stop));
        
        % get next frame
        if (k < 500)
            mov(k+1).cdata = read(videoObj, k+1);
        end
        
        
    end
        
    %movie(hf, mov, 1, xyloObj.FrameRate);
    %processFrame(mov(1).cdata, 0, info, state);
end
