function s = IDTFT(S,n,phi)
% Функция для вычисления ОДВПФ дискретного сигнала
%   S   - спектр дискретного сигнала
%   n   - отсчеты дискретного времени
%   phi - вектор частот (нормированных относительно частоты дискретизации)
%   s   - дискретный сигнал

left = -0.5;
right = 0.5;
[~,left] = min(abs(phi-left));
[~,right] = min(abs(phi-right));
phi = phi(left:right);
S = S(left:right);
s = zeros(1,length(n));
for k = 1:length(n)
    s(k) = trapz(phi,S.*exp(-2j*pi*phi*n(k)));
end

end