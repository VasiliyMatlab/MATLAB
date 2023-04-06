function Out = RTI_Decimation(Data,N)
% RTI_DECIMATION
% Децимация суммированием
% Usage: Out = RTI_Decimation(Data,N)
%   Data - вектор входных данных
%   N    - коэффициент прореживания
%   Out  - вектор выходных данных

if ~isvector(Data)
    error('Error.\nInput data "Data" must be a vector.\n', 4);
end
if mod(N,1)
    error('Error.\nDecimate factor "N" must be integer.\n', 4);
end
if N < 1
    error('Error.\nDecimate factor "N" must be positive.\n', 4);
end
len_in = length(Data);
if len_in < N
    error('Error.\nLength of input data vector "Data" must be greater than decimate factor "N".\n', 4);
end
if N == 1
    Out = Data;
else
    len_out = ceil(len_in/N);
    if size(Data,1) == 1
        Out = zeros(1,len_out);
    else
        Out = zeros(len_out,1);
    end

    for i = 1:len_out
        win = (i-1)*N+1:i*N;
        win(win>len_in) = [];
        Out(i) = sum(Data(win));
    end
end

end
