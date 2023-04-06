clear; close all;

A = 3;
Tbegin = -4e-3;
Tend   = 4e-3;
fs = 1e6;
dt = 1/fs;
t  = Tbegin:dt:Tend-dt;
nt = length(t);

% S = A*exp(-1000*t).*heaviside(t);
% S  = A*cos(2*pi*1e3*t);
% S = A*ones(1,nt);
S = A*(heaviside(t+2e-3)-heaviside(t-2e-3));
plot(t,S); grid on;
title('Signal');
xlabel('Time, s'); ylabel('Amplitude, V');
pause;

N = nt;
% S = S.*(hamming(nt))';
SF  = fftshift(fft([S zeros(1,N-nt)]));
SFA = abs(SF);
% SFA = SFA/nt;
% SFA = SFA/fs;
SFP = angle(SF);

f = -fs/2:fs/N:fs/2-fs/N;
plot(f,SFA); grid on;
title('Amplitude spectrum');
xlabel('Frequency, Hz');
xlim([-0.5e4 0.5e4]);
pause;
plot(f,SFP); grid on;
title('Phase spectrum');
xlabel('Frequency, Hz');
xlim([-0.5e4 0.5e4]);
pause;

Out = ifft(ifftshift(SF));
plot(t,Out); grid on;