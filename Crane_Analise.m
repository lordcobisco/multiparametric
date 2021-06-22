%% PARÂMETROS A SEREM CONSIDERADOS NO GANTRY CRANE SYSTEM (GCS)
m1 = 2.5;       % payload mass
m2 = 2.0;       % trolley mass
l = 0.6;        % cable length
g = 9.81;       % gravidade

damp = 0.001;
R = 2.6;
Kt = 0.007;
Ke = 0.007;
rp = 0.02;
r = 0.15;

Amt = R*rp/(Kt*r)*(m1+m2);
Bmt = Ke*r/rp + damp*R*rp/(Kt*r);
Cmt = m1*l*R*rp/(Kt*r);

X = tf([l 0 g],[(Amt*l-Cmt) Bmt*l Amt*g Bmt*g 0]);
Th = tf([-1 0],[(Amt*l-Cmt) Bmt*l Amt*g Bmt*g]);

GCrane = [X;Th];

T = 0.1;
Xd = c2d(GCrane,T);
[N,D] = tfdata(Xd,'v');

for i = 1:length(N)
    N{i} = N{i}(2:end);
end


% 
% Thd = c2d(Th,T);
% [NTh,DTh] = tfdata(Thd,'v');


% m1 = 20;        % payload mass
% m2 = 18.3;      % trolley mass
% l = 10;         % cable length
% g = 9.81;       % gravidade

%% State-space - Artigo do Jaafar (Não foi usado)
% x1 = x_pt
% x2 = x_2pt
% x3 = theta_pt
% x4 = theta_2ptNxt

% A = [0 1          0         0;
%      0 0      g*m1/m2       0;
%      0 0          0         1;
%      0 0 -g*(m1+m2)/(m2*l)  0];
%  
% B = [0; 1/m2; 0; -1/(m2*l)];
% 
% Cxt = [1 0 1 0];  % y = x + theta
% C = [0 0 1 0];    % y = theta
% 
% D = 0;

% Transfer Function
% [Nxt,Dxt] = ss2tf(A,B,Cxt,D);
% Gxt = tf(Nxt,Dxt);
% [N,D] = ss2tf(A,B,C,D);
% G = tf(N,D);
% T = 0.01;
% Gd = c2d(G,T);
% [Nd,Dd] = tfdata(Gd,'v');

%% SIM

% simTime = 10;
% vectorTime = 0:T:simTime;
% u = zeros(size(vectorTime));
% u(1:11) = 1;
% 
% y = lsim(G,u,vectorTime);
% yd = lsim(Gd,u,vectorTime);
% sys = ss(A,B,C,0);
% yss = lsim(sys,u,vectorTime);
% 
% % plot(vectorTime,y,vectorTime,yd)
% plot(vectorTime,yss)
% 
% %% LQR
% 
% Q = [0.01   0   0.6   0;
%        0   20    0    0;
%       0.6   0   0.8   0;
%        0    0    0   9.5];
% R = [0.1];
% 
% K_lqr = lqr(A,B,Q,R);
% N_lqr = 0.3161;