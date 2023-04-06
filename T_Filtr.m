clear;

f0 = 20e6;         % частота низкочастотного сигнала
f1 = 200e6;        % частота высокочастотного сигнала
f2 = 300e6;
f3 = 400e6;
Fsm = 10*f1;        % частота дискретизации
dt = 1/Fsm;         % период дискретизации
Ts = 10e-6;        % длительность сигнала
T  = 0:dt:Ts-dt;   % массив отсчетов времени
nT = length(T);
S0 = sin(2*pi*f0.*T + 0.1*2*pi.*ones(1,nT));
S1 = sin(2*pi*f1.*T);
S2 = sin(2*pi*f2.*T);
S3 = sin(2*pi*f3.*T);
Ssum = S0 + S1 + S2 + S3;
% Ssum = S0;
FS   = fft(Ssum);
nFS  = length(FS);
nFS2 = round(nFS/2);
disp('plot Ssum');
plot(T,Ssum); grid on; pause;
disp('plot Spectr');
plot(abs(FS)); grid on; pause;
nKI = 160;
KI =(-nKI:nKI)';
BI = sinc(KI/40)/4;
BI = BI.*hamming(2*nKI+1);
impz(BI)
pause;
[FHI,F] = freqz(BI,1,nFS2);
for i = 1:nFS2
    FHI(nFS2+i) = FHI(nFS2-i+1);
end
plot(abs(FHI)); pause;
FS_out = FS'.*FHI;
plot(abs(FS_out)); pause;
S_out = ifft(FS_out);
plot(real(S_out(1:1000)));




