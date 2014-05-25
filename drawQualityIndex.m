f = fopen('results\Seq_C_adaptive2.txt');
[x,y] = readFile(f);
subplot(3, 2, 1);
drawSubplot(x,y, 'Seq_C');
title('С адаптацией');
%%
f = fopen('results\Seq_C_nonadaptive2.txt');
[x,y] = readFile(f);
subplot(3, 2, 2);
drawSubplot(x,y, 'Seq_C');
title('Без адаптации');
%%
%%
f = fopen('results\Seq_H_adaptive.txt');
[x,y] = readFile(f);
subplot(3, 2, 3);
drawSubplot(x,y, 'Seq_H');
%%
f = fopen('results\Seq_H_nonadaptive.txt');
[x,y] = readFile(f);
subplot(3, 2, 4);
drawSubplot(x,y, 'Seq_H');
%%
%%
f = fopen('results\Seq_E_adaptive.txt');
[x,y] = readFile(f);
subplot(3, 2, 5);
drawSubplot(x,y, 'Seq_E');
xlabel('Номер кадра');
%%
f = fopen('results\Seq_E_nonadaptive.txt');
[x,y] = readFile(f);
subplot(3, 2, 6);
drawSubplot(x,y, 'Seq_E');
xlabel('Номер кадра');




