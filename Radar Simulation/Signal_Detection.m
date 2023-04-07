clear; close all;

%% 1. Параметры принимаемого сигнала
% Задание парметров сигнала
A1 = 0.6*rand(1,1)+0.4;   % амплитуда первого сигнала, B
A2 = 0.6*rand(1,1)+0.4;   % амплитуда второго сигнала, B
A3 = 0.6*rand(1,1)+0.4;   % амплитуда третьего сигнала, B
f1 = 4e6+rand(1,1)*4e6;   % частота первого сигнала, Гц
f2 = 12e6+rand(1,1)*12e6; % частота второго сигнала, Гц
f3 = 27e6+rand(1,1)*27e6; % частота третьего сигнала, Гц
phi1 = randn(1,1);        % нач. фаза первого сигнала, рад
phi2 = randn(1,1);        % нач. фаза второго сигнала, рад
phi3 = randn(1,1);        % нач. фаза третьего сигнала, рад
T  = 1e-6;                % время наблюдения, с
fd = 20*max([f1 f2 f3]);  % частота дискретизации, Гц
dt = 1/fd;                % шаг изменения времени, с
t  = 0:dt:T-dt;           % вектор времени
nt = length(t);           % число отсчетов времени, шт.
f  = linspace(0,fd,nt);   % вектор частоты

% Вывод параметров на экран
fprintf("Параметры принимаемого сигнала (изначально неизвестны):\n");
fprintf("A1 = %g, f1 = %g Гц, phi1 = %g рад\n",A1,f1,phi1);
fprintf("A2 = %g, f2 = %g Гц, phi2 = %g рад\n",A2,f2,phi2);
fprintf("A3 = %g, f3 = %g Гц, phi3 = %g рад\n",A3,f3,phi3);

%% 2. Сигналы, заложенные в принимаемом
% формирование сигналов
S1 = A1*cos(2*pi*f1*t+phi1);
S2 = A2*cos(2*pi*f2*t+phi2);
S3 = A3*cos(2*pi*f3*t+phi3);

% Отображение сигналов
subplot(3,1,1);
plot(t,S1); grid on;
title('First signal');
xlabel('Time, s'); ylabel('Amplitude, V');
ylim([-1 1]);
subplot(3,1,2);
plot(t,S2); grid on;
title('Second signal');
xlabel('Time, s'); ylabel('Amplitude, V');
ylim([-1 1]);
subplot(3,1,3);
plot(t,S3); grid on;
title('Third signal');
xlabel('Time, s'); ylabel('Amplitude, V');
ylim([-1 1]);
pause;

%% 3. Суммарный принимаемый сигнал
% Вычисление комплексных сигналов
S1_comp = Complex_Signal(A1,f1,phi1,t);                          % первый сигнал
S2_comp = Complex_Signal(A2,f2,phi2,t);                          % второй сигнал
S3_comp = Complex_Signal(A3,f3,phi3,t);                          % третий сигнал
S = S1_comp+S2_comp+S3_comp;                                     % суммарный сигнал
S_input = S+0.25*complex(randn(1,length(S)),randn(1,length(S))); % суммарный сигнал с шумом

% Отображение суммарного сигнала
figure;
subplot(2,1,1);
plot(t,real(S)); grid on;
title('Input signal');
xlabel('Time, s'); ylabel('Amplitude, V');
subplot(2,1,2);
plot(t,real(S_input)); grid on;
title('Input signal with noise (real signal)');
xlabel('Time, s'); ylabel('Amplitude, V');
pause;

%% 4. Спектральный анализ на основе БПФ
% Вычисление спектров
SF_input = fft(S_input);        % комплексный спектр
SFA_input = abs(SF_input)*2/nt; % амплитудный спектр
SFP_input = angle(SF_input);    % фазовый спектр

% Отображение спектров
subplot(2,1,1);
plot(f,SFA_input); grid on;
xlabel('Frequency, Hz'); ylabel('Amplitude, V');
title('Amplitude spectrum'); xlim([0 fd]);
subplot(2,1,2);
plot(f,SFP_input); grid on;
xlabel('Frequency, Hz'); ylabel('Phase, rad');
title('Phase spectrum'); xlim([0 fd]);
ylim([-3.5 3.5]);
pause;

%% 5. CFAR-обработка
% Вычисление порога
Porog = CFAR(SFA_input,3,1,0.85);

% Отображение порога
subplot(2,1,1);
line(f,Porog,'Color','Red');
legend('Amplitude spectrum','CFAR limit');
pause;

% Применение порога к спектрам
k = Porog<SFA_input;
SFA_input = k.*SFA_input;
SFP_input = k.*SFP_input;

% Отображение новых спектров
subplot(2,1,1);
plot(f,SFA_input); grid on;
xlabel('Frequency, Hz'); ylabel('Amplitude, V');
title('Amplitude spectrum after CFAR processing'); xlim([0 fd]);
subplot(2,1,2);
plot(f,SFP_input); grid on;
xlabel('Frequency, Hz'); ylabel('Phase, rad');
title('Phase spectrum after CFAR processing'); xlim([0 fd]);
ylim([-3.5 3.5]);
pause;

%% 6. Получение исходного сигнала на основе ОБПФ
% ОБПФ
Output = ifft(SFA_input/2*nt.*exp(1j*SFP_input));

% Отображение сигнала с шумом и без него
figure;
plot(t,real(S_input),'-b'); grid on;
line(t,real(Output),'Color','Red','LineWidth',1.75);
xlabel('Time, s'); ylabel('Amplitude, V');
title('Input signal and one without noise');
legend('Input signal','Input signal without noise');
pause;

%% 7. Обработка полученных результаов
% Визуальное сравнение исходного и полученного сигналов
plot(t,real(S),'-b',t,real(Output),'-r'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Comparison of initial and received signals');
legend('Initial signal','Received signal');
pause;

% Вычисление и отображение суммарной погрешности
D = abs(real(S)-real(Output));
sigma = trapz(t,D.^2);
stem(t,D); grid on;
xlabel('Time, s'); ylabel('The difference of the amplitudes, V');
title('Unit error');

% Вывод отчета на экран
fprintf("\nСреднее квадратическое отклонение = %g В*c\n",sigma);
fprintf("Средняя удельная погрешность = %g В \n",sum(D)/nt);