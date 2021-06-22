function [Pn,Fi,Gi,PnH_Sizes,tOptimizerMult,details] = multparametric(H,G,G_,F,R,n,m,Restr,c,E,Nu,N2,bndA,bndb,planta)
   
    Matrices.G = Restr;
    Matrices.E = E;
    Matrices.W = c;
    Matrices.H = H;
    Matrices.F = [zeros(m,m*Nu); 2*G_'*R*G ; 2*F'*R*G ; -2*auxMatrixCstr(1,1,n,N2)'*R*G];
    Matrices.Y = zeros(size(Matrices.F,1),size(Matrices.F,1));
    Matrices.Cf = zeros(1,length(Matrices.H));
    Matrices.Cx = zeros(1,length(Matrices.Y));
    Matrices.Cc = 0;
    
%     if (strcmp(planta,'Crane') || strcmp(planta,'Crane_Article'))
%         Matrices.bndA = bndA;
%         Matrices.bndb = bndb;
%     elseif (strcmp(planta,'CSTR'))
%         Matrices.bndA = bndA;
%         Matrices.bndb = bndb;
% %         Matrices.bndA = [eye(size(E,2));-eye(size(E,2))];
% %         Matrices.bndb = [2*ones(size(E,2),1);2*ones(size(E,2),1)];
%     elseif (strcmp(planta,'DistillationColumn'))
%         Matrices.bndA = bndA;
%         Matrices.bndb = bndb;
% %         Matrices.bndA = [eye(size(E,2));-eye(size(E,2))];
% %         Matrices.bndb = [0.6*ones(size(E,2),1);0.6*ones(size(E,2),1)];
%     end
    Matrices.bndA = bndA;
    Matrices.bndb = bndb;
  
    tstart = tic;
    [Pn,Fi,Gi,activeConstraints,Phard,details] = mpt_mpqp(Matrices);
%     [Pn,Fi,Gi] = mountFiGi(solution.xopt);    
 
    tOptimizerMult = toc(tstart);   
    
    Pn = toPolyhedron(Pn);

    save("mptOriginalResult_"+planta+".mat",'Pn','Fi','Gi');
    
    [Pn,PnH_Sizes] = poly2matrix(Pn); 
    Fi = cell2mat3(Fi,m);
    Gi = cell2mat3(Gi,m);    
%     codegen isInside -args {Pn,PnH_Sizes,zeros(size(E,2),1)}    
    
    save("mptResult_"+planta+".mat",'Pn','PnH_Sizes','Fi','Gi');
end