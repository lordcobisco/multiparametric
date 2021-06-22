function t = myCellToeplitz(c,r)

c = c(:)';
r = r(:)';

p = [r(end:-1:2) c];

nc = numel(c);
nr = numel(r);

n = size(c{1,1},1);
m = size(c{1,1},2);

taux = zeros(n*nc,m*nr);
t = mat2cell(taux,n*ones(1,nc),m*ones(1,nr));

for i = 1:nc
    for j = 1:nr
        t(i,j) = p(i-j+nr);
    end
end
    