clear;

%   ���������� ������� ������ ��������������� �������
w = linspace(10,1e6,100000);
disp('������� �������� R � L:')
R = input('R = ');
L = input('L = ');
RV = LRFilt(R,L,w);
semilogx(w,RV,'-k','LineWidth',1.5);
grid on;
xlabel('\omega, ���/�');
ylabel('V_R/V_0, �/�');
title('��� ��������������� �������');