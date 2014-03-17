function [particles] = prepareFirstSetMT_AdaptiveSIR(states, w, h)
    global N
    % w, h - размеры кадра
    m = size(states,2); 
    nt = floor(N/m); % particles for one target
    d = zeros(m, 2);
    positions = zeros(N,2);
    particles = zeros(N, 11);
    for i=1:m
        d(i,:) = [min(10, w-states(i).x) min(10, h-states(i).y)]; 
        
        addp = (N - m*nt) >= i;
        pnum = nt + addp;
        fromInd = (i-1)*pnum+1;
        toInd = i*pnum;
        positions(fromInd:toInd, :) = sampleUniform(2*d(i,1), 2*d(i,2), pnum) + repmat([states(i).x-d(i,1) states(i).y-d(i,2)], pnum, 1);
        
        particles(fromInd:toInd, 1:4) = [positions(fromInd:toInd,:) repmat(states(i).w, pnum, 1) repmat(states(i).ar, pnum, 1) ];
        particles(fromInd:toInd, 9:10) = [repmat(1/pnum, pnum, 1) repmat(1/pnum, pnum, 1).*(linspace(1,pnum,pnum)')];   
        
    end
    particles(:, 5:8) = [zeros(N,1) zeros(N,1) zeros(N,1) zeros(N,1)];
    particles(:, 11) = zeros(N,1);
      
    
end 
