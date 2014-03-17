function state = getFirstStateSeqD(width, height)
    % tempo hardcode
    global WIDTH HEIGHT;
    x0 = 0.431753;  % for vid_d_person
    y0 = 0.240421;  % for vid_d_person
    
    state.x = round(x0 * width);
    state.y = round(y0 * height);
    rectw0 = 0.12; % for vid_d_person
    recth0 = 0.54; % for vid_d_person 
    WIDTH = round(rectw0 * width);
    HEIGHT = round(recth0 * height);
    
end
