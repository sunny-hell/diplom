videoObj = VideoReader('video\ptzSequence.avi');
width = videoObj.Width;
height = videoObj.Height;
cdata = read(videoObj, 1);
imshow(cdata);
hold on;
rect=[125.375 112.000 17.250 17.250*4.000];
rectangle('Position', rect, 'LineWidth',2, 'EdgeColor','b');