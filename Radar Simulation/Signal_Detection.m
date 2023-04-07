clear; close all;

%% 1. ��������� ������������ �������
% ������� ��������� �������
A1 = 0.6*rand(1,1)+0.4;   % ��������� ������� �������, B
A2 = 0.6*rand(1,1)+0.4;   % ��������� ������� �������, B
A3 = 0.6*rand(1,1)+0.4;   % ��������� �������� �������, B
f1 = 4e6+rand(1,1)*4e6;   % ������� ������� �������, ��
f2 = 12e6+rand(1,1)*12e6; % ������� ������� �������, ��
f3 = 27e6+rand(1,1)*27e6; % ������� �������� �������, ��
phi1 = randn(1,1);        % ���. ���� ������� �������, ���
phi2 = randn(1,1);        % ���. ���� ������� �������, ���
phi3 = randn(1,1);        % ���. ���� �������� �������, ���
T  = 1e-6;                % ����� ����������, �
fd = 20*max([f1 f2 f3]);  % ������� �������������, ��
dt = 1/fd;                % ��� ��������� �������, �
t  = 0:dt:T-dt;           % ������ �������
nt = length(t);           % ����� �������� �������, ��.
f  = linspace(0,fd,nt);   % ������ �������

% ����� ���������� �� �����
fprintf("��������� ������������ ������� (���������� ����������):\n");
fprintf("A1 = %g, f1 = %g ��, phi1 = %g ���\n",A1,f1,phi1);
fprintf("A2 = %g, f2 = %g ��, phi2 = %g ���\n",A2,f2,phi2);
fprintf("A3 = %g, f3 = %g ��, phi3 = %g ���\n",A3,f3,phi3);

%% 2. �������, ���������� � �����������
% ������������ ��������
S1 = A1*cos(2*pi*f1*t+phi1);
S2 = A2*cos(2*pi*f2*t+phi2);
S3 = A3*cos(2*pi*f3*t+phi3);

% ����������� ��������
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

%% 3. ��������� ����������� ������
% ���������� ����������� ��������
S1_comp = Complex_Signal(A1,f1,phi1,t);                          % ������ ������
S2_comp = Complex_Signal(A2,f2,phi2,t);                          % ������ ������
S3_comp = Complex_Signal(A3,f3,phi3,t);                          % ������ ������
S = S1_comp+S2_comp+S3_comp;                                     % ��������� ������
S_input = S+0.25*complex(randn(1,length(S)),randn(1,length(S))); % ��������� ������ � �����

% ����������� ���������� �������
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

%% 4. ������������ ������ �� ������ ���
% ���������� ��������
SF_input = fft(S_input);        % ����������� ������
SFA_input = abs(SF_input)*2/nt; % ����������� ������
SFP_input = angle(SF_input);    % ������� ������

% ����������� ��������
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

%% 5. CFAR-���������
% ���������� ������
Porog = CFAR(SFA_input,3,1,0.85);

% ����������� ������
subplot(2,1,1);
line(f,Porog,'Color','Red');
legend('Amplitude spectrum','CFAR limit');
pause;

% ���������� ������ � ��������
k = Porog<SFA_input;
SFA_input = k.*SFA_input;
SFP_input = k.*SFP_input;

% ����������� ����� ��������
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

%% 6. ��������� ��������� ������� �� ������ ����
% ����
Output = ifft(SFA_input/2*nt.*exp(1j*SFP_input));

% ����������� ������� � ����� � ��� ����
figure;
plot(t,real(S_input),'-b'); grid on;
line(t,real(Output),'Color','Red','LineWidth',1.75);
xlabel('Time, s'); ylabel('Amplitude, V');
title('Input signal and one without noise');
legend('Input signal','Input signal without noise');
pause;

%% 7. ��������� ���������� ����������
% ���������� ��������� ��������� � ����������� ��������
plot(t,real(S),'-b',t,real(Output),'-r'); grid on;
xlabel('Time, s'); ylabel('Amplitude, V');
title('Comparison of initial and received signals');
legend('Initial signal','Received signal');
pause;

% ���������� � ����������� ��������� �����������
D = abs(real(S)-real(Output));
sigma = trapz(t,D.^2);
stem(t,D); grid on;
xlabel('Time, s'); ylabel('The difference of the amplitudes, V');
title('Unit error');

% ����� ������ �� �����
fprintf("\n������� �������������� ���������� = %g �*c\n",sigma);
fprintf("������� �������� ����������� = %g � \n",sum(D)/nt);