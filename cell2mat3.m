function mat3 = cell2mat3(C,m)
    lin = size(C,2);
    for i = 1:lin
        mat3(:,:,i) = C{1,i}(1:m,:);
    end
end