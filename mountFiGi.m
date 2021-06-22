function [Pn,Fi,Gi] = mountFiGi(solution)
    solution.merge('primal')
    for i=1:length(solution.Set)
        Fi{i} = solution.Set(i).Functions('primal').F;
        Gi(i) = {solution.Set(i).Functions('primal').g};
    end
    Pn = solution.Set;
end