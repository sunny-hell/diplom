function [particles] = processFrameMT_AdaptiveSIR(I, curSet, states)
    % I - кадр
    % curSet - набор частиц с пред. шага
    % tarW - веса целей
    % state - вектор состояния
    
    global N A DEVS KOEFF SIGMA Q_TEMPL;
    hsvI = rgb2hsv(I);
    m = size(states, 2);
    v = zeros(N, 8);
    templates = zeros(N,m);
    for t = 1:m
        % посчитаем расстояни от текущей рассчитанной позиции state.x, state.y
        %  до целевой гистограммы
        h = states(t).w*states(t).ar;
        hr = h;
        if (h < 1)
            hr = 1;
        end
        rect = [states(t).x, states(t).y, states(t).w, hr];
        I2 = imcrop(hsvI, rect);
        calcHist = getHSVHist(I2);
        D = getDistanceHSV(Q_TEMPL(:,:,t), calcHist);
        sigmoid = getSigmoid(D);
        minHW = min(states(t).w, h);
        dynCoeff = 1.0-sigmoid;
        sigmaStc = sigmoid * minHW * DEVS(1:4)';
        sigmaDyn = dynCoeff * minHW * DEVS(5:8)';
        templ = curSet(:,11) == t; 
        templates(:,t) = templ;
        curSet(templ, 5:8) = curSet(templ, 5:8) * dynCoeff;  
        np = sum(templ);
        
        try
            R = chol(diag([sigmaStc sigmaDyn]));
            v(templ, :) = (randn(np, 8)*R);
        catch err
            disp('error in getting random vector v ');
            disp(err);
            disp ('target number'); disp(t);
            disp('state.w'); disp(states(t).w);
            disp('state.ar'); disp(states(t).ar);
            disp('h'); disp(h);
            disp('hr'); disp(hr);
            sigmaStc = DEVS(1:4)';
            sigmaDyn = DEVS(5:8)';
            R = chol(diag([sigmaStc sigmaDyn]));
            v(templ, :) = (randn(np, 8)*R);
            %disp('sigmaStc'); disp(sigmaStc);
            %disp('sigmaDyn'); disp(sigmaDyn);
            %diag([sigmaStc sigmaDyn])
        end
        
    end

    particles = zeros(size(curSet));
    particles(:, 11) = curSet(:,11);
    cumSums = repmat(-1,1,m); % массив для накапливаемых сумм
    
    for i=1:N
        t = curSet(i,11);
        templ = curSet(:,11) == t;
        % resamling
        r = rand;  % draw r from uniform distribution
        j = find(curSet(:, 10) >= r & templ , 1, 'first'); % индекс первой частицы в наборе для цели t, cumulative weight которой больше r
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
            D = getDistanceHSV(Q_TEMPL(:,:,t), curHist); % пока считаем, что частица принадлежит тому же объекту, что и раньше
            particles(i, 9) = KOEFF*exp(-D/2/SIGMA);
        catch err
            disp('error in getHSVHist');
            disp('image size');
            disp(size(imcrop(hsvI, [particles(i, 1:3) curH])));
            disp('rect');
            disp(irect);
            particles(i, 9) = 0;
        end
        %%% Считать накапливаемую сумму по частицм цели, а не по всем частицам!!!       
        if cumSums(t) == -1
            cumSums(t) = particles(i,9);
        else
            cumSums(t) = cumSums(t) + particles(i,9);
        end
        particles(i, 10) = cumSums(t);
    end
    
    for t=1:m
        templ = particles(:,11)==t;
        %disp('t='); disp(t);
        %disp(particles(templ, 9))
        %disp(particles(templ, 10))
        particles(templ, 9) = particles(templ,9)/cumSums(t);
        particles(templ, 10) = particles(templ,10)/cumSums(t);
        %disp(sum(particles(templ,9)));
        %   disp(sum(particles(templ,10)));
    end
end

