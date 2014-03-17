function [particles] = prepareFirstSetSIR(state, w, h)
    global N
    % w, h - размеры кадра
    dx = min(50, w-state.x);
    dy = min(50, h-state.y);
    positions = sampleUniform(2*dx, 2*dy) + repmat([state.x-dx state.y-dy], N, 1);
    particles = [positions(:,1) positions(:,2) repmat(1/N, N, 1)];
end 
