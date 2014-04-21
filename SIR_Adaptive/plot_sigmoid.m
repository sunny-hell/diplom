d= [0:0.01:1];
fun = @(x) exp(-x.^2);
ERF_COEFF = 2/sqrt(pi);
sigmoid =zeros(size(d));
for i=1:size(sigmoid,2)
    sigmoid(i) = (1+ERF_COEFF*integral(fun, 0, 8*(d(i)-0.5)))/2;
end
plot(d, sigmoid, 'linewidth', 2);
grid on
