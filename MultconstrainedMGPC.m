function [du,xMp] = MultconstrainedMGPC(F,G_,Y,na,U,nbd,Ref,r,w,alpha,N2,n,m,k,Pn,Fi,Gi,PnH_Sizes,planta)
    if (strcmp(planta,'Valve'))
        freeY = mountVectorY(Y,na,k,1,Ref(1));
        %atualiza entradas passadas
        freeDU = mountVectorU(U,nbd,k,1);
    else
        freeY = mountVectorY(Y,na,k,1);
        %atualiza entradas passadas
        freeDU = mountVectorU(U,nbd,k,1);
    end
    %------------------<Cálculo da Resposta Livre do GPC>------------------    
    f = G_*freeDU + F*freeY;

    % Considera apenas referências atuais
    for i=1:N2
        for j = 1:n
            r(j+n*(i-1))=Ref(j,k); %atualiza o sinal degrau com Ny passo a frente
        end
    end

    % Referência ponderada.
    % O termo alfa permite uma aproximação suave da saída para o setpoint w
    % 0 <= alfa < 1, em que quanto maior o alfa mais suave será a
    % aproximação

    for i = 1:N2
        for j = 1:n
            if (i == 1)
                w(j) = alpha*Y(j,k)+(1-alpha)*r(j);
            else
                w(j+n*(i-1)) = alpha*w(j+n*(i-2))+(1-alpha)*r(j+n*(i-1));
            end
        end
    end
    
    if (k > 1) % tratamento para o indice 0 no matlab
        xMp = [U(1:m,k-1);freeDU;freeY;w(1:n)];
        du = online_MPT(xMp,Pn,Fi,Gi,PnH_Sizes,m);
    else
        xMp = [zeros(m,1);freeDU;freeY;w(1:n)];
        du = online_MPT(xMp,Pn,Fi,Gi,PnH_Sizes,m);

    end
    xMp';
end 