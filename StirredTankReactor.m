%% Configuração do número de entradas e saídas %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Número de saídas
n = 2;
% Número de entradas
m = 2;

%% Atraso %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = zeros(n,m);
dmin = min(d,[],2);

%% Formação da matriz polinomial B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if max(dmin) ~= 0
    B0 = [ 0.0419517556736025  0.475812909820202; 0.0582354664157513  0.144513027342894];
    B1 = [-0.0379595182857778 -0.455851722881079;-0.0540275746405194 -0.136097243792429];
    B = {B0,B1};
else    
    B0 = [ 0.0419517556736025  0.475812909820202; 0.0582354664157513  0.144513027342894];
    B1 = [-0.0379595182857778 -0.455851722881079;-0.0540275746405194 -0.136097243792429];
    B = {B0,B1};
end
nb = maxOrders(B,n,m);
Bd = delayingB(B,nb,d,n,m);
nbd = length(Bd)-1;

%% Formação da matriz polinomial A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = eye(n,n);
A1 = [-1.86288566236236 0;0 -1.8695080199128];
A2 = [ 0.866877899750182 0;0  0.873715911688034];
A = {I,A1,A2};
na = length(A)-1;
Asim = cell2mat(A(2:end));

%%  Configuração dos parâmetros GPC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Horizonte de controle
Nu = 2;

% Horizonte de Predição
% N1 = d+1;
N2 = 3;
% Predição das restrições 
    Nur = Nu;
    N2r = N2;
%     Nur = 1;
%     N2r = 2;

R  = eye(n*N2,n*N2);
Q  = 0.05*eye(m*Nu,m*Nu);

DUmax = [0.2;0.2];
DUmin = -DUmax;
Umax = [0.3;0.3];
Umin = -Umax;
Ymax = [0.6;0.4];
Ymin = [0;0];
cnstrMatrix = {DUmax DUmin Umax Umin Ymax Ymin};

%% Configuração da simulação %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simTime = 3;
T = 0.03;
vectorTime = 0:T:simTime-T;
samples = simTime/T;

% Vetor de referência
setPoint1 = [0.5 0.4];
setPoint2 = 0.3;

Ref1 = [setPoint1(1)*ones(1,samples/2) setPoint1(2)*ones(1,samples/2)];
Ref2 = [setPoint2*ones(1,samples)];
Ref = [Ref1;Ref2];

alpha = 0;

planta = "STR";
txtXLabel = 'Tempo (min)';
legendY = {'y'};
legendU = {'u'};
legendDU = {'\Delta u'};