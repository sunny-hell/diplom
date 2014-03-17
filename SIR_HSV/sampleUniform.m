function [x] = sampleUniform(w, h)
    global N;
    x = [randi(w, N, 1), randi(h, N, 1)];
    
end
