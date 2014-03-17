function state = getFirstStateFerrari01(gt)
    n = size(gt,1);
    state.firstFrame = gt(1,1);
    state.x = gt(1,2);
    state.y = gt(1,3);
    state.w = gt(1,4);
    state.ar = gt(1,5);
    state.lastFrame = gt(n,1);
end
