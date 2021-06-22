function subplotMIMO(vectorTime,Ref,Y,U,DU)
    colors = [ 0  0  0;
              .4 .4 .4;
              .7 .7 .7];
    
    n = size(Y,1);
    m = size(U,1);

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
            plot(vectorTime,Ref(i,:),'--','Linewidth',2,'Color',colors(i,:));
            hY(i) = plot(vectorTime,Y(i,:),'-','Linewidth',2,'Color',colors(i,:));
    end
    for i = 1:m
        subplot(3,1,2)
%             hU(i) = stairs(vectorTime,U(i,:),'Linewidth',2,'Color',colors(i,:));
            hU(i) = plot(vectorTime,U(i,:),'Linewidth',2,'Color',colors(i,:));
        subplot(3,1,3)
%             hDU(i) = stairs(vectorTime,DU(i,:),'Linewidth',2,'Color',colors(i,:));
            hDU(i) = plot(vectorTime,DU(i,:),'Linewidth',2,'Color',colors(i,:));
    end
    
end