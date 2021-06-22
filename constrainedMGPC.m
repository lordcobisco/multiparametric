function [du,c] = constrainedMGPC(K,F,G,G_,Y,na,U,DU,nbd,Ref,r,w,alpha,N2,N2r,Nu,Nur,R,Q,n,m,withCnstr,cnstrMatrix,k,planta)
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

%     % Considera referências futuras
%     for i=k:min(simTime,k+N2-1)
%         for j = 1:n
%             r(j+2*(i-k+1)-2)=Ref(j,i); %atualiza o sinal degrau com Ny passo a frente
%         end
%     end

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

    if ~any(withCnstr)
        %----------------------------------------------------------------------
        %---------------------<Controle GPC sem Restrições>--------------------
        % Calcula variação (Delta U) do sinal de controle

        du = K*(w-f);   

    %     % Restrições operacionais (Ex: máxima abertura da válvula)
    %     for i = 1:length(du)
    %         if (du(i) > duCstr(1))
    %             du(i) = duCstr(1);
    %         elseif (du(i) < duCstr(2))
    %             du(i) = duCstr(2);
    %         end
    %     end
    else
        %----------------------------------------------------------------------
        %---------------------<Controle GPC sem Restrições>--------------------
    % Restrições
        DUmax = cnstrMatrix{:,1};
        DUmin = cnstrMatrix{:,2};
        Umax = cnstrMatrix{:,3};
        Umin = cnstrMatrix{:,4};
        Ymax = cnstrMatrix{:,5};
        Ymin = cnstrMatrix{:,6};

        restricaoDU = withCnstr(1);
        restricaoU = withCnstr(2);
        restricaoY = withCnstr(3);

        H = 2*(G'*R*G+Q);

        % Make sure it is symmetric
        if norm(H-H',inf) > eps || ~issymmetric(H)
            H = (H+H')*0.5;
        end      
            
        b = (2*(f-w)'*R*G)';

        Restr = [];
        c = [];
        RDu = [eye(m*Nur,m*Nu); -eye(m*Nur,m*Nu)];
        cDu = [mountCstrMatrix(DUmax,m,Nur);mountCstrMatrix(-DUmin,m,Nur)];

        RU = [auxMatrixCstr(1,0,m,Nu,Nur);auxMatrixCstr(-1,0,m,Nu,Nur)];   
        if k > 1
            cU = [mountCstrMatrix(Umax-U(:,k-1),m,Nur);...
                  mountCstrMatrix(-Umin+U(:,k-1),m,Nur)];
        else
            cU = [mountCstrMatrix(Umax,m,Nur);mountCstrMatrix(-Umin,m,Nur)];
        end

%         RY = [G;-G];
%         cY = [mountCstrMatrix(Ymax,n,N2)-f; mountCstrMatrix(-Ymin,n,N2)+f];
        RY = [G(1:n*N2r,1:end);-G(1:n*N2r,1:end)];
        cY = [mountCstrMatrix(Ymax,n,N2r)-f(1:n*N2r); mountCstrMatrix(-Ymin,n,N2r)+f(1:n*N2r)];

        if (restricaoDU)
            Restr = [Restr; RDu];
            c = [c; cDu];
        end
        if (restricaoU)
            Restr = [Restr; RU];
            c = [c; cU];
        end
        if (restricaoY)
            Restr = [Restr; RY];
            c = [c; cY];
        end        

        du = zeros(m*Nu,1);
        
        options = optimset('Display','off');
        [duQP,fval,exitflag,output] = quadprog(H,b,Restr,c,[],[],[],[],[],options);

%         TOL = 1e-8;
%         [duAS, ~, ~, cont] = activeset(H, b, Restr, c, TOL, du);
%         while cont == 400
%             TOL = TOL*10;    
%             [duAS, ~, ~, cont] = activeset(H, b, Restr, c, TOL, du);
%             if TOL == 1e-6
%                 break;
%             end
%         end

        if (isempty(duQP))
            disp('INFEASIBLE')
            du = DU(:,k-1);
        else
            if (exitflag == -2)
                disp('INFEASIBLE')
            end
            du = duQP(1:m); 
        end        
    end
end
