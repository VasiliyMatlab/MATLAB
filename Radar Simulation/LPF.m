clear; close all;

% ������ ���������� ����� ���� ������������� ��������

f1 = 5e4;                     % ������� ��������������� �������
f2 = 2e6;                     % ������� ���������������� �������
ts = 2e-4;                    % ������������ ����� ��������
fs = 10*f2;                   % ������� �������������
dt = 1/fs;                    % ������ �������������
T  = 0:dt:ts;                 % ������ �������� �������
nT = length(T);               % ����� �������� ������� �
dF = fs/nT;                   % ��� ���������� �������
S  = 0.1*cos(2*pi*f1*T)+1.0*cos(2*pi*f2*T);
plot(T,S,'-k','LineWidth',2); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Input signal'); xlim([0 2e-4]);
pause;
SF  = fft(S);                 % ���������� ������� ����� ��������
FX  = 0:dF:dF*(nT-1);         % ������ �������� �������
nf2 = round(length(FX)/2);
nf4 = round(nf2/4);
plot(FX(1:nf4),abs(SF(1:nf4)),'-k','LineWidth',2); grid on;
xlabel('Frequency, Hz'); title('Amplitude spectrum');
pause;
Hi    = sinc(-10:0.05:10);    % �� ���� sinc()
nHi   = length(Hi);           % ����� �������� ��
Hi    = Hi.*(hamming(nHi))';  % ��������� �� �� ���� ��������
Hi    = [Hi zeros(1,nT-nHi)]; % ���������� ������
FH    = fft(Hi);              % ��� ��� ���������� �� �������
plot(FX(1:nf4),abs(FH(1:nf4)),'-k','LineWidth',2); grid on;
xlabel('Frequency, Hz'); title('AFS of LPF');
pause;
S_out = conv(Hi,S);           % ���������� ����� �������
plot(T(nHi:nT),S_out(nHi:nT),'-k','LineWidth',2); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Output signal'); xlim([0.2e-4 2e-4]);