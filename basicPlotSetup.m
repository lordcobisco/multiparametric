% Cores
% setup.colors = [0 0.75 0.75; ... %dark cyan
%              0.75 0 0.75; ... %dark magenta
%              0.75 0.75 0];    %dark yellow
              
% setup.colors = [0 0   1; ... % blue
%           0 0.5 0; ... % dark green
%           1 0 0];  ... % red

% Matlab
setup.colors = [0 0 0 
        0  .45  .74;
        .85 .33 .1;
        .93 .69 .13
        0.49 0.18 0.56];

% Grayscale
% setup.colors = [ 0  0  0;
%         .4 .4 .4;
%         .7 .7 .7];

setup.savePlot = savePlot;
setup.toEPS = toEPS;
setup.planta = planta;
setup.controle = controle;
setup.plotFormat = "";
setup.lineFormat = {'-';'--';':';'-.'};
% setup.txtXLabel = "Time (min)";
setup.txtXLabel = "Tempo (min)";
setup.axis = [];
setup.fontSize = 36;
setup.actualFolder = pwd;
setup.SavePathFig = ".\Figuras\"+planta;
setup.SavePath = 'E:\Dropbox\01 - Daniel\Doutorado\Tese\Latex\Capitulos\Resultados\imgs\newF';

txtYLabel = "\bf{y}";
txtULabel = "\bf{u}";
txtDULabel = "\Delta \bf{u}";

fileNameY = "y"+suffixFileName+"_"+planta;
fileNameU = "u"+suffixFileName+"_"+planta;
fileNameDU = "du"+suffixFileName+"_"+planta;

switch (planta)
    case {"Crane", "Crane_Article"}
%         setup.planta = "Crane";
        setup.planta = "GCS";
        totalHandles = 4;
%         txtOscLabel = {'Oscillation (rad)'};
%         txtYLabel = {'Position (m)'};
%         txtULabel = {'Input Voltage (V)'};
%         txtDULabel = {'Input increment (V)'};
%         setup.txtXLabel = "Time (s)";
        txtOscLabel = {'\theta (rad)'};
        txtYLabel = {'Posição (m)'};
        txtULabel = {'Tensão de entrada (V)'};
        txtDULabel = {'\Delta u (V)'};
        setup.txtXLabel = "Tempo (s)";
        
        setup.SavePathFig = ".\Figuras\Guindaste";
        setup.SavePath = 'E:\Dropbox\01 - Daniel\Doutorado\Tese\Latex\Capitulos\Resultados\imgs\Crane';
    case ("DistillationColumn")
%         setup.planta = "Distillation Column";
        setup.planta = "Coluna de Destilação";        
        totalHandles = 3;
        setup.SavePathFig = ".\Figuras\ColunaDestilacao";
    otherwise
        totalHandles = 3;
        clear txtOscLabel
end