res = dlmread('gt\bobot\Vid_I_person_crossing.txt');
res = res(res(:,4) > 0, :)
S = mean(res(:,4).*res(:,5))