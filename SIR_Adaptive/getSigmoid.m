function [sigmoid] = getSigmoid(d)
    %d - ���������� �� �����������, ������������ � ������ �����, �� �������
    % �����������
    global ALPHA BETA ERF_COEFF;
    % ALPHA - stepness of the sigmoid function
    % BETA - position of the sigmoid function
    fun = @(x) exp(-x.^2);
    erf = ERF_COEFF * integral(fun, 0, ALPHA*(d-BETA));
    sigmoid = (erf+1)/2;
    
end
