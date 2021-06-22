Crane_Analise

%% Configura��o do n�mero de entradas e sa�das %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N�mero de sa�das
n = 2;
% N�mero de entradas
m = 1;

%% Atraso %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = zeros(n,m);

%% Forma��o das matrize polinomiais A e B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[Bd, A] = createModel(N,D,d,n,m);
nbd = length(Bd)-1;
na = length(A)-1;
Asim = cell2mat(A(2:end));

%%  Configura��o dos par�metros GPC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Andre
% Nu = 1;
% N2 = 46;
%     % Predi��o das restri��es 
%     Nur = 1;
%     N2r = 1;
% R = eye(n*N2,n*N2);
% R(1:2:n*N2,:) = 2*R(1:2:n*N2,:);
% R(2:2:n*N2,:) = 200*R(2:2:n*N2,:);
% Q  = 5e-4*eye(m*Nu,m*Nu);

% Daniel
% Nu = 1;
% N2 = 44;
%     % Predi��o das restri��es 
%     Nur = 1;
%     N2r = 15;
% R = eye(n*N2,n*N2);
% R(1:2:n*N2,:) = 2*R(1:2:n*N2,:);
% R(2:2:n*N2,:) = 400*R(2:2:n*N2,:);
% Q  = 5e-4*eye(m*Nu,m*Nu);


% Escolhido para o artigo Multiparametric
Nu = 2;
N2 = 60;
    % Predi��o das restri��es 
    Nur = 1;
    N2r = 10;
R = eye(n*N2,n*N2);
R(1:2:n*N2,:) = 0.6*R(1:2:n*N2,:);
R(2:2:n*N2,:) = 150*R(2:2:n*N2,:);
Q  = 5e-4*eye(m*Nu,m*Nu);

% Teste
% Nu = 2;
% N2 = 48;
%     % Predi��o das restri��es 
%     Nur = 1;
%     N2r = 12;
% R = eye(n*N2,n*N2);
% R(1:2:n*N2,:) = 0.65*R(1:2:n*N2,:);
% R(2:2:n*N2,:) = 80*R(2:2:n*N2,:);
% Q  = 2e-4*eye(m*Nu,m*Nu);

%% Configura��o das Restri��es para o Caso SISO      

% Andre
DUmax = 0.7;
DUmin = -DUmax;
Umax = 5;
Umin = -5;
Ymax = [0.8;0.0033];
Ymin = [0;-0.0033];
cnstrMatrix = {DUmax DUmin Umax Umin Ymax Ymin};

% Escolhido
DUmax = 0.5;
DUmin = -DUmax;
Umax = 5;
Umin = -5;
Ymax = [0.8;0.0029];
Ymin = [0;-Ymax(2)];
cnstrMatrix = {DUmax DUmin Umax Umin Ymax Ymin};

% Teste
% DUmax = 0.9;
% DUmin = -DUmax;
% Umax = 5;
% Umin = -5;
% Ymax = [0.8;0.0025];
% Ymin = [0;-Ymax(2)];
% cnstrMatrix = {DUmax DUmin Umax Umin Ymax Ymin};

%% Configura��o da simula��o %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simTime = 80;
% T = 0.1;
vectorTime = 0:T:simTime;
samples = simTime/T+1;

% Vetor de refer�ncia
setPoint1 = 0.77;
setPoint2 = 0;
Ref1 = setPoint1*ones(1,samples);
Ref2 = setPoint2*ones(1,samples);
Ref = [Ref1;Ref2];

alpha = 0;

planta = 'Crane';
txtXLabel = 'Tempo (seg)';
legendY = {'y'};
legendU = {'u'};
legendDU = {'\Delta u'};

% runSimulations