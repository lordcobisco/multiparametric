function cstrMatrix = mountCstrMatrix(cstr,m,Nu)
cstrMatrix = zeros(m*Nu,1);
for i = 1:Nu
    for j = m*(i-1)+1:m*i
        cstrMatrix(j) = cstr(j-m*(i-1));
    end
end