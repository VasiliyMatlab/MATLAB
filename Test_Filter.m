clear; close all;

% ������������ ��� ������� �� ��� ��

fc = 0;         % ����������� �������
fs = 1e5;       % ������� �������������
dt = 1/fs;      % ������ �������������
t  = 0:dt:2;    % ������ �������� �������
nt = length(t); % ���-�� �������� ������� t

% ���������� �� �������
h  = sinc((t-1)*1000)/50.*(hamming(nt))'.*exp(1j*2*pi*fc*t);
plot(t,real(h),'-k','LineWidth',2); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('�� �������');
pause;

% ���������� ��� �������
Nfft = 2^nextpow2(nt);     % ���-�� ������
f  = 0:fs/Nfft:fs-fs/Nfft; % ������ �������� ������
nf = length(f);
nf8 = round(nf/8);
SF = abs(fft(h,Nfft));     % ���
% SF = -(SF-max(SF));        % ������������ ������������ �������
plot(f(1:nf8),SF(1:nf8),'-k','LineWidth',2);
xlabel('Frequency, Hz'); title('��� �������');
xlim([0 f(nf8)]); grid on;