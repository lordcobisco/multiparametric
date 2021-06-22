function X = rKutta(f,X,u,h,m,l,g)
    k1 = feval(f,X,u,m,l,g); k2 = feval(f,X+k1*h/2,u,m,l,g);
    k3 = feval(f,X+k2*h/2,u,m,l,g); 
    k4 = feval(f,X+k3*h,u,m,l,g);

    X = X + (h/6)*(k1 + 2*k2 + 2*k3 + k4);
end