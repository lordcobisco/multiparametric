function Indices = showIndices(vectorTime,Ref,Y,U)

refPosition = Ref(1,:);
refSway = Ref(2,:);
position = Y(1,:);
sway = Y(2,:);

simTime = vectorTime(end);
erroPosition = refPosition-position;
erroSway = refSway-sway;
overshoot = (max(position)/refPosition(1)-1)*100;

ref2max = 1.02*refPosition(1);
ref2min = 0.98*refPosition(1);

settlingPoint = find(~(position >= ref2min & position <= ref2max), 1, 'last');
settlingTime = vectorTime(settlingPoint);

%Maximum transient swing (MT)
MT = max(abs(sway));
RS = min(abs(sway(settlingPoint:end)));

[goodHart_Pos,MSE_Pos,IE_Pos,IAE_Pos,ISE_Pos,ITAE_Pos,ITSE_Pos] = calcIndexes(erroPosition,U,vectorTime);
[goodHart_Sway,MSE_Sway] = calcIndexes(erroSway,U,vectorTime);

Indices = cell(8,2);
Indices{1,1} = 'GoodHart Sway';
Indices{2,1} = 'MSE Sway';
Indices{3,1} = 'MT';
Indices{4,1} = 'RS';
Indices{5,1} = 'GoodHart Pos';
Indices{6,1} = 'MSE Pos';
Indices{7,1} = 'Overshoot';
Indices{8,1} = 'Settling';

Indices{1,2} = goodHart_Sway;
Indices{2,2} = MSE_Sway;
Indices{3,2} = MT;
Indices{4,2} = RS;
Indices{5,2} = goodHart_Pos;
Indices{6,2} = MSE_Pos;
Indices{7,2} = overshoot;
Indices{8,2} = settlingTime;