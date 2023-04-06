clear;

%   Построение графика модуля низкочастотного фильтра
w = linspace(10,1e6,100000);
disp('Введите значения R и L:')
R = input('R = ');
L = input('L = ');
RV = LRFilt(R,L,w);
semilogx(w,RV,'-k','LineWidth',1.5);
grid on;
xlabel('\omega, рад/с');
ylabel('V_R/V_0, б/р');
title('АЧХ низкочастотного фильтра');