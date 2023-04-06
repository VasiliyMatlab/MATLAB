clear; close all;

fs   = 1000;
dt   = 1/fs;
t1   = -0.3:dt:0+dt;
t2   = -dt:dt:0.3;
s1   = 1*exp(50*t1).*heaviside(-t1);
s2   = rectpuls(t2-0.05,0.1);
C    = conv(s2,s1,'same');
Data = {'-','2 сигнала','Свертка'};

fig = figure('Name','Свертка');
fig.Position    = get(0,'ScreenSize');
fig.NumberTitle = 'off';
fig.MenuBar     = 'none';

graphic  = axes;
L1       = line;
L2       = line;
L1.XData = [];
L1.YData = [];
L2.XData = [];
L2.YData = [];

list = uicontrol(fig);
list.Style    = 'popupmenu';
list.Position = [10 575 140 20];
list.String   = Data;

cl = uicontrol(fig);
cl.Style    = 'pushbutton';
cl.Position = [75 550 75 20];
cl.String   = 'Close';
cl.Callback = @Close;

while (1)
    waitfor(list,'Value');
    Current = list.Value;
    if Current == 1
        L1.XData = [];
        L1.YData = [];
        L2.XData = [];
        L2.YData = [];
        graphic.XLabel.String = '';
        graphic.YLabel.String = '';
        graphic.Title.String  = '';
        graphic.XMinorGrid    = 'off';
        graphic.YMinorGrid    = 'off';
        graphic.XLimMode      = 'auto';
        graphic.YLimMode      = 'auto';
        legend off;
    end
    if Current == 2
        L1.XData     = t1;
        L1.YData     = s1;
        L2.XData     = t2;
        L2.YData     = s2;
        L1.Color     = 'Blue';
        L1.LineWidth = 1.5;
        L2.Color     = 'Red';
        L2.LineWidth = 1.5;
        graphic.XLabel.String = 'Time, s';
        graphic.YLabel.String = 'Voltage, V';
        graphic.Title.String  = 'Сворачиваемые сигналы';
        graphic.XMinorGrid    = 'on';
        graphic.YMinorGrid    = 'on';
        graphic.XLimMode      = 'auto';
        graphic.YLimMode      = 'auto';
        legend('s_1(t)','s_2(t)');
    end
    if Current == 3
        L1.XData     = t2;
        L1.YData     = C;
        L2.XData     = [];
        L2.YData     = [];
        L1.Color     = 'Blue';
        L1.LineWidth = 1.5;
        graphic.XLabel.String = 'Time, s';
        graphic.YLabel.String = 'Voltage, V';
        graphic.Title.String  = 'Свертка';
        graphic.XMinorGrid    = 'on';
        graphic.YMinorGrid    = 'on';
        graphic.XLim          = [0 0.3];
        graphic.YLimMode      = 'auto';
        legend('y(t)');
    end
end

function Close(~,~)
    close all;
end