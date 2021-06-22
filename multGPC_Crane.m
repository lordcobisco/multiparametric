%% Simulação %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        E = zeros(2*m*Nur,1+size(G_,2)+size(F,2)+n);
    end
    if (restricaoU)
        Restr = [Restr; RU];
        c = [c; cU];
%         E =[E; zeros(m*Nu,n*N2) -eye(m*Nu,m*Nu) zeros(m*Nu,n*N2);zeros(m*Nu,n*N2) eye(m*Nu,m*Nu) zeros(m*Nu,n*N2)];
        E =[E; -ones(m*Nur,1) zeros(m*Nur,size(G_,2)) zeros(m*Nur,size(F,2)) zeros(m*Nur,n);ones(m*Nur,1) zeros(m*Nur,size(G_,2)) zeros(m*Nur,size(F,2)) zeros(m*Nur,n)];
%         E =[E; zeros(Nu,N2) -eye(Nu,Nu) zeros(Nu,1);zeros(Nu,N2) eye(Nu,Nu) zeros(Nu,1)];
    end
    if (restricaoY)
        Restr = [Restr; RY];
        c = [c; cY];
%         E = [E; zeros(n*N2,n*N2+m*Nu) -eye(n*N2,n*N2);zeros(n*N2,n*N2+m*Nu) eye(n*N2,n*N2)];
%         RestrY = [eye(n*N2r,n*N2r) zeros(n*N2r,n*(N2-N2r)); zeros(n*(N2-N2r),n*N2)];
%         E = [E; zeros(n*N2,n*N2+m*Nu) -RestrY;zeros(n*N2,n*N2+m*Nu) RestrY];
        E = [E; zeros(n*N2r,1) -G_ -F zeros(n*N2r,n);zeros(n*N2r,1) G_ F zeros(n*N2r,n)];
%         E = [E; zeros(1,Nu+N2) -1;zeros(1,Nu+N2) 1]; 
    end

% if (toSave)
%     tstart = tic;
    [Pn,Fi,Gi,details] = multparametric(H,G,G_,F,R,n,m,Restr,c,E,Nu,Nur,N2,N2r);
%     tTuningMult = toc(tstart);
% end
clear online_MPT
load('mptResult.mat')
% load('mptResultNr2_13.mat')
    
% Vetor de saída
Y = zeros(n,samples);

% Vetor do sinal de controle
U = 0*ones(m,samples);

% Vetor da variação do sinal de controle
DU = zeros(m,samples);

% Inicialização dos vetores
r = zeros(n*N2,1);
w = zeros(n*N2,1);

%%
tstart = tic;
for k = 1:samples
    % Simulando Planta
    
    % Displacement X
    usim = mountVectorU(U,nbd,k,0);
    ysim = mountVectorY(Y,na,k,0);
    Y(:,k) = -Asim*ysim+Bd*usim;
    
    %----------------------------------------------------------------------
    % MIMO GPC - Cálculo da variação do sinal de controle
    du = MultconstrainedMGPC(F,G_,Y,na,U,nbd,Ref,r,w,alpha,N2,N2r,Nu,Nur,n,m,k,Pn,Fi,Gi);
    DU(:,k) = du;
    %----------------------------------------------------------------------
    % Lei de controle do GPC
    if (k > 1) % tratamento para o indice 0 no matlab
        U(:,k) = U(:,k-1) + du;
    else
        U(:,k) = du;
    end
end
tEGPC = toc(tstart);

%% Plotagem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
controle = 'Explicity GPC';

uUpLim = 1.02*Umax;
uBotLim = 1.02*Umin;

Umaxplot = Umax*ones(1,length(vectorTime));
Uminplot = Umin*ones(1,length(vectorTime));
DUmaxplot = DUmax*ones(1,length(vectorTime));
DUminplot = DUmin*ones(1,length(vectorTime));

plothandle = 13:16;

h(plothandle(1)) = figure(plothandle(1)); clf(plothandle(1))
actualHandle = h(plothandle(1));

plotConfig(actualHandle);
    plot(vectorTime,Ref(1,:),'--','Linewidth',2,'Color', colors(1,:));
    hY = plot(vectorTime,Y(1,:),'-','Linewidth',2,'Color', colors(1,:));
%         hsmax(i) = plot(vectorTime,1.02*Ref(i,:),'r--','Linewidth',2);
%         hsmin(i) = plot(vectorTime,0.98*Ref(i,:),'r--','Linewidth',2);
    grid on; box off;
    xlabel(txtXLabel);
    ylabel(txtYLabel);
    sTitle = sprintf('Crane Control - %s', controle);
    title(sTitle)
