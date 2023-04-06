clear; close all;

% Программа для вычисления КЧХ фильтра Баттерворта n-ого порядка (не имеет
% нулей)

n = 5;                                               % порядок фильтра Баттерворта
[z,p,k] = buttap(n);                                 % вычисление нулей, полюсов и общего коэф. усиления
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