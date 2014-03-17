function [newSet] = resample(curSet)
    newSet = zeros(size(curSet));
    Ns = size(curSet, 1);
    c = zeros(Ns, 1);
    for i=2:Ns
        c(i) = c(i-1)+curSet(i,3);
    end
    
    u1 = 1/Ns*rand();
    for j=1:Ns
        i=1;
        u = u1 + (j-1)/Ns;
        while (i < Ns && u > c(i))
            i = i + 1;
        end
        newSet(j, 1:2) = curSet(i, 1:2);
        newSet(j, 3) = 1/Ns;
    end
end
