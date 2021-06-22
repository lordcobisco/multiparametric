function [Pn,Fi,Gi,details] = multparametric(H,G,R,cnstrMatrix,Restr,c)
    Nu = size(G,2);
    N2 = size(G,1);
    G = [G;1 zeros(1,size(G,2)-1)];
    Matrices.G = [Restr;G;-G];
    %    Matrices.E = [zeros(length(c),size(G,1));zeros(size(G,1)-1,size(G,1));zeros(1,size(G,1));-zeros(size(G,1)-1,size(G,1));zeros(1,size(G,1))];             
    Matrices.E = [zeros(length(c),size(G,1));-eye(size(G,1));eye(size(G,1))];
    Matrices.W = [c;cnstrMatrix(5)*ones(size(G,1)-1,1);cnstrMatrix(3);-cnstrMatrix(6)*ones(size(G,1)-1,1);-cnstrMatrix(4)];
    Matrices.H = H;
    Matrices.F = -2*G;
    Matrices.Y = [R zeros(N2,1);zeros(1,N2+1)];
    Matrices.Cf = zeros(1,length(Matrices.H));
    Matrices.Cx = zeros(1,length(Matrices.Y));
    Matrices.Cc = 0;

    Matrices.bndA=[];
    Matrices.bndb=[];

    tic
    %     sol = mpt_mpmilp(Matrices);
    [Pn,Fi,Gi,activeConstraints,Phard,details] = mpt_mpqp(Matrices);
    Pn = toPolyhedron(Pn);
    save('mptResult.mat','Pn','Fi','Gi');
    clear online_MPT
    toc

    %     Pn = sol.Pn;
    %     Fi = sol.Fi;
    %     Gi = sol.Gi;
    %     details = sol;
end