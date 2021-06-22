function Bd = delayingB(B,ordersB,d,n,m)
    % B       - Componentes da matriz polinomial B
    % ordersB - Ordem m�xima dos polin�mios de entrada para cada sa�da
    % d       - atrasos para cada uma das entradas
    % n       - N�mero de sa�das do sistema
    % m       - N�mero de entradas do sistema
    
    ordersBd = d+ordersB;
    totalLength = max(max(ordersBd))+1;

    Bdaux = zeros(n,m*totalLength);
    Bd = mat2cell (Bdaux,n,m*ones(1,totalLength));

    if (size(d,2) == m)
        for i = 1:n
            for j = 1:m
                for k = ordersBd(i,j)+1:-1:ordersBd(i,j)+1-ordersB(i,j)
                    Bd{k}(i,j) = B{k-d(i,j)}(i,j);
                end
            end
        end
    else
        for i = 1:n
            for k = ordersBd(i)+1:-1:ordersBd(i)+1-ordersB(i)
                for j = 1:m
                    Bd{k}(i,j) = B{k-d(i)}(i,j);
                end
            end
        end
    end
end