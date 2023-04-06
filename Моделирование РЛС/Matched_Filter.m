clear; close all;

%% Задание опорного сигнала
f0 = 10e6;                         % опорная частота
fs = 20*f0;                        % частота дискретизации
dt = 1/fs;                         % шаг дискретизации по времени
tau_oporn = 20e-6;                 % длительность опорного сигнала
t_oporn = 0:dt:tau_oporn-dt;       % массив времени опорного сигнала
N_oporn = length(t_oporn);         % число ячеек в массиве времени опорного сигнала
S_oporn = exp(1j*2*pi*f0*t_oporn); % опорный сигнал

%% Формирование входного сигнала
tau = 1e-3;                        % длительность принимаемого (входного) сигнала
t = 0:dt:tau-dt;                   % массив времени принимаемого сигнала
N = length(t);                     % число ячеек в массиве времени принимаемого сигнала
S = zeros(1,N);                    % инициализация входного сигнала
Num_targ = 3;                      % число полезных сигналов во входном сигнале
Signals = zeros(Num_targ,N);       % инициализация полезных сигналов
Signals(1,:) = [zeros(1,round(140e-6/dt)) 0.5*exp(1j*(2*pi*f0*t_oporn+pi/2))  zeros(1,N-round(140e-6/dt)-N_oporn)];
Signals(2,:) = [zeros(1,round(430e-6/dt)) 1.75*exp(1j*(2*pi*f0*t_oporn-pi/6)) zeros(1,N-round(430e-6/dt)-N_oporn)];
Signals(3,:) = [zeros(1,round(780e-6/dt)) 1.1*exp(1j*(2*pi*f0*t_oporn))       zeros(1,N-round(780e-6/dt)-N_oporn)];
for i = 1:Num_targ
    S = S+Signals(i,:);
end
noise_lvl = 2;                                       % уровень шума
Snoise = S+noise_lvl*complex(randn(1,N),randn(1,N)); % добавление шумов

% Вывод входного сигнала без шумов и с шумом
plot(t,real(S)); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Input signal');
pause;
plot(t,real(Snoise)); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Input signal with noise');
pause;

%% Вычисление сигнала на выходе СФ
C = xcorr(Snoise,S_oporn); % вычисление коэффициентов корреляции
NC = length(C);            % число отсчетов коэффициентов корреляции
T = (0:dt:(NC-1)*dt)-tau;
H = round(NC/2);
plot(T(H:end),real(C(H:end))); grid on;
xlabel('Time, s'); ylabel('Amplitude*Time, V*s');
title('ACF');
pause;
plot(T(H:end),abs(C(H:end))); grid on;
xlabel('Time, s'); ylabel('Amplitude*Time, V*s');
title('Module of ACF');