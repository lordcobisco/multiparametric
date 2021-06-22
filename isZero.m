function theZeros = isZero(A)
    [rows,cols] = size(A);
    theZeros = zeros(rows,cols);
    
    for i = 1:rows
        for j = 1:cols
            if A(i,j) == 0
                theZeros(i,j) = 1;
            end
        end
    end
end