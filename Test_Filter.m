clear; close all;

% Формирование АЧХ фильтра по его ИХ

fc = 0;         % центральная частота
fs = 1e5;       % частота дискретизации
dt = 1/fs;      % период дискретизации
t  = 0:dt:2;    % массив отсчетов времени
nt = length(t); % кол-во отсчетов массива t

% Построение ИХ фильтра
h  = sinc((t-1)*1000)/50.*(hamming(nt))'.*exp(1j*2*pi*fc*t);
plot(t,real(h),'-k','LineWidth',2); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('ИХ фильтра');
pause;

% Вычисление АЧХ фильтра
Nfft = 2^nextpow2(nt);     % кол-во частот
f  = 0:fs/Nfft:fs-fs/Nfft; % массив отсчетов частот
nf = length(f);
nf8 = round(nf/8);
SF = abs(fft(h,Nfft));     % ДПФ
% SF = -(SF-max(SF));        % формирование режекторного фильтра
plot(f(1:nf8),SF(1:nf8),'-k','LineWidth',2);
xlabel('Frequency, Hz'); title('АЧХ фильтра');
xlim([0 f(nf8)]); grid on;