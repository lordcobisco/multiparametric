%% Simulação %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H = 2*(G'*R*G+Q);

% Make sure it is symmetric
if norm(H-H',inf) > eps || ~issymmetric(H)
    H = (H+H')*0.5;
end

Restr = [];
c = [];
E = [];

RDu = [eye(m*Nur,m*Nu); -eye(m*Nur,m*Nu)];
cDu = [mountCstrMatrix(DUmax,m,Nur);mountCstrMatrix(-DUmin,m,Nur)];

RU = [auxMatrixCstr(1,0,m,Nu,Nur);auxMatrixCstr(-1,0,m,Nu,Nur)];
cU = [mountCstrMatrix(Umax,m,Nur);mountCstrMatrix(-Umin,m,Nur)];

RY = [G(1:n*N2r,1:m*Nu);-G(1:n*N2r,1:m*Nu)];
cY = [mountCstrMatrix(Ymax,n,N2r); mountCstrMatrix(-Ymin,n,N2r)];
if (restricaoDU)
    Restr = [Restr; RDu];
    c = [c; cDu];
    E = zeros(2*m*Nur,m+size(G_,2)+size(F,2)+n);
end
if (restricaoU)
    Restr = [Restr; RU];
    c = [c; cU];
    E =[E; -auxMatrixCstr(1,1,m,Nur) zeros(m*Nur,size(G_,2)) zeros(m*Nur,size(F,2)) zeros(m*Nur,n);auxMatrixCstr(1,1,m,Nur) zeros(m*Nur,size(G_,2)) zeros(m*Nur,size(F,2)) zeros(m*Nur,n)];
    
end
if (restricaoY)
    Restr = [Restr; RY];
    c = [c; cY];
    E = [E; zeros(n*N2r,m) -G_(1:n*N2r,:) -F(1:n*N2r,:) zeros(n*N2r,n);zeros(n*N2r,m) G_(1:n*N2r,:) F(1:n*N2r,:) zeros(n*N2r,n)];
end

bndA = [eye(m*(nbd+1)+n*(na+2));-eye(m*(nbd+1)+n*(na+2))];
bndb = [Umax; eye_nb*DUmax; eye_na_*Ymax; Ymax;
       -Umin;-eye_nb*DUmin;-eye_na_*Ymin;-Ymin];

if (toOptimize)
    cstart = clock;
    [Pn,Fi,Gi,PnH_Sizes,tOptimizerMult,details] = multparametric(H,G,G_,F,R,n,m,Restr,c,E,Nu,N2,bndA,bndb,planta);
    cstop = clock;
    save("mptResultTime_"+planta+".mat",'tOptimizerMult','cstart','cstop');
end
clear online_MPT
load("mptResult_"+planta+".mat")
if (runMEX)
    codegen isInside -args {Pn,PnH_Sizes,zeros(size(E,2),1)}
end

% Vetor de saída
Y = zeros(n,samples);

% Vetor do sinal de controle
U = 0.*ones(m,samples);

% Vetor da variação do sinal de controle
DU = zeros(m,samples);

% Inicialização dos vetores
r = zeros(n*N2,1);
w = zeros(n*N2,1);

X = [0;0;0;0];
%%
tstart = tic;
for k = 2:samples
    if (checkIterationTime)
        tstartIteration = tic;
    end
    % Simulando Planta
    
    if (strcmp(planta,'Valve'))
        usim = mountVectorU(U,nbd,k,0,Ref(1));
        ysim = mountVectorY(Y,na,k,0,Ref(1));
    else
        usim = mountVectorU(U,nbd,k,0);
        ysim = mountVectorY(Y,na,k,0);
    end
    Y(:,k) = -Asim*ysim+Bd*usim;
%     X = rKutta(@SIPModel,X,[U(1,k-1) U(2,k-1)],T,0.2,0.22,9.8);
%     Y(:,k) = X([1;3]);
    %----------------------------------------------------------------------
    % MIMO GPC - Cálculo da variação do sinal de controle
    du = MultconstrainedMGPC(F,G_,Y,na,U,nbd,Ref,r,w,alpha,N2,n,m,k,Pn,Fi,Gi,PnH_Sizes,planta);
    DU(:,k) = du;
    %----------------------------------------------------------------------
    % Lei de controle do GPC
    if (k > 1) % tratamento para o indice 0 no matlab
        U(:,k) = U(:,k-1) + du;
    else
        U(:,k) = U(:,k)+du;
    end
    if (checkIterationTime)
        tIterEGPCvec(k) = toc(tstartIteration);
    end
end
tEGPC = toc(tstart);

%% Plotagem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if(toPlot)
    close all;
%     controle = 'Explicity GPC';
    controle = 'GPC multiparamétrico';
    suffixFileName = "EGPC";
   
    basicPlotSetup
    
    initHandle = 1;
    plothandle = initHandle:(initHandle+totalHandles-1);
    h = zeros(1,totalHandles);
    for i = 1:totalHandles
        h(plothandle(i)) = figure(plothandle(i)); clf(plothandle(i))
        plotConfig(h(plothandle(i)))
        hold all;
    end
    
%     setup.fontSize = 28;
    plotResults(h(plothandle(1)),vectorTime,U,setup,txtULabel,fileNameU)
    plotResults(h(plothandle(2)),vectorTime,DU,setup,txtDULabel,fileNameDU)
    
    setup.fontSize = 24;
    switch (planta)
        case {"Crane", "Crane_Article"}
            plotResults(h(plothandle(3)),vectorTime,Y(1,:),setup)
            setup.lineFormat{1} = '--';
            plotResults(h(plothandle(3)),vectorTime,0.8*ones(1,samples),setup)
            lines = get(gca,'Children');
            lines(1).LineWidth = 1;
            setup.lineFormat{1} = '-';
            setup.axis = [0 simTime -0.01 0.01];
            plotResults(h(plothandle(4)),vectorTime,Y(2,:),setup)
            setup.lineFormat{1} = '--';
            plotResults(h(plothandle(4)),vectorTime,-Ymax(2)*ones(1,samples),setup)
            plotResults(h(plothandle(4)),vectorTime,Ymax(2)*ones(1,samples),setup,txtOscLabel,"osc"+suffixFileName+"_"+planta)
            setup.lineFormat{1} = '-';
            setup.axis = [];
            plotResults(h(plothandle(3)),vectorTime,Ref(1,:),setup,txtYLabel,fileNameY)
        case {'STR'}
            plotResults(h(plothandle(3)),vectorTime,Y,setup)
            setup.lineFormat(1:2) = {':';':'};
            plotResults(h(plothandle(3)),vectorTime,Ref,setup,txtYLabel,fileNameY)
        case {'DistillationColumn'}
            plotResults(h(plothandle(3)),vectorTime,Y,setup)
            setup.lineFormat(1:3) = {'-.';'-.';'-.'};
            plotResults(h(plothandle(3)),vectorTime,Ref,setup,txtYLabel,fileNameY)
        otherwise
            plotResults(h(plothandle(3)),vectorTime,Y,setup,txtYLabel,fileNameY)
    end
end

%{

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
    if (~strcmp(planta,'Crane'))
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
            subplot(3,1,2)
    %                 hU(i) = stairs(vectorTime,U(i,:),'Linewidth',2,'Color', colors(i,:));
                hU(i) = plot(vectorTime,U(i,:),'Linewidth',2,'Color', colors(i,:));
            subplot(3,1,3)
    %                 hDU(i) = stairs(vectorTime,DU(i,:),'Linewidth',2,'Color', colors(i,:));
                hDU(i) = plot(vectorTime,DU(i,:),'Linewidth',2,'Color', colors(i,:));
        end
    else
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
    end
%}