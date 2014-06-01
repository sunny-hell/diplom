%f = fopen('results\VidB.txt');

[x,y] = readFile('results\compare\VidI.txt');
subplot(5,1,1);
drawSubplot(x,y,'simple');

%f = fopen('results\compare\VidF_adaptive.txt');
[x,y] = readFile('results\compare\VidI_adaptive.txt');
subplot(5,1,2);
drawSubplot(x,y,'adaptive');

%f = fopen('results\VidF_update.txt');
[x,y] = readFile('results\compare\VidI_update.txt');
subplot(5,1,3);
drawSubplot(x,y,'update model');

%f = fopen('results\compare\VidF_adaptive_update.txt');
[x,y] = readFile('results\compare\VidI_adaptive_update.txt');
subplot(5,1,4);
drawSubplot(x,y,'adaptive + update model');

f = fopen('results\VidI_distsBG.txt');
dists = fscanf(f, '%f', [1 inf]);
fclose(f);
subplot(5,1,5);
drawSubplot(x,dists,'dists');
