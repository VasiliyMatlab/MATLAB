clear; close all;

% ��������� ������������� ������ ��������������� ������, �������������� ��
% ��������� � ���

%% 1. ���� �������� ������
F  = 1e6;       % ������� ��������������� �������
f0 = 1e9;       % ������� �������
fp = 10e6;      % ������������� �������
fs = 20*f0;     % ������� �������������
dt = 1/fs;      % ������ �������������
T  = 3/F;       % ����� ���������� �������
t  = 0:dt:T-dt; % ������ �������� �������
nt = length(t); % ����� �������� � ������� �������
A  = 2.5;       % ��������� ��������������� �������
ph = 0;         % ��������� ���� ��������������� �������
C  = 3;         % ���������� ������������ �������

%% 2. ���������� � ������������ ��������
s1 = (C+A*cos(2*pi*F*t+ph)).*cos(2*pi*f0*t); % ������ �� ����� ��������������� 
s2 = cos(2*pi*(f0-fp)*t);                    % ������ ����������
s3 = s1.*s2;                                 % ������ �� ������ ���������

subplot(3,1,1);
plot(t,s1,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('�������������� ������');
subplot(3,1,2);
plot(t,s2,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('������ ����������');
subplot(3,1,3);
plot(t,s3,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('������ �� ������ ���������');
pause;

%% 3. ���������� � ������������ �������� ��������
N  = 2^(nextpow2(nt)+3);   % ����� ����� ��������
F  = -fs/2:fs/N:fs/2-fs/N; % ������ �������� �������
nF2    = round(length(F)/2);
nF8    = round(length(F)/8);
nF16   = round(length(F)/16);
nF1024 = round(length(F)/1024);
s1 = [s1 zeros(1,N-nt)];   % ���������� �������� ������� ������
s2 = [s2 zeros(1,N-nt)];   % ���������� ������� ���������� ������
s3 = [s3 zeros(1,N-nt)];   % ���������� ������� �� ������ ��������� ������
S1 = fftshift(fft(s1));    % ��� �������� �������
S2 = fftshift(fft(s2));    % ��� ������� ����������
S3 = fftshift(fft(s3));    % ��� ������� �� ������ ���������

subplot(3,1,1);
plot(F(nF2-nF16:nF2+nF16),abs(S1(nF2-nF16:nF2+nF16)),'-k');
xlabel('Frequency, Hz'); grid on;
title('�� ��������������� �������');
subplot(3,1,2);
plot(F(nF2-nF16:nF2+nF16),abs(S2(nF2-nF16:nF2+nF16)),'-k');
xlabel('Frequency, Hz'); grid on;
title('�� ������� ����������');
subplot(3,1,3);
plot(F(nF2-nF8:nF2+nF8),abs(S3(nF2-nF8:nF2+nF8)),'-k');
xlabel('Frequency, Hz'); grid on;
title('�� ������� �� ������ ���������');
pause;

%% 4. ������������� ���
figure;
tf = -T/2:dt:T/2-dt;         % ������ �������� �������
h  = 1/16*sinc(pi*tf*200e6); % �� �������
subplot(2,1,1);
plot(tf,h,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, Hz');
title('�� �������');
subplot(2,1,2);
h = h.*(hamming(nt))';       % ���������� �� �� ���� ��������
h = [h zeros(1,N-nt)];       % ���������� �� ������
H = fftshift(fft(h));        % ������ �������
plot(F(nF2-nF16:nF2+nF16),abs(H(nF2-nF16:nF2+nF16)),'-k');
xlabel('Frequency, Hz'); grid on;
title('��� �������');
pause;

%% 5. ���������� � ������������ ������� �� ������ �������
S_out = H.*S3;                 % ������ ��������� �������
s_out = conv(h,s3);            % �������� ������
s_out = s_out(nt/2:nt+nt/2-1); % ��������� ��������� �����
subplot(2,1,1);
plot(t,s_out,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('������ �� ������ ���');
subplot(2,1,2);
plot(F(nF2-nF1024:nF2+nF1024),abs(S_out(nF2-nF1024:nF2+nF1024)),'-k');
xlabel('Frequency, Hz'); grid on;
title('�� ������� �� ������ ���');