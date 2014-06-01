%f=fopen('results\compare\VidB_test.txt');
[x, y] = readFile('results\compare\VidB_test.txt');
f = fopen('results\VidB_distsBG.txt');
dists = fscanf(f, '%f', [1 inf]);
fclose(f);


subplot(2,1,1);
drawSubplot(x,y,'results');
subplot(2,1,2);
drawSubplot(x,dists,'dists');