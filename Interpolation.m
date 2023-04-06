clear;

%   »нтерпол€ци€ (линейна€, кубическа€, сплайнами)
x = -5:1:5;
y = 3*exp(-x.^2);
xi = linspace(x(1),x(end),1000);
yi = 3*exp(-xi.^2);

yilin = interp1(x,y,xi,'linear');
yispl = interp1(x,y,xi,'spline');
yipch = interp1(x,y,xi,'pchip');

subplot(1,3,1);
plot(x,y,'ok',xi,yi,'--k');
line(xi,yilin,'Color','Red','LineStyle','-');
grid on; title('Linear interpolation');
xlabel('x'); ylabel('y');
ylim([-0.5 3]);
subplot(1,3,2);
plot(x,y,'ok',xi,yi,'--k');
line(xi,yispl,'Color','Red','LineStyle','-');
grid on; title('Spline interpolation');
xlabel('x'); ylabel('y');
ylim([-0.5 3]);
subplot(1,3,3);
plot(x,y,'ok',xi,yi,'--k');
line(xi,yipch,'Color','Red','LineStyle','-');
grid on; title('Cubic interpolation');
xlabel('x'); ylabel('y');
ylim([-0.5 3]);