function [newSet] = processFrame(I, state, curSet)
    %curSet = ������� ����� ������
    %t_start1 = tic;
    weights = calc_weights_simple(curSet, I, state);
    curSet(:,3) = weights / sum(weights);
    %t_end1 = toc(t_start1);
    %t_start2 = tic;
    newSet = resample(curSet);
    %t_end2 = toc(t_start2);
    %t_start3 = tic;
    newSet = RWM(newSet);
    %t_end3 = toc(t_start3);
   % disp(sprintf('�� ���������� �����: %5.2f ���; �� �����������: %5.2f ���; �� ������������: %5.2f ���.', ...
    %    t_end1, t_end2, t_end3));
        
end
