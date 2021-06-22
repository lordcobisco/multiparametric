load('mptOriginalResult_multiLimb.mat')
Q = Pn;
value2send = [];
for i = 1:length(Q)
    for j = 1:size(Q(i).H,1)
        for k = 1:size(Q(i).H,2)
            value2send = [value2send num2str(Q(i).H(j,k),10) ','];
        end
        value2send(end) = ';';
    end
    value2send(end) = 'R';
end

for i = 1:length(Q)
    temp = [Fi{i} Gi{i}];
    for j = 1:size(temp,1)
        for k = 1:size(temp,2)
            value2send = [value2send num2str(temp(j,k),10) ','];
        end
        value2send(end) = ';';
    end
    value2send(end) = 'C';
end
fileID = fopen('toC.txt','w');
fprintf(fileID,value2send);
fclose(fileID);