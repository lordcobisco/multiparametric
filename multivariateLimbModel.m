%% Configura��o do n�mero de entradas e sa�das %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% N�mero de sa�das
nOutputs = 2; %O sistema a ser controlado vai levar em considera��o os �ngulos 
n = nOutputs;
       %pitch e roll em princ�pio
% N�mero de entradas
nInputs = 2; %s�o 4 m�sculos que ser�o controlados
m = nInputs;

%% Atraso %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%d = [6 7 6;4 3 3;5 5 0];
% d = [6 6 6;3 3 3;0 0 0];
delay = zeros(nOutputs,nInputs);
%dmin = min(d,[],2);

%% From Transfer function

% clear Gs;
% s = tf('s');
% Gs(1,1) = 12.4780077954386/(s^2+0.990366468244999*s+12.4769771866699);
% Gs(1,2) = 12.4780077954386/(s^2+0.990366468244999*s+12.4769771866699);
% Gs(2,3) = 12.4780077954386/(s^2+0.990366468244999*s+12.4769771866699);
% Gs(2,4) = 12.4780077954386/(s^2+0.990366468244999*s+12.4769771866699);
% Gz = c2d(Gs,0.1);

% clear Gs;
z = tf('z',0.01);
Gz(1,1) = (0.00803353*z -        0.00264657 )/(z^2 -        1.87085282*z +        0.87237244);
Gz(1,2) = (0.00000566*z +        0.00000138)/(z^2 -        1.87085282*z +        0.87237244);
Gz(2,1) = (0.00009861*z -        0.00040082)/(z^2 -        1.91759968*z +        0.87850773);
Gz(2,2) = (0.00164743*z -        0.00060953)/(z^2 -        1.91759968*z +        0.87850773);


[Num, Den] = tfdata(Gz,'v');
[B,A] = createModel(Num,Den,delay,nOutputs,nInputs);

nb = maxOrders(B,n,m);
Bd = delayingB(B,nb,delay,n,m);
nbd = length(Bd)-1;

na = length(A)-1;
Asim = cell2mat(A(2:end));

%%  Configura��o dos par�metros GPC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Horizonte de controle
Nu = 1;

% Horizonte de Predi��o
% N1 = d+1;
N2 = 10;

% Predi��o das restri��es 
    Nur = 1;
    N2r = 5;

R = 100*eye(nOutputs*N2,nOutputs*N2);
% R(1:2:n*N2,:) = .2*R(1:2:n*N2,:);
% R(2:2:n*N2,:) = 0.8*R(2:2:n*N2,:);
Q  = 1*eye(nInputs*Nu,nInputs*Nu);

%% Configura��o das Restri��es para a Coluna de Destila��o    
% DUmax = [0.1;0.02;0];
% DUmin = [-0.3;-0.2;-0.1];
% Umax = [0.4;0.1;0.1];
% Umin = [-0.3;-0.2;-0.1];
% Ymax = [0.5;0.3;0.1];
% Ymin = [0;0;0];

DUmax = [100;100];
DUmin = -DUmax;
Umax = [1000;1000];
Umin = -Umax;
Ymax = [10;10];
Ymin = -Ymax;
cnstrMatrix = {DUmax DUmin Umax Umin Ymax Ymin};

%% Configura��o da simula��o %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freq = pi;
T = freq/300;
simTime = 5;
%T = 0.01;
vectorTime = 0:T:simTime;
t = vectorTime;
samples = round(simTime/T+1);

% Vetor de refer�ncia

% setPoint1 = [0.5, 0.7];
% setPoint2 = 0.3;

% Ref1 = [setPoint1(1)*ones(1,floor(samples/2)) setPoint1(2)*ones(1,ceil(samples/2))];
% Ref2 = setPoint2*ones(1,samples);
Ref1 = 0.3*sin(freq*t)+0.4*sin(freq*t*2)+0.2*sin(freq*t*4);%[0.5 0.4];
Ref2 = 0.3*sin(freq*t)+0.4*sin(freq*t*2)+0.2*sin(freq*t*4);%0.3;
Ref = [Ref1;Ref2];

alpha = 0;

planta = 'multiLimb';
txtXLabel = 'Tempo (min)';
legendY = {'Composi��o final do topo',...
           'Composi��o final da lateral',...
           'Temperatura de refluxo do fundo'};
legendU = {'Top draw',...
           'Side draw',...
           'Bottom reflux duties'};