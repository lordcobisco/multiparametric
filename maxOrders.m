function orders = maxOrders(B,n,m)
    if nargin < 3
        tam = length(B);
        trimmed = zeros(n,1);
        orders = (tam-1)*ones(n,1);

        while (sum(trimmed) ~= n && tam > 1)
            toTrim = isRowZero(B{tam});
            for i = 1:n
                if (~trimmed(i))
                    trimmed(i) = 1 - toTrim(i);
                    orders(i) = orders(i) - toTrim(i);
                end
            end
            tam = tam - 1;
        end
    else
        tam = length(B);
        trimmed = zeros(n,m);
        orders = (tam-1)*ones(n,m);

        while (sum(sum(trimmed)) ~= n*m && tam > 1)
            toTrim = isZero(B{tam});
            for i = 1:n
                for j = 1:m
                    if (~trimmed(i,j))
                        trimmed(i,j) = 1 - toTrim(i,j);
                        orders(i,j) = orders(i,j) - toTrim(i,j);
                    end
                end
            end
            tam = tam - 1;
        end
    end
end        