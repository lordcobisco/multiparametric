%% Configuração do número de entradas e saídas %%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Número de saídas
n = 3;
% Número de entradas
m = 3;

%% Atraso %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d = [6 7 6;4 3 3;5 5 0];
% d = [6 6 6;3 3 3;0 0 0];
% d = zeros(n,m);
dmin = min(d,[],2);

%% Formação da matriz polinomial B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if max(dmin) ~= 0
    B0 = [ 0.080195373107641 0.114152636494037 0.116431800956279; 0.211344922968978 0.187523905242926 0.170361607004505; 0.499994375776644 0.196411379694184 1.36686430848653];
    B1 = [ 0.156160092317064 -0.105376164730778 0.22672131921589; -0.185889476096203 -0.161408888131563 0.169622150990972; -0.86161953361711 -0.145430985673746 -2.45891610436285];
    B2 = [ -0.216273708000314 0 -0.313997383467111; -0.194796983659118 -0.174914066600208 -0.756653387215; 0.369873643483602 -0.177352305749235 1.10561095035824];
    B3 = [ 0 0 0; 0.171884860704845 0.151498087116791 0.419925461323114; 0 0.134695726007968 0];
    B = {B0,B1,B2,B3};
else    
    B0 = [ 0.311378797134125 0.114152636494037 0.452075883246582; 0.414402892976033 0.368900045619147 0.656621815551879; 0.499994375776644 0.3840948340324 1.36686430848653];
    B1 = [ -0.291297039709714 -0.105376164730778 -0.422920146541519; -0.762644044703208 -0.674332227084906 -1.22041262630205; -0.86161953361711 -0.651426285734461 -2.45891610436285];
    B2 = [ 0 0 0; 0.350784475645787 0.308131219093683 0.567046642853784; 0.369873643483602 0.27565526598126 1.10561095035824];
    
    B = {B0,B1,B2};
end
nb = maxOrders(B,n,m);
Bd = delayingB(B,nb,d,n,m);
nbd = length(Bd)-1;

%% Formação da matriz polinomial A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = eye(n,n);
A1 = [-1.85862333141825 0 0; 0 -2.76346074945421 0; 0 0 -2.6091044841424];
A2 = [ 0.863581790041564 0 0; 0 2.54533372634345 0; 0 0 2.26629727078609];
A3 = [ 0 0 0; 0 -0.781401117164081 0; 0 0 -0.655309570743428];
A = {I,A1,A2,A3};
na = length(A)-1;
Asim = cell2mat(A(2:end));

%%  Configuração dos parâmetros GPC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Horizonte de controle
% Nu = 5; %- Original
Nu = 1; %- Andre
% Nu = 2; %- Adequado com N2 = 7 (Leva muito tempo ainda...)  

% Horizonte de Predição
% N1 = d+1;
% N2 = 30; %- Original;
% N2 = 12; %- Andre
N2 = 9;   

% Predição das restrições 
    Nur = 1;
%     N2r = 2; %- Andre
    % N2r = 6; %- Adequado com Nu = 2 (Leva muito tempo ainda...)
%     N2r = 4; %- Daniel
    N2r = 7; %- Daniel

R = 2*eye(n*N2,n*N2);
Q  = 1*eye(m*Nu,m*Nu);

%% Configuração das Restrições para a Coluna de Destilação    
% DUmax = [0.1;0.02;0];
% DUmin = [-0.3;-0.2;-0.1];
% Umax = [0.4;0.1;0.1];
% Umin = [-0.3;-0.2;-0.1];
% Ymax = [0.5;0.3;0.1];
% Ymin = [0;0;0];

% DUmax = [0.4;0.1;0.1];
% DUmin = [-0.4;-0.1;-0.1];
% Umax = [0.4;0.2;0.2];
% Umin = [-0.4;-0.2;-0.2];
% Ymax = [0.525;0.33;0.25];
% Ymin = [0;0;0];

DUmax = [2;2;2];
DUmin = -DUmax;
Umax = [0.5;0.5;0.5];
Umin = -Umax;
Ymax = [0.5;0.5;0.5];
Ymin = [0;0;0];
cnstrMatrix = {DUmax DUmin Umax Umin Ymax Ymin};

%% Configuração da simulação %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
simTime = 800;
T = 4;
vectorTime = 0:T:simTime;
samples = simTime/T+1;

% Vetor de referência
setPoint1 = [0.5 0.4];
setPoint2 = 0.3;
setPoint3 = 0.1;

Ref1 = [setPoint1(1)*ones(1,floor(samples/2)) setPoint1(2)*ones(1,ceil(samples/2))];
Ref2 = [setPoint2*ones(1,samples)];
Ref3 = [setPoint3*ones(1,samples)];
Ref = [Ref1;Ref2;Ref3];

alpha = 0;

planta = "DistillationColumn";
txtXLabel = 'Tempo (min)';
legendY = {'Composição final do topo',...
           'Composição final da lateral',...
           'Temperatura de refluxo do fundo'};
legendU = {'Top draw',...
           'Side draw',...
           'Bottom reflux duties'};