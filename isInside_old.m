function [isin, inwhich] = isInside(H,H_Sizes,x0) %#codegen
    % Compilacao: codegen isInside -args {Hpoly,PnH_Sizes,zeros(size(E,2),1)}
    isin = false;
    inwhich = -1;
    for i = 1:length(H)
        if any(H(1:H_Sizes(i),:,i)*[x0; -1] > 1e-8)
            continue;
        else
            inwhich = i;
            isin = true;
            break;
        end
    end
