function state = getFirstState(width, height)
    % tempo hardcode
    global WIDTH HEIGHT;
    x0 = 0.431753;
    y0 = 0.240421;
    %x0 = 0.626068;%0.431753;
    %y0 = 0.473884;%0.240421;
    state.x = round(x0 * width);
    state.y = round(y0 * height);
    %rectw0 = 0.14;
    %recth0 = 0.19;
    rectw0 = 0.12;
    recth0 = 0.54;
    WIDTH = round(rectw0 * width);
    HEIGHT = round(recth0 * height);
    
end
