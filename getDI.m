function di = getDI(v)
    m = mean(v);
    N = size(v,2);
    qSum = 0;
    for i=1:N
        qSum = qSum + (v(i)-m).^2;
    end
    qSum = qSum/(N-1);
 %   disp(qSum);
    di = 1.96*sqrt(qSum/N);
end