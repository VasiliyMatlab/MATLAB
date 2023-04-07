clear; close all;

% Программа моделирования работы квадратурного демодулятора

%% Ввод исходных данных
f0 = 10e9;       % несущая частота
fg = f0;         % частота гетеродина
fs = 20*f0;      % частота дискретизации
dt = 1/fs;       % период дискретизации
ts = 0.1e-6;     % длительность импульса
T  = 0:dt:ts-dt; % массив отсчетов времени импульса
nT = length(T);
A  = 1;          % амплитуда сигнала
phase = pi/4;    % нач. фаза сигнала

%% Формирование сигнала
S = A*cos(2*pi*f0*T+phase);          % формирование радиоимпульса
S = [zeros(1,2*nT) S zeros(1,2*nT)]; % перемещение в середину периода
S  = hilbert(S);                     % формирование комплексного сигнала
nS = length(S); nS4 = round(nS/4);
TS = 0:dt:dt*(nS-1);                 % массив отсчетов времени одного периода
plot(TS,real(S),'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
xlim([TS(1) TS(end)+dt]); ylim([-A A]);
title('Radioimpulse');
pause;

%% Смеситель + ФНЧ
SG = hilbert(A*cos(2*pi*fg*TS)); % сигнал гетеродина
SM = real(S).*SG;                % сигнал на выходе смесителя
Hi = sinc(-10:0.08:10);          % ИХ ФНЧ
nHi = length(Hi);                % число отсчетов ИХ
Hi  = Hi.*(hamming(nHi))';       % умножение ИХ на окно Хэмминга
Hi = [Hi zeros(1,nS-nHi)];       % дополнение нулями
HF = abs(fft(Hi));               % вычисление АЧХ ФНЧ
F = 0:fs/nS:fs-fs/nS;            % массив отсчетов частоты
nF8 = round(length(F)/8);
plot(F(1:nF8),HF(1:nF8),'-k','LineWidth',1.5); 
xlabel('Frequency, Hz'); grid on;
title('AFS of LPF');
pause;

SF = conv(Hi,SM); % фильтрация путем свертки
SF = SF(1:nS);    % ограничение сигнала длительностью периода
subplot(2,1,1); 
plot(TS,real(SF),'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude,V');
title('I-channel output');
subplot(2,1,2); 
plot(TS,imag(SF),'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude,V');
title('Q-channel output');
pause;

figure; 
plot(TS,abs(SF),'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('AFS of output signal');
pause;

%% Децимация в АЦП
k = 200; % коэффициент прореживания
new = 0;
TSd = zeros(1,round(nS/k));
SFd = zeros(1,round(nS/k));
for i = 1:round(nS/k)
    new = new+1; old = (i-1)*k+1;
    TSd(new) = TS(old); SFd(new) = SF(old);
end
nSd = new;
subplot(2,1,1);
stem(TSd,real(SFd),'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('I-channel output after decimation');
subplot(2,1,2); 
stem(TSd,imag(SFd),'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Q-channel output after decimation');