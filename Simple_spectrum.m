clear; close all;

%% 1. Формирование сигнала
t = linspace(0,4e-4,100);
dt = 4e-4/100;
f0 = 10e3;
A = 5;
phi = 2*pi*rand(1,1);
V = A*cos(2*pi*f0*t+phi);
plot(t,V), grid on;
title('\phi_0 = '+string(num2str(phi))+' rad');
xlabel('t, c'); ylabel('V(t), V');
pause;

%% 2. Раскладывание сигнала на квадратуры и формирование комплексного сигнала
Vc = A/2*cos(2*pi*f0*t+phi);
Vs = A/2*sin(2*pi*f0*t+phi);
Vcomp = complex(Vc,Vs);

%% 3. БПФ (быстрое преобразование Фурье)
VF = fft(Vcomp);
VF_amp = abs(VF)/length(VF)*2;
VF_phase = angle(VF);
Fmax = 1/dt;
f = linspace(0,Fmax,length(VF));
subplot(2,1,1);
stem(f,VF_amp); grid on;
xlabel('Frequency, Hz'); ylabel('Amplitude, V');
title('Amplitude spectrum');
subplot(2,1,2);
stem(f,VF_phase); grid on;
xlabel('Frequency, Hz'); ylabel('Phase, rad');
title('Phase spectrum');