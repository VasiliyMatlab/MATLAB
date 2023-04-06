clear; close all;

T = 0.1e-3;
f1 = 1e6;
f2 = 2e6;
f3 = 2.7e6;
fmax = max([f1 f2 f3]);
dt = 1/4/fmax;
t = 0:dt:T-dt;

S1c = 1*cos(2*pi*f1*t);
S1s = 1*sin(2*pi*f1*t);
S1 = complex(S1c,S1s);
S2c = 0.4*cos(2*pi*f2*t+pi/2);
S2s = 0.4*sin(2*pi*f2*t+pi/2);
S2 = complex(S2c,S2s);
S3c = 0.75*cos(2*pi*f3*t-pi/4);
S3s = 0.75*sin(2*pi*f3*t-pi/4);
S3 = complex(S3c,S3s);
S = S1+S2+S3+complex(0.5*randn(1,length(t)),0.5*randn(1,length(t)));
plot(t,real(S)); grid on;
pause;

SF = fft(S);
SF_mod = abs(SF)/length(t);
SF_phase = angle(SF);
Fmax = 4*fmax;
F = linspace(0,Fmax,length(t));
subplot(2,1,1);
plot(F,SF_mod); grid on;
title('Amplitude spectrum');
xlabel('Frequency, Hz'); ylabel('Amplitude');
subplot(2,1,2);
plot(F,SF_phase); grid on;
xlabel('Frequency, Hz'); ylabel('Phase, rad');
title('Phase spectrum');