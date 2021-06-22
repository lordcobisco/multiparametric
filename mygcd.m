function G = mygcd(p1,p2,TOL)
    if(nargin < 3)
        TOL = 1e-7;
    end
    if(length(p1) > length(p2))
        p1_ = p1;
        p2_ = p2;
    else
        p1_ = p2;
        p2_ = p1;
    end

    [Q,R] = deconv(p1_,p2_);
    while (any(abs(R)>TOL)) 
        p1_ = p2_;
        p2_ = adjustResidue(R);
        [Q,R] = deconv(p1_,p2_);
    end
    
    G = p2_;
end

function adjusted = adjustResidue(p)
    j = 1;
    while (p(j) == 0)
        j = j+1;
    end
    adjusted = p(j:end)./p(j);   
end