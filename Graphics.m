clear; close all;

alpha = 100;
t = linspace(-0.1,0.1,1000);
dt = abs(t(2)-t(1));
fs = 1/dt;
s = 2*exp(-alpha*abs(t));
N = 2^(nextpow2(length(s))+1);
f = -fs/2:fs/N:fs/2-fs/N;
S = fftshift(fft(s,N));
SA = abs(S);
SP = unwrap(angle(S));
Data = {'-','Exponent','Amplitude spectrum','Phase spectrum'};

fig = figure('Name','Графики');
fig.Units = 'normalized';
fig.OuterPosition = [0 0.05 1 0.95];
fig.NumberTitle = 'off';
fig.MenuBar = 'none';

graphic = axes;

list = uicontrol(fig);
list.Style = 'popupmenu';
list.Position = [10 575 140 20];
list.String = Data;

H = plot(NaN,NaN);

cl = uicontrol(fig);
cl.Style = 'pushbutton';
cl.Position = [75 550 75 20];
cl.String = 'Close';
cl.Callback = @Close;

while (1)
    waitfor(list,'Value');
    Current = list.Value;
    if Current == 1
        H.XData = [];
        H.YData = [];
        graphic.XLabel.String = '';
        graphic.YLabel.String = '';
        graphic.Title.String = '';
        graphic.XMinorGrid = 'off';
        graphic.YMinorGrid = 'off';
        legend off;
    end
    if Current == 2
        H.XData = t;
        H.YData = s;
        H.Color = 'Black';
        H.LineStyle = '-';
        H.LineWidth = 1.5;
        graphic.XLabel.String = 'Time, s';
        graphic.YLabel.String = 'Signal, V';
        graphic.Title.String = 'Signal';
        graphic.XMinorGrid = 'on';
        graphic.YMinorGrid = 'on';
        legend('s(t)');
    end
    if Current == 3
        H.XData = f;
        H.YData = SA;
        H.Color = 'Black';
        H.LineStyle = '-';
        H.LineWidth = 1.5;
        graphic.XLabel.String = 'Frequency, Hz';
        graphic.YLabel.String = '';
        graphic.Title.String = 'Amplitude spectrum';
        graphic.XMinorGrid = 'on';
        graphic.YMinorGrid = 'on';
        legend('|S(f)|');
    end
    if Current == 4
        H.XData = f;
        H.YData = SP;
        H.Color = 'Black';
        H.LineStyle = '-';
        H.LineWidth = 1.5;
        graphic.XLabel.String = 'Frequency, Hz';
        graphic.YLabel.String = 'Phase, rad';
        graphic.Title.String = 'Phase spectrum';
        graphic.XMinorGrid = 'on';
        graphic.YMinorGrid = 'on';
        legend('arg(S(f))');
    end
end

function Close(~,~)
    close all;
end