clear; close all;

T     = 10;
N     = 1000;
t     = linspace(0,T,N);
X     = linspace(0,10,N);
% Track = exp(-X/12.5).*abs(2*cos(2*pi*0.25/1*X-pi/3));
% Track = 2*exp(-X.^2/2)+exp((X-5)/5);
% Track = 0.1*abs(randn(1,N)); Track(650) = 2.9;
plot(X,Track); grid on;
ylim([0 3]);
pause;

figure;
xlim([X(1) X(N)]);
ylim([0 3]);
grid on; B = zeros(1,N);
xlabel('X, m'); ylabel('Y, m');
for i = 1:N
    if i ~= 1
        delete(H);
        delete(ML);
        delete(L);
    end
    H = rectangle('Position',[X(i)-0.1 Track(i)-0.05 0.2 0.1],'Curvature',[1 1],'FaceColor','Blue','EdgeColor','Black');
    title('t = '+string(num2str(t(i)))+' s');
    M = mean(Track(1:i));
    B(1,i) = M;
    M = M*ones(1,N);
    ML = line(X,M,'Color','Red','LineWidth',2);
    L = line(X(1:i),Track(1:i),'Color','Black','LineStyle','--');
    pause(t(2)-t(1));
end
pause;

figure;
plot(X,B,'-r'); grid on;
title('ѕоложение мат. ожидани€ в каждый момент времени');
xlabel('X, m'); ylabel('Y, m');