clear; close all;

dispstat('','init');
dispstat(sprintf('Формирование РЛИ завершено на 0%%'));
S = zeros(50,50,50);
tmp = zeros(1,3);
dproc = 1/50/50*100;

% Цикл по слоям
tmp(1) = cputime;
for iz = 1:50
    % Цикл по Х
    for ix = 1:50
        % Цикл по Y
        for iy = 1:50
            sig = 0;
            % Цикл по передатчикам
            for iTx = 1:4
                % Цикл по приемникам
                for iRx = 1:4
                    r   = sqrt(ix^2 + iy^2 + iz^2);
                    tau = r / 3e8;
                    sig = sig + 1/r^2*exp(2j*pi*1e9*tau);
                    pause(0.00001);
                end
            end
            S(iz,ix,iy) = sig;
        end
        proc = ((iz-1)*50+ix-1)/50/50*100;
        tmp(2) = cputime;
        tmp(3) = tmp(2) - tmp(1);
        timeremain = tmp(3) / proc * (100 - proc);
        dispstat(sprintf('Формирование РЛИ завершено на %.2f%%. Оставшееся время %.0f с', proc, timeremain));
    end
end
dispstat(sprintf('Формирование РЛИ завершено на 100%%'));
