%% Inicialização do GPC multivariável %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Crane
DistillationColumn
% StirredTankReactor
% multivariateLimbModel

[F,G_,G,K,tTuningUGPC] = initMIMOgpc(A,Bd,N2,Nu,R,Q);

%%% [CRANE] Teste valor máximo e mínimo para f 
eye_nb = repmat(eye(m),nbd,1);
eye_na_ = repmat(eye(n),na+1,1);

% max_f = G_*eye_nb*DUmax + F*eye_na_*Ymax;
% fmax = zeros(n,1);
% fmin = zeros(n,1);
% for i = 1:n
%     fmax(i) = max(max_f(i:n:end-(n-i)));
% end
% min_f = G_*eye_nb*DUmin + F*eye_na_*Ymin;
% for i = 1:n
%     fmin(i) = min(min_f(i:n:end-(n-i)));
% end

Bd = cell2mat(Bd);

toPlot = 0;
savePlot = 0;
toOptimize = 1;
runMEX = 0;
toEPS = 1;
checkOverallTime = 0;
checkIterationTime = 0;

nSim = 10;

% Habilitando restrições
restricaoDU = 1;
restricaoU = 1;
restricaoY = 1;
withCnstr = [restricaoDU restricaoU restricaoY];

if (checkOverallTime)
    toOptimize = 1;
    toPlot = 0;
    checkIterationTime = 0;
    tUGPCvec =[];
    tCGPCvec =[];
    tEGPCvec =[];
    for v = 1:nSim
        withCnstr = [1 1 1];
        constrainedGPC
        tCGPCvec(v) = tCGPC;

        PnH_Sizes = 0;
        multGPC
        tEGPCvec(v) = tEGPC;
        
%         unconstrainedGPC
%         tUGPCvec(v) = tUGPC;
    end

    medtUGPC = median(tUGPCvec);
    harmmean(tUGPCvec);
    medtCGPC = median(tCGPCvec);
    harmmean(tCGPCvec);
    medtEGPC = median(tEGPCvec);
    harmmean(tEGPCvec);
    [medtUGPC medtCGPC medtEGPC]
else
    tIterUGPCvec = zeros(1,samples);
    tIterCGPCvec = zeros(1,samples);
    tIterEGPCvec = zeros(1,samples);
    
    constrainedGPC
%     tCGPC
%     CGPC_ind = showIndices(vectorTime,Ref,Y,U);
  
    PnH_Sizes = 0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    multGPC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tEGPC
%     multGPC_ind = showIndices(vectorTime,Ref,Y,U);
    
%     unconstrainedGPC
%     UGPC_ind = showIndices(vectorTime,Ref,Y,U);
%     tUGPC

    if (checkIterationTime)
        medtIterUGPC = median(tIterUGPCvec);
        maxtIterUGPC = max(tIterUGPCvec);
        medtIterCGPC = median(tIterCGPCvec);
        maxtIterCGPC = max(tIterCGPCvec);
        medtIterEGPC = median(tIterEGPCvec);
        maxtIterEGPC = max(tIterEGPCvec);
        format long
        [medtIterUGPC medtIterCGPC medtIterEGPC]
        [maxtIterUGPC maxtIterCGPC maxtIterEGPC]
        format short
    end
end

if (toOptimize)
    load("mptResultTime_"+planta+".mat")
    tOptimizerMult
    calcTime(cstart,cstop)
end

% [UGPC_ind CGPC_ind(:,2)] %multGPC_ind(:,2)]
if(~toPlot)
    close all;
end
% close(2:3)
% close(6:7)
% close(10:11)
%%
if (0)
    indices = UGPC_ind;
    indices(:,3) = CGPC_ind(:,2);
    indices(:,4) = multGPC_ind(:,2);

    Tempo = cell(3,4);
    Tempo{1,1} = 'Time/Algorithm';
    Tempo{1,2} = 'UGPC';
    Tempo{1,3} = 'CGPC';
    Tempo{1,4} = 'EGPC';

    Tempo{2,1} = 'Online Time (s)';
%     Tempo{3,1} = 'Tuning Time (s)';

    Tempo{2,2} = tUGPC;
    Tempo{2,3} = tCGPC;
    Tempo{2,4} = tEGPC;
    
%     Tempo{3,2} = tTuningUGPC;
%     Tempo{3,3} = 0;
%     Tempo{3,4} = tTuningMult;

    save('indAndTime.mat','indices','Tempo');
end