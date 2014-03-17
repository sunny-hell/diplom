function state = getFirstStateBobot(gt, width, height)
    % tempo hardcode
    n = size(gt,1);
    state.firstFrame = gt(1,1);    
    state.x = gt(1,2) * width;
    state.y = gt(1,3) * height;
    state.w = gt(1,4) * width;
    state.h = gt(1,5) * height;
    state.lastFrame = gt(n,1);
end
