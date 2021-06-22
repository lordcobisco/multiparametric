function vectorY = mountVectorY(Y,na,k,free,Yinit)
    n = size(Y,1);
    if nargin < 5
        Yinit = zeros(n,1);
    end
    switch free
        case 0
            vectorY = zeros(n*na,1);
            for i = 1:na
                for j = n*(i-1)+1:i*n
                    if (k > i)
                        vectorY(j) = Y(j-n*(i-1),k-i);
                    else
                        vectorY(j) = Yinit(j-n*(i-1));
                    end
                end
            end
        otherwise
            vectorY = zeros(n*(na+1),1);
            for i = 1:na+1
                for j = n*(i-1)+1:i*n
                    if (k > i-1)
                        vectorY(j) = Y(j-n*(i-1),k-(i-1));
                    else
                        vectorY(j) = Yinit(j-n*(i-1));
                    end
                end
            end
    end    
end