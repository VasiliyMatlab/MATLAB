clear; close all;

%% ������� �������� �������
f0 = 10e6;                         % ������� �������
fs = 20*f0;                        % ������� �������������
dt = 1/fs;                         % ��� ������������� �� �������
tau_oporn = 20e-6;                 % ������������ �������� �������
t_oporn = 0:dt:tau_oporn-dt;       % ������ ������� �������� �������
N_oporn = length(t_oporn);         % ����� ����� � ������� ������� �������� �������
S_oporn = exp(1j*2*pi*f0*t_oporn); % ������� ������

%% ������������ �������� �������
tau = 1e-3;                        % ������������ ������������ (��������) �������
t = 0:dt:tau-dt;                   % ������ ������� ������������ �������
N = length(t);                     % ����� ����� � ������� ������� ������������ �������
S = zeros(1,N);                    % ������������� �������� �������
Num_targ = 3;                      % ����� �������� �������� �� ������� �������
Signals = zeros(Num_targ,N);       % ������������� �������� ��������
Signals(1,:) = [zeros(1,round(140e-6/dt)) 0.5*exp(1j*(2*pi*f0*t_oporn+pi/2))  zeros(1,N-round(140e-6/dt)-N_oporn)];
Signals(2,:) = [zeros(1,round(430e-6/dt)) 1.75*exp(1j*(2*pi*f0*t_oporn-pi/6)) zeros(1,N-round(430e-6/dt)-N_oporn)];
Signals(3,:) = [zeros(1,round(780e-6/dt)) 1.1*exp(1j*(2*pi*f0*t_oporn))       zeros(1,N-round(780e-6/dt)-N_oporn)];
for i = 1:Num_targ
    S = S+Signals(i,:);
end
noise_lvl = 2;                                       % ������� ����
Snoise = S+noise_lvl*complex(randn(1,N),randn(1,N)); % ���������� �����

% ����� �������� ������� ��� ����� � � �����
plot(t,real(S)); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Input signal');
pause;
plot(t,real(Snoise)); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Input signal with noise');
pause;

%% ���������� ������� �� ������ ��
C = xcorr(Snoise,S_oporn); % ���������� ������������� ����������
NC = length(C);            % ����� �������� ������������� ����������
T = (0:dt:(NC-1)*dt)-tau;
H = round(NC/2);
plot(T(H:end),real(C(H:end))); grid on;
xlabel('Time, s'); ylabel('Amplitude*Time, V*s');
title('ACF');
pause;
plot(T(H:end),abs(C(H:end))); grid on;
xlabel('Time, s'); ylabel('Amplitude*Time, V*s');
title('Module of ACF');