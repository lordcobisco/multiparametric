function Xp = SIPModel(X,u,m,l,g)
    Xp = zeros(4,1); to = u(1); tp = u(2);
    
    Xp(2) = (to - (m*l^2*sin(X(1))*cos(X(1))...
                -m*l*g*cos(X(3))*sin(X(1))))/(m*l^2);
    Xp(4) = (tp-(-2*X(4)*X(2)*tan(X(1))...
              -(g*sin(X(3)))/(l*cos(X(1)))))/(m*l*cos(X(1))^2);
    Xp(1) = X(2);
    Xp(3) = X(4);
end