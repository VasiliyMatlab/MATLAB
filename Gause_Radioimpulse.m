clear; close all;

% ������������ ������������� � ��������� ��������� � ������ ��� ���

fs    = 16e3;                       % ������� �������������
dt    = 1/fs;                       % ������ �������������
t     = -10e-3:dt:10e-3;            % ������ �������� �������
fc    = 4e3;                        % ������� �������
bw    = 0.1;                        % ������������� ������ �������
bwr   = -20;                        % ������� ��������� ������ �������
s     = gauspuls(t,fc,bw,bwr);
Nfft  = 2^nextpow2(length(s));
sp    = fft(s,Nfft);                % ������ �������
sp_dB = 20*log10(abs(sp));          % ����������� ������ � ��
f     = 0:fs/Nfft:fs-fs/Nfft;       % ������ ������ �������
% ������ �������
plot(t,s,'-k'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
pause;
% ������ ������������ �������
plot(f(1:Nfft/2),sp_dB(1:Nfft/2),'-k'); grid on;
xlabel('Frequency, Hz'); ylabel('Magnitude, dB');
pause;
sp_max_dB = 20*log10(max(abs(sp))); % ������������ ������� ������� � ��
edges     = fc*[1-bw/2 1+bw/2];     % ��������� �������
% ����������� �������� ������ �������
hold on;
plot(edges,sp_max_dB([1 1])+bwr,'ok');
hold off;