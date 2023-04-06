clear; close all;

% Программа для вычисления КЧХ фильтра Чебышева первого рода n-ого порядка
% (не имеет нулей)

n       = 5;                                         % порядок фильтра
Rp      = 0.5;                                       % уровень пульсаций в полосе пропускания (дБ)                                      
[z,p,k] = cheb1ap(n,Rp);                             % вычисление нулей, полюсов и общего коэф. усиления
plot(p,'xk','LineWidth',2); grid on;                 % ДНП
axis equal; axis([-1.5 1.5 -1.5 1.5]);
xlabel('Re'); ylabel('Im');
title('Нули и полюса фильтра');
pause;
w     = 0:0.01:5;                                    % вектор частот
[b,a] = zp2tf(z,p,k);                                % вычисление коэф. полиномов числителя и знаменателя
h     = freqs(b,a,w);                                % вычсиление КЧХ фильтра
figure;
plot(w,abs(h),'k','LineWidth',2); grid on;           % АЧХ
xlabel('\omega, рад/с'); ylabel('|K|, -');
title('АЧХ фильра');
pause;
plot(w,unwrap(angle(h)),'k','LineWidth',2); grid on; % ФЧХ
xlabel('\omega, рад/с'); ylabel('arg(K), рад');
title('ФЧХ фильтра');