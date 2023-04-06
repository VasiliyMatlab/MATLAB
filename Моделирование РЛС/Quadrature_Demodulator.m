clear; close all;

% ��������� ������������� ������ ������������� ������������

%% ���� �������� ������
f0 = 10e9;       % ������� �������
fg = f0;         % ������� ����������
fs = 20*f0;      % ������� �������������
dt = 1/fs;       % ������ �������������
ts = 0.1e-6;     % ������������ ��������
T  = 0:dt:ts-dt; % ������ �������� ������� ��������
nT = length(T);
A  = 1;          % ��������� �������
phase = pi/4;    % ���. ���� �������

%% ������������ �������
S = A*cos(2*pi*f0*T+phase);          % ������������ �������������
S = [zeros(1,2*nT) S zeros(1,2*nT)]; % ����������� � �������� �������
S  = hilbert(S);                     % ������������ ������������ �������
nS = length(S); nS4 = round(nS/4);
TS = 0:dt:dt*(nS-1);                 % ������ �������� ������� ������ �������
plot(TS,real(S),'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
xlim([TS(1) TS(end)+dt]); ylim([-A A]);
title('Radioimpulse');
pause;

%% ��������� + ���
SG = hilbert(A*cos(2*pi*fg*TS)); % ������ ����������
SM = real(S).*SG;                % ������ �� ������ ���������
Hi = sinc(-10:0.08:10);          % �� ���
nHi = length(Hi);                % ����� �������� ��
Hi  = Hi.*(hamming(nHi))';       % ��������� �� �� ���� ��������
Hi = [Hi zeros(1,nS-nHi)];       % ���������� ������
HF = abs(fft(Hi));               % ���������� ��� ���
F = 0:fs/nS:fs-fs/nS;            % ������ �������� �������
nF8 = round(length(F)/8);
plot(F(1:nF8),HF(1:nF8),'-k','LineWidth',1.5); 
xlabel('Frequency, Hz'); grid on;
title('AFS of LPF');
pause;

SF = conv(Hi,SM); % ���������� ����� �������
SF = SF(1:nS);    % ����������� ������� ������������� �������
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

%% ��������� � ���
k = 200; % ����������� ������������
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