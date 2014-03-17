function [gtRect estRect] = getRegionsForQualityIndexBobot(rect, gtk, w, h)
    % gtk - ground truth vector for step k
    % rect - boundary rectangle for target on step k
    gtRect = [gtk(2:5)];
    estRect = rect./[w h w h];
        
end
