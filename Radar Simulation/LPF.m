clear; close all;

% Пример фильтрации смеси двух гармонических сигналов

f1 = 5e4;                     % частота низкочастотного сигнала
f2 = 2e6;                     % частота высокочастотного сигнала
ts = 2e-4;                    % длительность смеси сигналов
fs = 10*f2;                   % частота дискретизации
dt = 1/fs;                    % период дискретизации
T  = 0:dt:ts;                 % массив отсчетов времени
nT = length(T);               % число отсчетов массива Т
dF = fs/nT;                   % шаг дискретной частоты
S  = 0.1*cos(2*pi*f1*T)+1.0*cos(2*pi*f2*T);
plot(T,S,'-k','LineWidth',2); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Input signal'); xlim([0 2e-4]);
pause;
SF  = fft(S);                 % вычисление спектра смеси сигналов
FX  = 0:dF:dF*(nT-1);         % массив отсчетов частоты
nf2 = round(length(FX)/2);
nf4 = round(nf2/4);
plot(FX(1:nf4),abs(SF(1:nf4)),'-k','LineWidth',2); grid on;
xlabel('Frequency, Hz'); title('Amplitude spectrum');
pause;
Hi    = sinc(-10:0.05:10);    % ИХ типа sinc()
nHi   = length(Hi);           % число отсчетов ИХ
Hi    = Hi.*(hamming(nHi))';  % умножение ИХ на окно Хэмминга
Hi    = [Hi zeros(1,nT-nHi)]; % дополнение нулями
FH    = fft(Hi);              % ДПФ для вычисления ЧХ фильтра
plot(FX(1:nf4),abs(FH(1:nf4)),'-k','LineWidth',2); grid on;
xlabel('Frequency, Hz'); title('AFS of LPF');
pause;
S_out = conv(Hi,S);           % фильтрация путем свертки
plot(T(nHi:nT),S_out(nHi:nT),'-k','LineWidth',2); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Output signal'); xlim([0.2e-4 2e-4]);