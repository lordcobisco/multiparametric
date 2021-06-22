%% Simulação %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Vetor de saída
Y = zeros(n,samples);

% Vetor do sinal de controle
U = 0*ones(m,samples);

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
    du = constrainedMGPC(K,F,G,G_,Y,na,U,DU,nbd,Ref,r,w,alpha,N2,N2r,Nu,Nur,R,Q,n,m,withCnstr,cnstrMatrix,k,planta);
    
    
    DU(:,k) = du;
    %----------------------------------------------------------------------
    % Lei de controle do GPC
    if (k > 1) % tratamento para o indice 0 no matlab
        U(:,k) = U(:,k-1) + du;
    else
        U(:,k) = du;
    end
    if (checkIterationTime)
        tIterCGPCvec(k) = toc(tstartIteration);
    end
end
tCGPC = toc(tstart);

%% Plotagem %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(toPlot)
%     controle = 'Constrained GPC';
    controle = 'GPC com restrições';
    suffixFileName = "CGPC";

    basicPlotSetup

    initHandle = 4;
    plothandle = initHandle:(initHandle+totalHandles-1);
    h = zeros(1,totalHandles);
    for i = 1:totalHandles
        h(plothandle(i)) = figure(plothandle(i)); clf(plothandle(i))
        plotConfig(h(plothandle(i)))
        hold all;
    end

    plotResults(h(plothandle(1)),vectorTime,U,setup,txtULabel,fileNameU)        
    plotResults(h(plothandle(2)),vectorTime,DU,setup,txtDULabel,fileNameDU)
    
    switch (planta)
        case {"Crane", "Crane_Article"}
            plotResults(h(plothandle(3)),vectorTime,Y(1,:),setup,txtYLabel)
            setup.lineFormat = '--';
            plotResults(h(plothandle(3)),vectorTime,0.8*ones(1,samples),setup)
            lines = get(gca,'Children');
            lines(1).LineWidth = 1;
            setup.lineFormat = '-';
            setup.axis = [0 simTime -0.01 0.01];
            plotResults(h(plothandle(4)),vectorTime,Y(2,:),setup)
            setup.lineFormat = '--';
            plotResults(h(plothandle(4)),vectorTime,-Ymax(2)*ones(1,samples),setup)
            plotResults(h(plothandle(4)),vectorTime,Ymax(2)*ones(1,samples),setup,txtOscLabel,"osc"+suffixFileName+"_"+planta)
            setup.lineFormat = '-';
            setup.axis = [];
        otherwise
            plotResults(h(plothandle(3)),vectorTime,Y,setup,txtYLabel,fileNameY)           
    end
    setup.lineFormat = ':';
    plotResults(h(plothandle(3)),vectorTime,Ref,setup,txtYLabel,fileNameY)
end

%{
controle = 'Constrained GPC';

uUpLim = 1.02*Umax;
uBotLim = 1.02*Umin;

Umaxplot = Umax*ones(1,length(vectorTime));
Uminplot = Umin*ones(1,length(vectorTime));
DUmaxplot = DUmax*ones(1,length(vectorTime));
DUminplot = DUmin*ones(1,length(vectorTime));

plothandle = 5:8;

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
    %                 fixPSlinestyle('planta.eps', 'xCGPC.eps');  
                    print(actualHandle,'xCGPC.eps','-depsc','-r0')
                else                
                    print(actualHandle,'xCGPC.pdf','-dpdf','-r0')
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
    %                 fixPSlinestyle('planta.eps', 'uCGPC.eps');  
                    print(actualHandle,'uCGPC.eps','-depsc','-r0')
                else                
                    print(actualHandle,'uCGPC.pdf','-dpdf','-r0')
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
    %                 fixPSlinestyle('planta.eps', 'duCGPC.eps');  
                    print(actualHandle,'duCGPC.eps','-depsc','-r0')
                else                
                    print(actualHandle,'duCGPC.pdf','-dpdf','-r0')
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
    %                 fixPSlinestyle('planta.eps', 'ythCGPC.eps');  
                    print(actualHandle,'ythCGPC.eps','-depsc','-r0')
                else                
                    print(actualHandle,'ythCGPC.pdf','-dpdf','-r0')
                end
        end
    end
%}