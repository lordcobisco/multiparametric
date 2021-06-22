function [goodHart,MSE,IE,IAE,ISE,ITAE,ITSE] = calcIndexes(erro,U,vectorTime)

samples = length(vectorTime);
goodHart = goodhart(samples,erro,U);
MSE = sum(erro.^2)/samples;
IE = sum(erro);
IAE = sum(abs(erro));
ISE = sum(erro.^2);
ITAE = zeros(1,samples);
ITSE = zeros(1,samples);
for k = 1:samples
    ITAE(k) = vectorTime(k)*abs(erro(k));
    ITSE(k) = vectorTime(k)*erro(k)^2;
end
ITAE = sum(ITAE);
ITSE = sum(ITSE);