function u = online_MPT(X,Pn,Fi,Gi,PnH_Sizes,m)
%     persistent Fi;
%     persistent Gi;
    %persistent Bi;    persistent Ci;    persistent A;   persistent B;    persistent E;    persistent d;
%     persistent Pn;
    persistent utemp;
    
%     [isin, inwhich] = isInside(Pn,X);
    [isin, inwhich] = isInside_mex(Pn,PnH_Sizes,X);
    if (isin)
%         utemp = Fi{1,inwhich(1)}(1:m,:)*X + Gi{1,inwhich(1)}(1:m,:);
        utemp = Fi(1:m,:,inwhich(1))*X + Gi(1:m,:,inwhich(1));
%         disp(['Região ' num2str(inwhich)])
    else 
        disp('O sistema nao entrou em nenhuma regiao');
    end
    u = utemp;
end