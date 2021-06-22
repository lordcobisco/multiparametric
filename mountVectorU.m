function vectorU = mountVectorU(U,nb,k,free,Uinit)
    m = size(U,1);
    switch free
        case 0
            if nargin < 5
                Uinit = zeros(m,1);
            end
            vectorU = zeros(m*(nb+1),1);
            for i = 1:nb+1
                for j = m*(i-1)+1:m*i
                    if (k > i)
                        vectorU(j) = U(j-m*(i-1),k-i);
                    else
                        vectorU(j) = Uinit(j-m*(i-1));
                    end
                end
            end
        otherwise
            if nargin < 5
                if nb > 0
                    Uinit = zeros(m*nb,1);
                else
                    Uinit = 0;
                end
            end
            if (nb > 0)
                vectorU = zeros(m*nb,1);
                for i = 1:nb
                    for j = m*(i-1)+1:m*i
                        if (k > i+1)
                            vectorU(j) = U(j-m*(i-1),k-i)-U(j-m*(i-1),k-(i+1));
                        elseif (k > i)
                            vectorU(j) = U(j-m*(i-1),k-i);
                        else
                            vectorU(j) = Uinit(j-m*(i-1));
                        end
                    end
                end
            else
                vectorU = Uinit;
            end
    end
end