f = fopen('results\Seq_A_adaptive.txt');
[x,y] = readFile(f);
subplot(4, 2, 1);
drawSubplot(x,y, 'Seq_A');
title('С адаптацией');
%%
f = fopen('results\Seq_A_nonadaptive.txt');
[x,y] = readFile(f);
subplot(4, 2, 2);
drawSubplot(x,y, 'Seq_A');
title('Без адаптации');
%%
%%
f = fopen('results\Seq_B_adaptive2.txt');
[x,y] = readFile(f);
subplot(4, 2, 3);
drawSubplot(x,y, 'Seq_B');
%%

f = fopen('results\Seq_B_nonadaptive2.txt');
[x,y] = readFile(f);
subplot(4, 2, 4);
drawSubplot(x,y, 'Seq_B');
%%
%%

f = fopen('results\Seq_F_adaptive.txt');
[x,y] = readFile(f);
subplot(4, 2, 5);
drawSubplot(x,y, 'Seq_F');
%%
f = fopen('results\Seq_F_nonadaptive.txt');
[x,y] = readFile(f);
subplot(4, 2, 6);
drawSubplot(x,y, 'Seq_F');
%%
%%
f = fopen('results\Seq_I_adaptive.txt');
[x,y] = readFile(f);
subplot(4, 2, 7);
drawSubplot(x,y, 'Seq_I');
xlabel('Номер кадра');
%%
f = fopen('results\Seq_I_nonadaptive.txt');
[x,y] = readFile(f);
subplot(4, 2, 8);
drawSubplot(x,y, 'Seq_I');
xlabel('Номер кадра');
%%
%%