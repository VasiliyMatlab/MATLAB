clear; close all;

% ��������� ������������ ����������� � ����������� �������������

%% ���� �������� ������ ��������
f0    = 100e6;         % ������� �������
fs    = 20*f0;         % ������� �������������
dt    = 1/fs;          % ������ �������������
t_per = 20e-6;         % ������������ ������� ���������� ���������
n_per = round(t_per/dt);
t_imp = 1e-6;          % ������������ ��������
n_imp = round(t_imp/dt);
t_zad = 12e-6;         % ����� ��������
n_zad = round(t_zad/dt);
n_ost = n_per-n_zad-n_imp;
A_out = 1;             % ��������� ��������� �������
A_inp = 1/(t_zad*7e6); % ��������� �������� �������
phase = 2*pi*rand(1);  % ���. ���� �������� �������

%% ������������ ��������
T_per = 0:dt:dt*(n_per-1);
T_imp = 0:dt:dt*(n_imp-1);
S_out = A_out*cos(2*pi*f0*T_imp);
S_inp = A_inp*cos(2*pi*f0*T_imp+phase);
S_out = [S_out zeros(1,n_per-n_imp)];             % �������� ������
S_inp = [zeros(1,n_zad) S_inp zeros(1,n_ost)];    % ������� ������
plot(T_per,S_out,'-b',T_per,S_inp,'-r'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
xlim([T_per(1) T_per(end)]); ylim([-A_out A_out]);
title('Output and Input signals'); legend('S_{output}','S_{input}');
pause;

%% ���������� ���� �� ������� ������
S_inp = S_inp+0.025*randn(1,n_per);
plot(T_per,S_inp,'-r'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
xlim([T_per(1) T_per(end)]); ylim([-A_out A_out]);
title('Input signal with noise'); legend('S_{input}');