f = fopen('results\Seq_A_nonadaptive.txt');
res = fscanf(f, '%d %f', [2 inf])';
fclose(f);
x = res(:,1);
y = res(:,2);
disp('non adaptive');
M = size(y,1)
Q = sum(y)/M
Msf = sum(y>=0.3)
ysf = sum(y(y>=0.3))/Msf
tst=0;
tend = 0;
tsum = 0; tk = 0;

for i=1:size(y,1)
    if y(i) < 0.3 
        if i == 1
            tst = 1;
            
        else
            if y(i-1) >= 0.3
                tst = i;
                
            end
           
        end
        if i== size(y,1) 
            tsum = tsum + i-tst;
            tk = tk+1;
        end
    else
        if i > 1 && y(i-1) < 0.3
            tsum = tsum + i-tst;
            tk = tk+1;
        end
    end
end
tk
tsum = tsum/tk
subplot(2, 1, 1);
plot(x, y);
yPos = 0.3;
hold on
plot(get(gca,'xlim'), [yPos yPos], 'r'); % Adapts to x limits of current axes
hold off
ylabel('Q_k');

title('Алгоритм воспроизведения условной плотности');

f = fopen('results\Seq_A_adaptive.txt');
res = fscanf(f, '%d %f', [2 inf])';
fclose(f);
x = res(:,1);
y = res(:,2);
disp('adaptive');
M = size(y,1)
Q = sum(y)/M
Msf = sum(y>=0.3)
ysf = sum(y(y>=0.3))/Msf


tst=0;
tend = 0;
tsum = 0; tk = 0;
for i=1:size(y,1)
    if y(i) < 0.3 
        if i == 1
            tst = 1;
            
        else
            if y(i-1) >= 0.3
                tst = i;
                
            end
        end
    else
        if i > 1 && y(i-1) < 0.3
            tsum = tsum + i-tst;
            tk = tk+1;
        end
    end
end
tsum = tsum/tk
subplot(2, 1, 2);
plot(x, y);

hold on
plot(get(gca,'xlim'), [yPos yPos], 'r'); % Adapts to x limits of current axes
hold off
title('Алгоритм воспроизведения условной плотности с адаптацией стохастической компоненты');
xlabel('Номер кадра');
ylabel('Q_k');


