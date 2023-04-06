clear; close all;

t  = 0:0.01:8;             % ����� ��� ���������������� �������
td = 2:5;                  % ������ ��������� ��������
s  = [30 1 -1 -30];        % ���������� ������
d  = [td' s'];             % ������ ��� ������� pulstran
y  = pulstran(t,d,'sinc'); % ��������������� ������
plot(td,s,'ok',t,y,'-k'); grid on;