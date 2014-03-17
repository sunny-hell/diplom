function [gtRect estRect] = getRegionsForQualityIndexFerrari(rect, gtk)
    % gtk - ground truth vector for step k
    % rect - boundary rectangle for target on step k
    gtRect = [gtk(2:4) gtk(4)*gtk(5)];
    estRect = rect;
        
end
