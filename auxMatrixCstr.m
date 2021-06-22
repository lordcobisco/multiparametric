% Função para gerar matrizes auxiliares para o GPC com restrição
%
% value  = constante a ser colocada na matriz
% m      = Números de entrada do sistema
% Nu     = Horizonte de controle
% Caso type = 0 => gerará uma matriz triangular inferior de identidades
%                  (m x m).
%      type = 1 => gerará uma 'matriz coluna' de identidades m x m
%                  correspondendo a Nu(m x m) matrizes identidades.
%
% Exemplo:
% Considerando value = 1, Nu = 3 e m = 2
%
%            TYPE = 0                          TYPE = 1
%
%                 | 1 0 0 0 0 0 |                   | 1 0 |
%                 | 0 1 0 0 0 0 |                   | 0 1 |
%     auxMatrix = | 1 0 1 0 0 0 |       auxMatrix = | 1 0 |
%                 | 0 1 0 1 0 0 |                   | 0 1 |
%                 | 1 0 1 0 1 0 |                   | 1 0 |
%                 | 0 1 0 1 0 1 |                   | 0 1 |

function auxMatrix = auxMatrixCstr(value,type,m,Nu,Nr) 

if (nargin > 4)
    Nur = Nr;
else
    Nur = Nu;
end
auxMatrix = zeros(m*Nur,m*(Nu-type*(Nu-1)));

for j = 1:m*(Nu-type*(Nu-1))
    for i = j:m:m*Nur
        auxMatrix(i,j) = value;
    end
end
