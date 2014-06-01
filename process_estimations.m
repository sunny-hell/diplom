f = fopen('results\compare\estimation_SeqF_adaptive_update_20.txt');
res = fscanf(f, '%f %d %f %f', [4 inf])';
fclose(f);
%disp(res);
lostFrames = ones(20,1)*947-res(:,2)
numOfLostSituations = sum(lostFrames > 0)
if numOfLostSituations > 0
    meanT = sum(res(:,4)/numOfLostSituations)
else
    disp('no meanT');
end
means = mean(res(:, 1:4),1)
	