a1 = -0.8187; b1 = 0.1813;
N = {b1};
D = {[1 a1]};

T = 0.1;
%% Configuração do número de entradas e saídas %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Número de saídas
n = 1;
% Número de entradas
m = 1;

%% Atraso %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = zeros(n,m);

%% Formação das matrize polinomiais A e B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Bd, A] = createModel(N,D,d,n,m);
nbd = length(Bd)-1;
na = length(A)-1;
Asim = cell2mat(A(2:end));

%%  Configuração dos parâmetros GPC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Escolhido para o artigo Multiparametric
Nu = 2;
N2 = 10;
    % Predição das restrições 
    Nur = Nu;
    N2r = N2;
R = 5*eye(n*N2,n*N2);
Q  = 0.1*eye(m*Nu,m*Nu);

%% Configuração das Restrições para o Caso SISO      
H_SUP = 0.97;
H_INF = 0.4335;
    
DUmax = 1;
DUmin = -1;
Umax = 1;
Umin = 0;
Ymax = H_SUP;
Ymin = H_INF;
cnstrMatrix = {DUmax DUmin Umax Umin Ymax Ymin};

%% Configuração da simulação %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simTime = 300;
% T = 0.1;
vectorTime = 0:T:simTime;
samples = simTime/T+1;

% Vetor de referência
setPoint = [0.45 0.6 0.75 0.9 0.75 0.5 0.45];
setPointChanges = (samples-1)/simTime;
Ref = [];
for i = 1:setPointChanges    
    Ref = [Ref setPoint(mod(i-1,length(setPoint))+1)*ones(1,(samples-1)*T)];
end
Ref(samples) = setPoint(mod(setPointChanges-1,length(setPoint))+1);

alpha = 0;

planta = 'Valve';
txtXLabel = 'Tempo (seg)';
legendY = {'y'};
legendU = {'u'};
legendDU = {'\Delta u'};

runSimulations
