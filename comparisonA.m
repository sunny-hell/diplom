%f = fopen('results\VidB.txt');

[x,y] = readFile('results\compare\Vid_A.txt');
subplot(4,1,1);
drawSubplot(x,y,'Q_k');
title('Стандартный алгоритм');

%f = fopen('results\compare\VidF_adaptive.txt');
[x,y] = readFile('results\compare\Vid_A_adaptive.txt');
subplot(4,1,2);
drawSubplot(x,y,'Q_k');
title('Алгоритм с адаптацией матрицы ковариации модели динамики');

f = fopen('results\compare\Vid_A_update.txt');
res = fscanf(f, '%d %f %*f', [2, inf])';
x= res(:,1);
y=res(:,2);
fclose(f);
%[x,y] = readFile('results\compare\Vid_D_update.txt');
subplot(4,1,3);
drawSubplot(x,y,'Q_k');
title('Алгоритм с обновлением эталонной гистограммы');

%f = fopen('results\compare\VidF_adaptive_update.txt');
f = fopen('results\compare\Vid_A_adaptive_update.txt');
res = fscanf(f, '%d %f %*f', [2, inf])';
x= res(:,1)
y=res(:,2)
fclose(f);

%[x,y] = readFile('results\compare\Vid_D_adaptive_update.txt');
subplot(4,1,4);
drawSubplot(x,y,'Q_k');
title('Алгоритм с адаптацией матрицы ковариации и обновлением эталонной гистограммы');
xlabel('Номер кадра');

