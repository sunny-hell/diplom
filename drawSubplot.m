function drawSubplot(x, y, title)
          
    plot(x, y);
    xlim([0, max(x)]);
    yPos = 0.3;
    
    hold on
    plot(xlim(), [yPos yPos], 'r'); % Adapts to x limits of current axes
    hold off
   % 
    ylabel(title);
end