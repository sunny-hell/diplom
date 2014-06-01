res = dlmread('results\compare\vid_F_adaptive.txt');
hold off;
x = res(:,1);
y = res(:, 2);
plot(x,y);
xlim([min(x), max(x)]);
hold on
plot(xlim(), [0.3 0.3], 'r');