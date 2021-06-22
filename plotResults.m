function plotResults(handle,vectorTime,data,setup,txtYLabel,fileName)    
    savePlot = setup.savePlot;
    toEPS = setup.toEPS;
    if (nargin < 6)
        savePlot = 0;
        if (nargin < 5)
            txtYLabel = "";
        end
    end
            
    n = size(data,1);
    
    colors = setup.colors;
    
    planta = setup.planta;
    plotFormat = setup.plotFormat;
    lineFormat = setup.lineFormat;
    controle = setup.controle;
    txtXLabel = setup.txtXLabel;
    fontSize = setup.fontSize;

    figure(handle); 
    if (strcmp(plotFormat,"stairs"))
        for i = 1:n
            stairs(vectorTime,data(i,:),lineFormat{i},'Linewidth',2,'Color',colors(i,:));            
        end
    else
        for i = 1:n
            plot(vectorTime,data(i,:),lineFormat{i},'Linewidth',2,'Color',colors(i,:));
        end
    end
   grid on; box off;
    xlabel(txtXLabel);
    ylabel(txtYLabel);
%     sTitle = sprintf(planta+" Control - %s", controle);
    sTitle = sprintf("Controle "+planta+" - %s", controle);
    if (strcmp(planta,'Coluna de Destilação'))
        sTitle = sprintf("%s", controle);
    end
    title(sTitle)
    axis(setup.axis);
%     hLegendU = legend(legendU);
%     set(hLegendU,'Box','off');
    if (savePlot)
        figure(handle)
            if (~verLessThan('matlab', '9.4'))
                cd(setup.SavePathFig)
                savefig(fileName+".fig")
            end
            
            set(handle,'PaperPositionMode','auto','Units','Inches');
            pos = get(handle,'Position');
            set(handle,'PaperUnits','Inches','PaperSize',[pos(3), pos(4)]);
            set(gca,'FontSize', fontSize);
            if(toEPS)
%                 print -depsc2 planta.eps   
%                 fixPSlinestyle('planta.eps', 'uEGPC.eps');
                if (verLessThan('matlab', '9.4'))
                    cd(setup.SavePath)
                    print(handle,[char(fileName) '.eps'],'-depsc','-r0')
                    cd(setup.actualFolder)
                else
                    cd(setup.SavePath)
                    print(handle,fileName+".eps",'-depsc','-r0')
                    cd(setup.actualFolder)
                end
            else
                if (verLessThan('matlab', '9.4'))
                    print(handle,[char(fileName) '.pdf'],'-dpdf','-r0')
                else
                    print(handle,fileName+".pdf",'-dpdf','-r0')
                end
            end
    end