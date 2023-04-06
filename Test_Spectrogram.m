clear; close all;

f0   = 100;            % опорная частота
Fd   = 200;            % девиация частоты
fs   = 20*f0;          % частота дискретизации
dt   = 1/fs;           % период дискретизации
T    = 0:dt:600/f0-dt; % отсчеты времени
Tn   = T(end);         % время наблюдения (за которое достигаем f = Fd)
beta = (Fd-f0)/Tn;     % коэффициент изменения частоты

% s = cos(2*pi*f0*T);
s = chirp(T,f0,Tn,Fd);

[~,f,t,p]     = spectrogram(s,hann(1024),512,1024,fs,'yaxis');
[fridge,~,lr] = tfridge(p,f);
fridge        = fridge*1e-3;

spectrogram(s,hann(1024),512,1024,fs,'yaxis')
hold on;
plot3(t,fridge,abs(p(lr)),'r','LineWidth',4)
hold off;