%     axis(h(plothandle(1)), [0 simTime 0 0.75])
%     hLegendY = legend(hY,legendY);
%     set(hLegendY,'Box','off');

    if (savePlot)
        figure(actualHandle)
            set(actualHandle,'PaperPositionMode','auto','Units','Inches');
            pos = get(actualHandle,'Position');
            set(actualHandle,'PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
            if(toEPS)
%                 print -depsc2 planta.eps   
%                 fixPSlinestyle('planta.eps', 'xEGPC.eps');  
                print(actualHandle,'xEGPC.eps','-depsc','-r0')
            else                
                print(actualHandle,'xEGPC.pdf','-dpdf','-r0')
            end
    end

h(plothandle(2)) = figure(plothandle(2)); clf(plothandle(2))
actualHandle = h(plothandle(2));

plotConfig(actualHandle);
    hU = stairs(vectorTime,U,'Linewidth',2,'Color', colors(1,:));
%     hU = plot(vectorTime,U(i,:),'Linewidth',2,'Color', colors(i,:));
    grid on; box off;
    xlabel(txtXLabel);
    ylabel(txtULabel);
    sTitle = sprintf('Crane Control - %s', controle);
    title(sTitle)
%     axis([0 simTime 1.1*Umin 1.1*Umax])
%     hLegendU = legend(legendU);
%     set(hLegendU,'Box','off');

    if (savePlot)
        figure(actualHandle)
            set(actualHandle,'PaperPositionMode','auto','Units','Inches');
            pos = get(actualHandle,'Position');
            set(actualHandle,'PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
            set(gca,'FontSize', 28);
            if(toEPS)
%                 print -depsc2 planta.eps   
%                 fixPSlinestyle('planta.eps', 'uEGPC.eps');  
                print(actualHandle,'uEGPC.eps','-depsc','-r0')
            else                
                print(actualHandle,'uEGPC.pdf','-dpdf','-r0')
            end
    end
    
h(plothandle(3)) = figure(plothandle(3)); clf(plothandle(3))
actualHandle = h(plothandle(3));

plotConfig(actualHandle);
    hDU = stairs(vectorTime,DU,'Linewidth',2,'Color', colors(1,:));
%     hDU = plot(vectorTime,DU(i,:),'Linewidth',2,'Color', colors(i,:));
    hold on;
%     hU = plot(vectorTime,U(i,:),'Linewidth',2,'Color', colors(i,:));
%     plot(vectorTime,DUmaxplot,'r--');
%     plot(vectorTime,DUminplot,'r--');
    hold off;
    grid on; box off;
    xlabel(txtXLabel);
    ylabel(txtDULabel);
    sTitle = sprintf('Crane Control - %s', controle);
    title(sTitle)
%     axis([0 simTime 1.1*DUmin 1.1*DUmax])   
%     hLegendU = legend(legendU);
%     set(hLegendU,'Box','off');

    if (savePlot)
        figure(actualHandle)
            set(actualHandle,'PaperPositionMode','auto','Units','Inches');
            pos = get(actualHandle,'Position');
            set(actualHandle,'PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
            set(gca,'FontSize', 28);
            if(toEPS)
%                 print -depsc2 planta.eps   
%                 fixPSlinestyle('planta.eps', 'duEGPC.eps');  
                print(actualHandle,'duEGPC.eps','-depsc','-r0')
            else                
                print(actualHandle,'duEGPC.pdf','-dpdf','-r0')
            end
    end
    
h(plothandle(4)) = figure(plothandle(4)); clf(plothandle(4))
actualHandle = h(plothandle(4));

plotConfig(actualHandle);
    plot(vectorTime,Ref(2,:),'--','Linewidth',2,'Color', colors(1,:));
    plot(vectorTime,Y(2,:),'linewidth',2)    
    grid on; box off;
    xlabel(txtXLabel);
    ylabel(txtYthLabel);
    sTitle = sprintf('Crane Control - %s', controle);
    title(sTitle)
    axis([0 simTime -0.01 0.01])   
%     hLegendU = legend(legendU);
%     set(hLegendU,'Box','off');

    if (savePlot)
        figure(actualHandle)
            set(actualHandle,'PaperPositionMode','auto','Units','Inches');
            pos = get(actualHandle,'Position');
            set(actualHandle,'PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
            if(toEPS)
%                 print -depsc2 planta.eps   
%                 fixPSlinestyle('planta.eps', 'ythEGPC.eps');  
                print(actualHandle,'ythEGPC.eps','-depsc','-r0')
            else                
                print(actualHandle,'ythEGPC.pdf','-dpdf','-r0')
            end
    end
    
%}