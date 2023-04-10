function Signal = Generate_MLS(poly, init)
% Функция генерации M-последовательности
% poly   - образующий полином
% init   - инициализирующие значения
% Signal - М-последовательность, состоящая из нулей и единиц
    poly = dec2bin(poly);
    if poly(end) ~= '1'
        error("Error. Invalid polynomial.");
    end
    N = length(poly) - 1;
    init = dec2bin(init, N);
    Signal = zeros(1,2^N-1);
    reg = -1 * ones(1,N);
    for i = 1:N
        if init(N-i+1) == '1'
            reg(i) = 1;
        end
    end
    pos = [];
    for i = N:-1:1
        if poly(i) == '1'
            pos = [pos, N-i+1];
        end
    end
    for i = 1:2^N-1
        Signal(i) = reg(N);
        saveBit = 1;
        for j = pos
            saveBit = saveBit * reg(j);
        end
        reg(2:N) = reg(1:N-1);
        reg(1) = saveBit;
    end
    for i = 1:length(Signal)
        if Signal(i) == -1
            Signal(i) = 0;
        end
    end
end
