% Crane
DistillationColumn

%% Inicialização do GPC multivariável %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[F,G_,G,K] = initMIMOgpc(A,Bd,N2,Nu,R,Q);

Bd = cell2mat(Bd);

%% Simulação %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Habilitando restrições
restricaoDU = 1;
restricaoU = 1;
restricaoY = 1;
withCnstr = [restricaoDU restricaoU restricaoY];

H = 2*(G'*R*G+Q);

    % Make sure it is symmetric
    if norm(H-H',inf) > eps || ~issymmetric(H) 
        H = (H+H')*0.5;
    end

    Restr = [];
    c = [];
    E = [];
%     RDu = [eye(m*Nu); -eye(m*Nu)];
%     cDu = [mountCstrMatrix(DUmax,m,Nu);mountCstrMatrix(-DUmin,m,Nu)];
    RDu = [eye(m*Nur,m*Nu); -eye(m*Nur,m*Nu)];
    cDu = [mountCstrMatrix(DUmax,m,Nur);mountCstrMatrix(-DUmin,m,Nur)];
%     RU = [auxMatrixCstr(1,0,m,Nu);auxMatrixCstr(-1,0,m,Nu)];   
%     cU = [mountCstrMatrix(Umax,m,Nu);...
%           mountCstrMatrix(-Umin,m,Nu)];
    RU = [auxMatrixCstr(1,0,m,Nu,Nur);auxMatrixCstr(-1,0,m,Nu,Nur)];   
    cU = [mountCstrMatrix(Umax,m,Nur);...
          mountCstrMatrix(-Umin,m,Nur)];
%     RY = [G;-G];
%     cY = [mountCstrMatrix(Ymax,n,N2); mountCstrMatrix(-Ymin,n,N2)];
    RY = [G(1:n*N2r,1:Nu);-G(1:n*N2r,1:Nu)];
    cY = [mountCstrMatrix(Ymax,n,N2r); mountCstrMatrix(-Ymin,n,N2r)];
%     RY = [G(1,1:end);-G(1,1:end)];    
%     cY = [Ymax; -Ymin]
    if (restricaoDU)
        Restr = [Restr; RDu];
        c = [c; cDu];
%         E = zeros(2*m*Nu,2*n*N2+m*Nu);
        E = zeros(2*m*Nur,1+size(G_,2)+size(F,2)+n*N2);
    end
    if (restricaoU)
        Restr = [Restr; RU];
        c = [c; cU];
%         E =[E; zeros(m*Nu,n*N2) -eye(m*Nu,m*Nu) zeros(m*Nu,n*N2);zeros(m*Nu,n*N2) eye(m*Nu,m*Nu) zeros(m*Nu,n*N2)];
        E =[E; -ones(m*Nur,1) zeros(m*Nur,size(G_,2)) zeros(m*Nur,size(F,2)) zeros(m*Nur,n*N2);ones(m*Nur,1) zeros(m*Nur,size(G_,2)) zeros(m*Nur,size(F,2)) zeros(m*Nur,n*N2)];
%         E =[E; zeros(Nu,N2) -eye(Nu,Nu) zeros(Nu,1);zeros(Nu,N2) eye(Nu,Nu) zeros(Nu,1)];
    end
    if (restricaoY)
        Restr = [Restr; RY];
        c = [c; cY];
%         E = [E; zeros(n*N2,n*N2+m*Nu) -eye(n*N2,n*N2);zeros(n*N2,n*N2+m*Nu) eye(n*N2,n*N2)];
%         RestrY = [eye(n*N2r,n*N2r) zeros(n*N2r,n*(N2-N2r)); zeros(n*(N2-N2r),n*N2)];
%         E = [E; zeros(n*N2,n*N2+m*Nu) -RestrY;zeros(n*N2,n*N2+m*Nu) RestrY];
        E = [E; zeros(n*N2r,1) -G_ -F zeros(n*N2r,n*N2);zeros(n*N2r,1) G_ F zeros(n*N2r,n*N2)];
%         E = [E; zeros(1,Nu+N2) -1;zeros(1,Nu+N2) 1]; 
    end

tic    
[Pn,Fi,Gi,details] =multparametric(H,G,G_,F,R,n,m,Restr,c,E,Nu,Nur,N2,N2r);
toc
clear online_MPT
load('mptResult.mat')
% load('mptResultMenor.mat')

% Vetor de saída
Y = zeros(n,samples);
YTh = zeros(n,samples);

% Vetor do sinal de controle
U = 0*ones(m,samples);

% Vetor da variação do sinal de controle
DU = zeros(m,samples);

% Inicialização dos vetores
r = zeros(n*N2,1);
w = zeros(n*N2,1);

%%
maxTime = 0;
minTime = Inf;
% uP = 2;
% uPert = zeros(2,1);

tic;
for k = 1:samples
    % Simulando Planta
    
    % Displacement X
    usim = mountVectorU(U,nbd,k,0);
    ysim = mountVectorY(Y,na,k,0);
    Y(:,k) = -Asim*ysim+Bd*usim;
    
    % Adicionando perturbação
%     if (k < 12)
%         Y(:,k) = -Asim*ysim+Bd*(usim+uPert);
%         uPert = [uP; uPert(1)];
%     else
%         uPert = [0; uPert(1)];
%         Y(:,k) = -Asim*ysim+Bd*(usim+uPert);
%     end
    
    %----------------------------------------------------------------------
    % MIMO GPC - Cálculo da variação do sinal de controle
%     tstart = tic;
    [du,xMp] = MultconstrainedMGPC(F,G_,Y,na,U,nbd,Ref,r,w,alpha,N2,N2r,Nu,Nur,n,m,k,Pn,Fi,Gi);
%     cMp = c + E*xMp;
%     [du,cQP] = constrainedMGPC(K,F,G,G_,Y,na,U,nbd,Ref,r,w,alpha,N2,Nu,R,Q,n,m,withCnstr,cnstrMatrix,k);
%     telapsed = toc(tstart);
%     maxTime = max(telapsed,maxTime);
%     minTime = min(telapsed,minTime);
    
    DU(:,k) = du;
    %----------------------------------------------------------------------
    % Lei de controle do GPC
    if (k > 1) % tratamento para o indice 0 no matlab
        U(:,k) = U(:,k-1) + du;
%         if (U(:,k) > Umax)
%             U(:,k) = Umax;
%         elseif (U(:,k) < Umin)
%             U(:,k) = Umin;
%         end
    else
        U(:,k) = du;
%         if (U(:,k) > Umax)
%             U(:,k) = Umax;
%         elseif (U(:,k) < Umin)
%             U(:,k) = Umin;
%         end
    end
end
toc

% showIndices(vectorTime,Ref,Y,U)

%% Plotagem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Cores
colorsRef = [0 0.75 0.75; ... %dark cyan
             0.75 0 0.75; ... %dark magenta
             0.75 0.75 0];    %dark yellow
             
colors = [0 0   1; ... % blue
          0 0.5 0; ... % dark green
          1 0 0];  ... % red

colors = [ 0  0  0;
        .4 .4 .4;
        .7 .7 .7];

plothandle = 1;    
h1 = figure(plothandle); clf(plothandle)
plotConfig(h1);
        hsp(1) = subplot(3,1,1);
        hold all
        hsp(2) = subplot(3,1,2);
        hold all
        hsp(3) = subplot(3,1,3);
        hold all
        hY = zeros(n,1);
        hU = zeros(m,1);
        hDU = zeros(m,1);
        for i = 1:n
            subplot(3,1,1);
                plot(vectorTime,Ref(i,:),'--','Linewidth',2,'Color', colors(i,:));
                hY(i) = plot(vectorTime,Y(i,:),'-','Linewidth',2,'Color', colors(i,:));
%                 hsmax(i) = plot(vectorTime,1.02*Ref(i,:),'r--','Linewidth',2);
%                 hsmin(i) = plot(vectorTime,0.98*Ref(i,:),'r--','Linewidth',2);            
        end
        for i = 1:m
            subplot(3,1,2)
%                 hU(i) = stairs(vectorTime,U(i,:),'Linewidth',2,'Color', colors(i,:));
                hU(i) = plot(vectorTime,U(i,:),'Linewidth',2,'Color', colors(i,:));
            subplot(3,1,3)
%                 hDU(i) = stairs(vectorTime,DU(i,:),'Linewidth',2,'Color', colors(i,:));
                hDU(i) = plot(vectorTime,DU(i,:),'Linewidth',2,'Color', colors(i,:));
        end
	subplot(3,1,1);
        hold off;
        grid on; box off;
        xlabel(txtXLabel);
        ylabel('Saidas');
        sTitle = sprintf('Controle MIMO GPC - %s', controle);
        title(sTitle)
        hLegendY = legend(hY,legendY);
        set(hLegendY,'Box','off');
    subplot(3,1,2)
        hold off
        grid on; box off;
        xlabel(txtXLabel);
        ylabel('u');
        hLegendU = legend(legendU);
        set(hLegendU,'Box','off');
    subplot(3,1,3)
        hold off
        grid on; box off;
        xlabel(txtXLabel);               
        ylabel('\Delta u');
        hLegendDU = legend(legendU);
        set(hLegendDU,'Box','off');
        
    if (strcmp(controle,'Reator Tanque Agitado'))
        axis(hsp(1), [0 simTime 0 0.75])
        axis(hsp(2), [0 simTime -0.01 0.43])
        axis(hsp(3), [0 simTime -0.18 0.32])
    elseif (strcmp(controle,'Coluna de Destilação'))
%         % Plot legendas saída
%         hlegendY1 = legend(hY(1), legendY(1), 'Location', 'NorthWest'); %display legend 1
%         set(hlegendY1,'Box','off','Position', [0.125 0.86 0.24 0.06]);
% %         new_handle = copyobj(hlegendY1,h1);     %copy legend 1 --> retain
%         hlegendY2 = legend(hY(2), legendY(2), 'Location', 'North');     %display legend 2
%         set(hlegendY2,'Box','off', 'Position', [0.38 0.859 0.24 0.06]);
% %         new_handle = copyobj(hlegendY2,h1);     %copy legend 2 --> retain
%         hlegendY3 = legend(hY(3), legendY(3), 'Location', 'NorthEast');
%         set(hlegendY3,'Box','off', 'Position', [0.65 0.866 0.24 0.06]);
%         
%          % Plot legendas sinal controle
%         hlegendU1 = legend(hU(1), legendU(1), 'Location', 'NorthWest'); %display legend 1
%         set(hlegendU1,'Box','off','Position', [0.1361 0.5738 0.1153 0.0405]);
% %         new_handle = copyobj(hlegendU1,h1);     %copy legend 1 --> retain
%         hlegendU2 = legend(hU(2), legendU(2), 'Location', 'North');     %display legend 2
%         set(hlegendU2,'Box','off', 'Position', [0.4582 0.5738 0.1191 0.0405]);
% %         new_handle = copyobj(hlegendU2,h1);     %copy legend 2 --> retain
%         hlegendU3 = legend(hU(3), legendU(3), 'Location', 'NorthEast');
%         set(hlegendU3,'Box','off', 'Position', [0.7073 0.585 0.1921 0.0405]);
%         
%          % Plot legendas variacao do sinal de controle
%         hlegendDU1 = legend(hDU(1), legendU(1), 'Location', 'NorthWest'); %display legend 1
%         set(hlegendDU1,'Box','off','Position', [0.1361 0.2754 0.1153 0.0405]);
% %         new_handle = copyobj(hlegendDU1,h1);     %copy legend 1 --> retain
%         hlegendDU2 = legend(hDU(2), legendU(2), 'Location', 'North');     %display legend 2
%         set(hlegendDU2,'Box','off', 'Position', [0.4582 0.2754 0.1191 0.0405]);
% %         new_handle = copyobj(hlegendDU2,h1);     %copy legend 2 --> retain
%         hlegendDU3 = legend(hDU(3), legendU(3), 'Location', 'NorthEast');
%         set(hlegendDU3,'Box','off', 'Position', [0.7073 0.286 0.1921 0.0405]);
        
%         axis(hsp(1), [0 simTime -0.01 0.71]);
%         axis(hsp(2), [0 simTime -0.21 0.6]);
%         axis(hsp(3), [0 simTime -0.08 0.15]);
    elseif strcmp(controle,'Compressor')
        axis(hsp(1), [0 simTime -0.025 1.5]);
        axis(hsp(2), [0 simTime -1.8 5]);
        axis(hsp(3), [0 simTime -0.32 0.51]);
    elseif strcmp(controle,'Caso SISO') 
        figure(2);
        plot(vectorTime,YTh,'linewidth',2)
        ylim([-0.05 0.05])
        hold all
%         plot(vectorTime,U,'r--','linewidth',2)
%         grid on; box off;
    end
    

    if (0)
        figure(h1)
            set(h1, 'PaperPositionMode', 'auto');
            print -depsc2 planta.eps   
        if (strcmp(controle,'Reator Tanque Agitado'))            
            fixPSlinestyle('planta.eps', 'simStirredTankCnstr.eps');
        elseif(strcmp(controle,'Coluna de Destilação'))
            fixPSlinestyle('planta.eps', 'simDistillationColumnCnstr.eps');
        elseif(strcmp(controle,'Compressor'))
            fixPSlinestyle('planta.eps', 'simCompressorCnstr.eps');
        end
    end