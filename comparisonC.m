%f = fopen('results\VidB.txt');

[x,y] = readFile('results\compare\Vid_C.txt');
subplot(4,1,1);
drawSubplot(x,y,'Q_k');
title('����������� ��������');

%f = fopen('results\compare\VidF_adaptive.txt');
[x,y] = readFile('results\compare\Vid_C_adaptive.txt');
subplot(4,1,2);
drawSubplot(x,y,'Q_k');
title('�������� � ���������� ������� ���������� ������ ��������');

%f = fopen('results\VidF_update.txt');
[x,y] = readFile('results\compare\Vid_C_update.txt');
subplot(4,1,3);
drawSubplot(x,y,'Q_k');
title('�������� � ����������� ��������� �����������');

%f = fopen('results\compare\VidF_adaptive_update.txt');
[x,y] = readFile('results\compare\Vid_C_adaptive_update.txt');
subplot(4,1,4);
drawSubplot(x,y,'Q_k');
title('�������� � ���������� ������� ���������� � ����������� ��������� �����������');
xlabel('����� �����');

