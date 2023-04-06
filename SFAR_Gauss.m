clear; close all;

fs = 10e3;
dt = 1/fs;
t  = 0:dt:0.1;
Signal = abs(gausswin(length(t),20)');
Signal = abs(Signal+0.2*randn(1,length(t))); 

window = 10;
S = conv(Signal,ones(1,window),'same')/window;
plot(t,Signal,'b',t,S,'r'); grid minor;

guard = 100;
training = 10;
CFAR = conv(S,[ones(1,training) zeros(1,2*guard+1) ones(1,training)],'same')/5;
C    = 2*mean(S)*ones(1,length(t));
plot(t,S,'b',t,CFAR,'r',t,C,'--k'); grid minor;