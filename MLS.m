clear; close all;

polynom  = 0x25;
init     = 0x56;
Sig      = Generate_MLS(polynom, init);
R        = abs(xcorr(Sig));
[~,ind]  = max(R); R(ind) = R(ind)/1;
% R        = R + 50*abs(randn(1,length(R)));
x        = 1:length(R);
Treshold = CFAR(R,3,5,1,0,'sum');
% Treshold = CFAR(R,3,5,5,0,'mean');

targs    = (R > Treshold) .* R;
x1 = [];
for i = 1:length(targs)
    if targs(i)
        x1 = [x1, x(i)];
    end
end
targs(targs==0) = [];

plot(x,R,'-'); grid on; xlim([x(1), x(end)]);
line(x,Treshold,'LineStyle','--','Color','k');
line(x1,targs,'LineStyle','none','Color','r','LineWidth',1,...
    'Marker','o','MarkerSize',8);


% Генерация М-последовательности
function Signal = Generate_MLS(poly, init)
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
end
