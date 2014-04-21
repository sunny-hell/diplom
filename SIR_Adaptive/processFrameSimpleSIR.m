function [particles] = processFrameSimpleSIR(I, curSet, state)
    % I - кадр
    % curSet - набор частиц с пред. шага
    % state - вектор состояния
    global N A DEVS KOEFF SIGMA Q_TEMPL;
    hsvI = rgb2hsv(I);
    particles = zeros(size(curSet));
    R = chol(diag(DEVS));
    v = (randn(N, 8)*R);
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
             particles(i,4) = 1;%/particles(i,3);
         end
         irect = particles(i, 1:4);
         try
            curHist = getHSVHist(imcrop(hsvI, irect));%[particles(i, 1:4), curW, curH]));
            D = getDistanceHSV(Q_TEMPL, curHist);
            particles(i, 9) = KOEFF*exp(-D/2/SIGMA);
         catch err
            disp('error in getHSVHist');
            disp('image size');
            disp(size(imcrop(hsvI, irect)));%[particles(i, 1:3) curH])));
            disp('rect');
            disp(irect);
            particles(i, 9) = 0;
         end
         
         if i > 1
            particles(i, 10) = particles(i-1,10) + particles(i,9);
         else 
            particles(i, 10) = particles(i,9);  
         end
    end
    particles(:, 9) = particles(:,9)/particles(N,10);
    particles(:, 10) = particles(:,10)/particles(N,10);
end

