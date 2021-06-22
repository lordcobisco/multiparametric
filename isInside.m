function [isin, inwhich] = isInside(H,H_Sizes,x0) %#codegen
    % Compilacao: codegen isInside -args {Hpoly,PnH_Sizes,zeros(size(E,2),1)}
    notIn = true;
    isin = false;
    inwhich = -1;
    for i = 1:size(H,3)
        for j = 1:H_Sizes(i)
            if (H(j,:,i)*[x0; -1] > 1e-8)
                notIn = false;
                break;
            end
        end
        if (notIn)
            inwhich = i;
            isin = true;
            break;
        else
            notIn = true;
        end
    end
