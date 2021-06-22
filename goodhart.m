function goodhartValue = goodhart(X,erro,u)
    alfa1 = 0.2; 
    alfa2 = 0.3;
    alfa3 = 0.5;
    
    epsilon1 = sum(u)/X;
    epsilon2 = sum((u-epsilon1).^2)/X;
    epsilon3 = sum(abs(erro))/X;
    
    goodhartValue = alfa1*epsilon1 + alfa2*epsilon2 + alfa3*epsilon3;