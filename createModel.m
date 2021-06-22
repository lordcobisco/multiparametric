function [Bd,A] = createModel(num,den,delay,nOutputs,nInputs)
    tempA = cell(1,nOutputs);
    tempB = cell(nOutputs,nInputs);
       
    maxADegree = 0;
    maxBDegree = 0;
    for i = 1:nOutputs
        numB = cell(1,nInputs);
        denLCM = mylcm(den(i,:));
        maxADegree = max(maxADegree, degree(denLCM));
        tempA{i} = denLCM;
        for j = 1:nInputs
            aux = mytimes({deconv(denLCM,den{i,j}),num{i,j}});
            maxBDegree = max(maxBDegree, degree(aux));
            numB{j} = aux;
        end
        tempB(i,:) = numB;
    end

    A = cell(1, maxADegree+1);
    A{1} = eye(nOutputs, nOutputs);   
    for k = 2:maxADegree+1
        a = zeros(nOutputs,nOutputs);
        for i = 1:nOutputs
            if (k <= degree(tempA{i})+1)
                a(i,i) = tempA{i}(k);
            end
        end
        A{1, k} = a;
    end

    B = cell(1, maxBDegree+1);
    for k = 1:maxBDegree+1
        b = zeros(nOutputs,nInputs);
        for i = 1:nOutputs
            for j = 1:nInputs
                if (k <= degree(tempB{i,j})+1)
                    b(i, j) = tempB{i,j}(k);
                end
            end
        end       
        B{1, k} = b;
    end 
    
    nb = maxOrders(B,nOutputs,nInputs);
    Bd = delayingB(B,nb,delay,nOutputs,nInputs);
end

%%
function d = degree(poly) 
    d = 0;
    n = numel(poly);
    for i = 1:n
        if (poly(i) ~= 0)
            d = n-i;
            break;
        end
    end
end

%%
function lcmPoly = mylcm(p)
    len = length(p);
    lcmPoly = p{1};

    if (len >= 2)
        for i = 2:len
            nextPoly = p{i};
            gcdPoly = mygcd(nextPoly,lcmPoly);
            factorB = deconv(nextPoly,gcdPoly);
            factorA = deconv(lcmPoly,gcdPoly);

            lcmPoly = mytimes({gcdPoly,factorB,factorA});
        end
    end
end

function p = mytimes(poly)
    len = length(poly);
    p = poly{1};
    if (len >= 2)
        for i = 2:len
            p = conv(p,poly{i});
        end
    end
end

function G = mygcd(p1,p2,TOL)
    if(nargin < 3)
        TOL = 1e-7;
    end
    if(length(p1) > length(p2))
        p1_ = p1;
        p2_ = p2;
    else
        p1_ = p2;
        p2_ = p1;
    end

    [Q,R] = deconv(p1_,p2_);
    while (any(abs(R)>TOL)) 
        p1_ = p2_;
        p2_ = adjustResidue(R);
        [Q,R] = deconv(p1_,p2_);
    end
    
    G = p2_;
end

function adjusted = adjustResidue(p)
    j = 1;
    while (p(j) == 0)
        j = j+1;
    end
    adjusted = p(j:end)./p(j);   
end

%%
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

function Bd = delayingB(B,ordersB,d,n,m)
    % B       - Componentes da matriz polinomial B
    % ordersB - Ordem máxima dos polinômios de entrada para cada saída
    % d       - atrasos para cada uma das entradas
    % n       - Número de saídas do sistema
    % m       - Número de entradas do sistema
    
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