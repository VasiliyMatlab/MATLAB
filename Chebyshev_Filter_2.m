clear; close all;

% ��������� ��� ���������� ��� ������� �������� ������� ���� n-��� �������
% (������� ����)

n       = 5;                                         % ������� �������
Rs      = 20;                                        % ������� ��������� � ������ ���������� (��)                                      
[z,p,k] = cheb2ap(n,Rs);                             % ���������� �����, ������� � ������ ����. ��������
plot(p,'xk','LineWidth',2); grid on; hold on;        % ���
plot(z,'ok','LineWidth',2);
axis equal; axis([-1.5 1.5 -1.5 1.5]);
xlabel('Re'); ylabel('Im');
title('���� � ������ �������');
pause;
w     = 0:0.01:5;                                    % ������ ������
[b,a] = zp2tf(z,p,k);                                % ���������� ����. ��������� ��������� � �����������
h     = freqs(b,a,w);                                % ���������� ��� �������
figure;
plot(w,abs(h),'k','LineWidth',2); grid on;           % ���
xlabel('\omega, ���/�'); ylabel('|K|, -');
title('��� ������');
pause;
plot(w,unwrap(angle(h)),'k','LineWidth',2); grid on; % ���
xlabel('\omega, ���/�'); ylabel('arg(K), ���');
title('��� �������');