function [F,G_,G,K,tTuningUGPC] = initMIMOgpc(A,B,N2,Nu,R,Q)

% Número de saídas
n = size(B{1,1},1);
% Número de entradas
m = size(B{1,1},2);
% Identidade I(nxn);
I = eye(n);

% Graus dos polinomios A e B
nb = length(B)-1;
na = length(A)-1;

% Montar o polinominio Atil(A_): A_ = (1-q^-1)*A
na_ = na+1;
% Para auxiliar na implementação em Java em que será necessário criar o
% objeto antes de atribuir valores.
 
A_{1,na_+1} = -A{1,na_};

aux = zeros(n,n*(na_+1));
aux1A_ = mat2cell(aux,n,n*ones(1,na_+1));
aux2A_ = mat2cell(aux,n,n*ones(1,na_+1));
for i = 1:na_
	aux1A_(1,i) = A(1,i);
    aux2A_(1,i+1) = A(1,i);
    A_{1,i} = aux1A_{1,i}-aux2A_{1,i};
end

%-----------<Montar F e E da Eq Diofantina>---------------------------
% Polinomio F  é uma matriz N2*na_
Faux = zeros(n*N2,n*na_);
F = mat2cell(Faux,n*ones(1,N2),n*ones(1,na_));
for j=1:na_
    F{1,j} = -A_{j+1};
end

% Polinomio E é uma matriz 1*N2
Eaux = zeros(n,n*N2);
E = mat2cell(Eaux,n,n*ones(1,N2));
E{1}= I;

%-----------<Montar a matriz G_ (parte da resposta livre) e-----------
%------------montar a matriz g (para a resposta ao degrau)>-----------

% g é uma matriz na*N2 usando o Polinomio E e Matriz G_
gaux = zeros(n,m*N2);
g = mat2cell(gaux,n,m*ones(1,N2));
g{1} = E{1}*B{1};% h=E(q^-1)*B(q^-1)

if (nb < 1)
    G_aux = zeros(n*N2,m);
    G_ = mat2cell(G_aux,n*ones(1,N2),m);
else
    G_aux = zeros(n*N2,m*nb);
    G_ = mat2cell(G_aux,n*ones(1,N2),m*ones(1,nb));
end
for j = 1:nb
    G_{1,j} = B{j+1};
end

for i=2:N2
    for j=1:na
        F{i,j}=F{i-1,j+1}-A_{j+1}*F{i-1,1}; 
    end;  
    F{i,na_}=-A_{na_+1}*F{i-1,1}; 
    
    E{i} = F{i-1,1};

    if (nb ~= 0)
        for j=1:nb-1 
            G_{i,j}=E{i}*B{j+1}+G_{i-1,j+1}; 
        end; 
        G_{i,nb}=E{i}*B{nb+1};
    end
    g{i}=E{i}*B{1}+G_{i-1,1};
end

g1 = mat2cell(zeros(n*Nu,m),n*ones(1,Nu),m);
g1(1) = g(1);
%Montar a matriz G (parte da resposta forçada)
G = myCellToeplitz(g(1:N2),g1);
%---------------------------------------------------------------------

%---<Montar a matriz K com ponderação Lambda>------------------------
G = cell2mat(G);

tstart = tic;
GtG = G'*R*G;
% Garantindo simetria
if norm(GtG-GtG',inf) > eps
    GtG = (GtG+GtG')*0.5;
end
k = (GtG+Q)\(G'*R); % cálculo de parte da lei de controle: inv(GtG+Q)*G'*R
K = k(1:m,:); % Princípio do horizonte móvel somente a 1º linha é considerada.
tTuningUGPC = toc(tstart);

% Converte F e G_ de volta para matrizes
F = cell2mat(F);
G_ = cell2mat(G_);