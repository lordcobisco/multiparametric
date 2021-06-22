load('mptOriginalResult_multiLimb.mat')
Q = Pn;
value2send = [];
fileID = fopen('toC.txt','w');
fprintf(fileID,['LinAlg::Matrix<float> *Set = new LinAlg::Matrix<float>[' num2str(length(Q)) '];\n']);
for i = 1:length(Q)
    for j = 1:size(Q(i).H,1)
        for k = 1:size(Q(i).H,2)
            value2send = [value2send num2str(Q(i).H(j,k),10) ','];
        end
        value2send(end) = ';';
    end
    %value2send(end) = 'R';
    fprintf(fileID,['Set[' num2str(i-1) '] = "' value2send(1:end-1) '";\n']);
    value2send = [];
end

fprintf(fileID,['LinAlg::Matrix<float> *controlLaw = new LinAlg::Matrix<float>['  num2str(length(Q)) '];\n']);
for i = 1:length(Q)
    temp = [Fi{i} Gi{i}];
    for j = 1:size(temp,1)
        for k = 1:size(temp,2)
            value2send = [value2send num2str(temp(j,k),10) ','];
        end
        value2send(end) = ';';
    end
    %value2send(end) = 'C';
    fprintf(fileID,['controlLaw['  num2str(i-1) '] = "' value2send(1:end-1) '";\n']);
    value2send = [];
end
fclose(fileID);