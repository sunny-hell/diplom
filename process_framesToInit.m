f=fopen('results\framesToInit_movie07_adaptive_100_random.txt');
res = fscanf(f, '%d', [1,inf]);
fclose(f);
disp('adaptive random: ');
disp(mean(res));
di = getDI(res);
disp(di);

f=fopen('results\framesToInit_movie07_adaptive_100_point.txt');
res = fscanf(f, '%d', [1,inf]);
fclose(f);
disp('adaptive point: ');
disp(mean(res));
di = getDI(res);
disp(di);

f=fopen('results\framesToInit_movie07_nonadaptive_100_random.txt');
res = fscanf(f, '%d', [1,inf]);
fclose(f);
disp('nonadaptive random: ');
disp(mean(res));
di = getDI(res);
disp(di);

f=fopen('results\framesToInit_movie07_nonadaptive_100_point.txt');
res = fscanf(f, '%d', [1,inf]);
fclose(f);
disp('nonadaptive point: ');
disp(mean(res));
di = getDI(res);
disp(di);