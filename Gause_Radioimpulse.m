clear; close all;

% Формирование радиоимпульса с гауссовой огибающей и расчет его АЧС

fs    = 16e3;                       % частота дискретизации
dt    = 1/fs;                       % период дискретизации
t     = -10e-3:dt:10e-3;            % массив отсчетов времени
fc    = 4e3;                        % несущая частота
bw    = 0.1;                        % относительная ширина спектра
bwr   = -20;                        % уровень измерения ширины спектра
s     = gauspuls(t,fc,bw,bwr);
Nfft  = 2^nextpow2(length(s));
sp    = fft(s,Nfft);                % спектр сигнала
sp_dB = 20*log10(abs(sp));          % амплитудный спектр в дБ
f     = 0:fs/Nfft:fs-fs/Nfft;       % массив частот сигнала
% График сигнала
plot(t,s,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
pause;
% График амплитудного спектра
plot(f(1:Nfft/2),sp_dB(1:Nfft/2),'-k'); grid on;
xlabel('Frequency, Hz'); ylabel('Magnitude, dB');
pause;
sp_max_dB = 20*log10(max(abs(sp))); % максимальный уровень спектра в дБ
edges     = fc*[1-bw/2 1+bw/2];     % граничные частоты
% Отображение заданных границ спектра
hold on;
plot(edges,sp_max_dB([1 1])+bwr,'ok');
hold off;