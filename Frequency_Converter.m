clear; close all;

% Программа моделирования работы преобразователя частот, реализованного на
% смесителе и ФНЧ

%% 1. Ввод исходных данных
F  = 1e6;       % частота информационного сигнала
f0 = 1e9;       % несущая частота
fp = 10e6;      % промежуточная частота
fs = 20*f0;     % частота дискретизации
dt = 1/fs;      % период дискретизации
T  = 3/F;       % время наблюдения сигнала
t  = 0:dt:T-dt; % массив отсчетов времени
nt = length(t); % число отсчетов в массиве времени
A  = 2.5;       % амплитуда информационного сигнала
ph = 0;         % начальная фаза информационного сигнала
C  = 3;         % постоянная составляющая сигнала

%% 2. Вычисление и визуализация сигналов
s1 = (C+A*cos(2*pi*F*t+ph)).*cos(2*pi*f0*t); % сигнал на входе преобразователя 
s2 = cos(2*pi*(f0-fp)*t);                    % сигнал гетеродина
s3 = s1.*s2;                                 % сигнал на выходе смесителя

subplot(3,1,1);
plot(t,s1,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Модулированный сигнал');
subplot(3,1,2);
plot(t,s2,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Сигнал гетеродина');
subplot(3,1,3);
plot(t,s3,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Сигнал на выходе смесителя');
pause;

%% 3. Вычисление и визуализация спектров сигналов
N  = 2^(nextpow2(nt)+3);   % новое число отсчетов
F  = -fs/2:fs/N:fs/2-fs/N; % массив отсчетов частоты
nF2    = round(length(F)/2);
nF8    = round(length(F)/8);
nF16   = round(length(F)/16);
nF1024 = round(length(F)/1024);
s1 = [s1 zeros(1,N-nt)];   % дополнение входного сигнала нулями
s2 = [s2 zeros(1,N-nt)];   % дополнение сигнала гетеродина нулями
s3 = [s3 zeros(1,N-nt)];   % дополнение сигнала на выходе смесителя нулями
S1 = fftshift(fft(s1));    % БПФ входного сигнала
S2 = fftshift(fft(s2));    % БПФ сигнала гетеродина
S3 = fftshift(fft(s3));    % БПФ сигнала на выходе смесителя

subplot(3,1,1);
plot(F(nF2-nF16:nF2+nF16),abs(S1(nF2-nF16:nF2+nF16)),'-k');
xlabel('Frequency, Hz'); grid on;
title('АС модулированного сигнала');
subplot(3,1,2);
plot(F(nF2-nF16:nF2+nF16),abs(S2(nF2-nF16:nF2+nF16)),'-k');
xlabel('Frequency, Hz'); grid on;
title('АС сигнала гетеродина');
subplot(3,1,3);
plot(F(nF2-nF8:nF2+nF8),abs(S3(nF2-nF8:nF2+nF8)),'-k');
xlabel('Frequency, Hz'); grid on;
title('АС сигнала на выходе смесителя');
pause;

%% 4. Модерирование ФНЧ
figure;
tf = -T/2:dt:T/2-dt;         % массив отсчетов времени
h  = 1/16*sinc(pi*tf*200e6); % ИХ фильтра
subplot(2,1,1);
plot(tf,h,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, Hz');
title('ИХ фильтра');
subplot(2,1,2);
h = h.*(hamming(nt))';       % домножение ИХ на окно Хэмминга
h = [h zeros(1,N-nt)];       % дополнение ИХ нулями
H = fftshift(fft(h));        % спектр фильтра
plot(F(nF2-nF16:nF2+nF16),abs(H(nF2-nF16:nF2+nF16)),'-k');
xlabel('Frequency, Hz'); grid on;
title('АЧХ фильтра');
pause;

%% 5. Вычисление и визуализация сигнала на выходе фильтра
S_out = H.*S3;                 % спектр выходного сигнала
s_out = conv(h,s3);            % выходной сигнал
s_out = s_out(nt/2:nt+nt/2-1); % вырезание ненулевой части
subplot(2,1,1);
plot(t,s_out,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Сигнал на выходе ФНЧ');
subplot(2,1,2);
plot(F(nF2-nF1024:nF2+nF1024),abs(S_out(nF2-nF1024:nF2+nF1024)),'-k');
xlabel('Frequency, Hz'); grid on;
title('АС сигнала на выходе ФНЧ');