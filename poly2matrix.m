function [H,getSizes] = poly2matrix(Pn)
    
    lin = length(Pn);
    colsH = size(Pn(1).H,2);    
    maxHlin = 0;

    for i = 1:lin
        getSizes(i) = size(Pn(i).H,1);
        if(maxHlin < size(Pn(i).H,1) )
            maxHlin = size(Pn(i).H,1);
        end
    end
    for i = 1:lin
        H(:,:,i) = [Pn(i).H; zeros(maxHlin-size(Pn(i).H,1),colsH)]; 
    end
end