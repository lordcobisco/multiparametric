%% Plot Configurantion
function plotConfig(handle)

Colors = [ 0  0  0;
        .4 .4 .4;
        .7 .7 .7];
%% Line

% Linewidth
set(handle,'DefaultLineLineWidth',2)

% Marker

%% Axes

% Color and Linestyle order
set(handle,'DefaultAxesColorOrder',...
            Colors, ...
            'DefaultAxesLineStyleOrder',...
            '-|--|-.|:',...
            'Position', [700 81 1041 550]);

% LineWidth
set(handle,'DefaultAxesLineWidth', 1);

% Ticks
set(handle,'DefaultAxesTickDir'   ,'out'     , ...
               'DefaultAxesTickLength',[.01 .01] , ...
               'DefaultAxesXMinorTick', 'on'     , ...
               'DefaultAxesYMinorTick', 'on'     );%, ...
%                'DefaultAxesXColor'    ,[.3 .3 .3], ...
%                'DefaultAxesYColor'    ,[.3 .3 .3]);

% Font configuration  
set(handle,'DefaultAxesFontName', 'Times New Roman',...
               'DefaultAxesFontSize', 14);