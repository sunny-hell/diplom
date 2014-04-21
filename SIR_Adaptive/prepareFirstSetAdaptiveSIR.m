function [particles] = prepareFirstSetAdaptiveSIR(state, w, h)
    global N
    % w, h - размеры кадра
    dx = min(50, w-state.x);
    dy = min(50, h-state.y);
    positions = sampleUniform(2*dx, 2*dy, N) + repmat([state.x-dx state.y-dy], N, 1);
    
    particles = [positions(:,1) positions(:,2) repmat(state.w, N, 1) repmat(state.h, N, 1) ...
                 zeros(N,1) zeros(N,1) zeros(N,1) zeros(N,1) ...
                 repmat(1/N, N, 1), repmat(1/N, N, 1).*(linspace(1,N,N)')];
end 
