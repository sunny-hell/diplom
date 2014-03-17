function [particles] = processFrameAdaptiveSIR(I, curSet, state)
    % I - кадр
    % curSet - набор частиц с пред. шага
    % curDev - набор отклонений с пред. шага
    % state - вектор состояния
    % gt (ground truth) - размеченные данные для пред. шага в формате [x, y, w, h]
    global N A DEVS KOEFF SIGMA Q_TEMPL;
    hsvI = rgb2hsv(I);
    % посчитаем расстояние от текущей рассчитанной позиции state.x, state.y
    %  до целевой гистограммы
    h = state.w*state.ar;
    hr = h;
    if (h < 1)
        hr = 1;
    end
    rect = [state.x, state.y, state.w, hr]; 
    I2 = imcrop(hsvI, rect);
    calcHist = getHSVHist(I2);
   
     D = getDistanceHSV(Q_TEMPL, calcHist);
     sigmoid = getSigmoid(D);
     minHW = min(state.w, h);
     dynCoeff = 1.0-sigmoid;
     sigmaStc = sigmoid * minHW * DEVS(1:4)';
     sigmaDyn = dynCoeff * minHW * DEVS(5:8)';
     for j=5:8
         curSet(:,j) = dynCoeff*curSet(:,j);
     end
    particles = zeros(size(curSet));
    try
        R = chol(diag([sigmaStc sigmaDyn]));
        v = (randn(N, 8)*R);
    catch err
        disp('error in getting random vector v');
        disp(err);
        disp('state.w'); disp(state.w);
        disp('state.ar'); disp(state.ar);
        disp('h'); disp(h);
        disp('hr'); disp(hr);
        sigmaStc = DEVS(1:4)';
        sigmaDyn = DEVS(5:8)';
        R = chol(diag([sigmaStc sigmaDyn]));
        v = (randn(N, 8)*R);
        %disp('sigmaStc'); disp(sigmaStc);
        %disp('sigmaDyn'); disp(sigmaDyn);
        %diag([sigmaStc sigmaDyn])
    end
    for i=1:N
        % resamling
         r = rand;  % draw r from uniform distribution
         j = find(curSet(:, 10) >= r, 1, 'first'); % индекс первой частицы в наборе, cumulative weight которой больше r
         try
            particles(i, :) = curSet(j, :);           % копируем данную частицу в новый набор
         catch err
             disp(sprintf('i=%d j=%d',i,j));
             disp('particles:');
             disp(particles(i,:));
             disp('curSet:');
             disp(curSet(j,:));
             disp(err);
         end
         particles(i, 1:8) = (A*particles(i,1:8)' + v(i,:)')';
         particles(i, particles(i, 1:2)<0) = 0;
         if particles(i,3)<=0
             particles(i,3) = 1;
         end
         if particles(i,4) <= 0
             particles(i,4) = 1/particles(i,3);
         end
         %particles(i, particles(i,3)<=0) = 1;
         %particles(i, particles(i,4)<=0) = 1/particles(i,3);
         %if isempty(find(particles(i, 1:4)<0, 1))
            curW = particles(i,3);
            if curW < 1
                curW = 1;
            end
            curH = particles(i,3)*particles(i,4);
           
            if (curH < 1)
                curH = 1;
            end
            irect = [particles(i, 1:3) curH];
            try
                curHist = getHSVHist(imcrop(hsvI, [particles(i, 1:2), curW, curH]));
                D = getDistanceHSV(Q_TEMPL, curHist);
                particles(i, 9) = KOEFF*exp(-D/2/SIGMA);
   %             if (i>1)
   %                 particles(i, 9) = particles(i-1, 9)*particles(i, 9);
   %             end
            catch err
                disp('error in getHSVHist');
                disp('image size');
                disp(size(imcrop(hsvI, [particles(i, 1:3) curH])));
                disp('rect');
                disp(irect);
                particles(i, 9) = 0;
            end
         %else
             %disp('bad particle');
             %disp(particles(i,1:4));
         %    particles(i,9)=0;
         %end
         
         if i > 1
            particles(i, 10) = particles(i-1,10) + particles(i,9);
         else 
            particles(i, 10) = particles(i,9);  
         end
         
        
    end
    particles(:, 9) = particles(:,9)/particles(N,10);
    particles(:, 10) = particles(:,10)/particles(N,10);
end

