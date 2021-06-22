function [stdLPC,stdLPA, B0] = standardLP(c,A)
    [m,n] = size(A);
    stdLPC = [c; -c; zeros(m,1)];
    stdLPA = [A -A eye(m)];
    newN = size(stdLPA, 2);
    B0 = 2*n+1:newN;


