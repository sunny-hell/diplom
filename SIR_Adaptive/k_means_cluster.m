function particles = k_means_cluster(states, particles, hsvI)
    global Q_TEMPL;
    centers = [states(:).x; states(:).y]';
    prevpos = repmat(-1, size(centers));
    m = size(centers, 1);
    n = size(particles, 1);
    while ~all((abs(centers-prevpos) <= 1e-6))
        prevpos = centers;
        centers = zeros(size(centers));
        disp('before clustering: centers are');
        disp(prevpos);
        for i=1:n
            D = zeros(1,m);
            for j=1:m
                w = particles(i,3);
                h = particles(i,3)*particles(i,4);
                if (w < 1)
                    w = 1; 
                end
                if (h < 1)
                    h = 1;
                end
                hist = getHSVHist(imcrop(hsvI, [particles(i, 1:2), w, h]));
                D(j) = getDistanceHSV(Q_TEMPL(:,:,j), hist);
            end
%             disp('D is: ');
%             disp(D);
            clNum = find(D==min(D)); % indexes of min values in D
%             disp('clNum is: ');
%             disp(clNum);
            particles(i, 11) = clNum(1);
            centers(clNum(1), :) = centers(clNum(1), :) + particles(i, 1:2);
        end
        for j=1:m
            centers(j,:) = centers(j,:) ./ sum(particles(:, 11) == j);
        end
        disp('after clustering: centers are');
        disp(centers);
    end
end
