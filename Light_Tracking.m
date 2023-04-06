clear; close all;

%% Глобальные переменные
global SIZE;

%% Исходные данные
SIZE = 5;   % размер помещения
X    = 0;   % расположение источника по оси X
Y    = 0;   % расположение источника по оси Y
MaxXLim     = SIZE^2;           % максимальный путь, откладываемый на шкале
phi         = -90:5:90;         % диапазон рассчитываемых углов (град)
phi_rad     = deg2rad(phi);     % диапазон рассчитываемых углов (рад)
init_power  = 1;                % начальная мощность луча
treshold    = 0.1*init_power;   % порог, после которого луч теряется
alpha       = 0.9;              % коэффициент потерь при отражении
wnd         = SIZE/5;           % размер окна для приема сигнала

%% Трассировка лучей
% Инициализация массива структур
S = repmat(struct('power',{init_power},'range',{0},'dots',{[X,Y]},...
    'comeback',{false}),1,length(phi));
% Цикл вычислений последовательно по углам
for i = 1:length(phi)
    % Задаем текущий угол излучения
    curr_phi = phi(i);
    j = 1;
    % Пока сигнал сильнее порога
    while S(i).power >= treshold
        % Построение прямой
        k = tand(curr_phi);
        b = S(i).dots(j,2) - k*S(i).dots(j,1);
        [x,y] = intersect_lines(S(i).dots(j,:),k,b);
        curr_phi = -atand(k);
        S(i).dots = [S(i).dots; x, y];
        j = j + 1;
        R = norm(S(i).dots(j,:)-S(i).dots(j-1,:));
        S(i).range = S(i).range + R;
        S(i).power = S(i).power*alpha;
        if (x==0) && (y>=-wnd/2) && (y<=wnd/2)
            S(i).comeback = true;
            break;
        end
    end
end

% Вычисление принимаемого сигнала
dx = 0.01;
x  = 0:dx:MaxXLim;
Rx = zeros(length(phi),length(x));
for i = 1:length(phi)
    if ~S(i).comeback
        continue;
    end
    if S(i).range <= MaxXLim
        [~,ind] = min(abs(x-S(i).range));
        Rx(i,ind) = S(i).power;
    end
end

%% GUI
% Создание окна
fig = uifigure;
fig.Name = "Scene";
fig.WindowState = 'maximized';

% Принимаемый сигнал
ax1 = axes(fig,'Units', 'pixels', 'Position', [436.8,664,701,69.3]);
xlim(ax1,[0,MaxXLim]);
ylim(ax1,[0,1]);
ax1.XGrid = 'on';
ax1.YGrid = 'on';

% Сцена
ax2 = axes(fig,'Units', 'pixels', 'Position', [436.8,79.4,701,542.2]);
xlim(ax2,[0,SIZE]);
ylim(ax2,[-SIZE/2,SIZE/2]);
ax2.XAxisLocation = 'origin';
rect = rectangle(ax2,'Position',[0,-SIZE/2,SIZE,SIZE],...
    'EdgeColor','k','LineWidth',2.5);

% Огонек, сигнализирующий о выходе из пределов верхнего графика
lmp = uilamp(fig,'Position',[325,690,25,25]);
lmp.Color = 'w';

% Текущая дальность
txt1 = uilabel(fig,'Position',[1200,690,250,25]);
txt1.FontSize = 16;
txt1.Text = "0 м";

% Кнопка продолжения отрисовки
btn = uibutton(fig,'state','Position',[300,300,50,25]);
btn.Text = "Next";

% Текущий угол излучения
txt2 = uilabel(fig,'Position',[300,335,50,25]);
txt2.FontSize = 16;
txt2.Text = num2str(phi(1));
txt2.HorizontalAlignment = 'center';

%% Визуализация
for i = 1:length(phi)
    lmp.Color = 'w';
    txt2.Text = num2str(phi(i));
    for j = 2:size(S(i).dots,1)
        lin(j-1) = line(ax2,S(i).dots(j-1:j,1),S(i).dots(j-1:j,2),...
            'Color',[1,init_power*(1-alpha^(j-2))*[1,1]],'LineWidth',1.5);
    end
    plt = stem(ax1,x,Rx(i,:),'filled','Color','k');
    xlim(ax1,[0,MaxXLim]);
    tmp = 1.2*max(Rx(i,:));
    if ~logical(tmp)
        tmp = 1;
    end
    ylim(ax1,[0,tmp]);
    ax1.XGrid = 'on';
    ax1.YGrid = 'on';
    if ~S(i).comeback
        txt1.Text = "Not reached";
    else
        txt1.Text = num2str(S(i).range)+" m";
        if S(i).range > MaxXLim
            lmp.Color = 'r';
        else
            lmp.Color = 'g';
        end
    end
    if i ~= length(phi)
        waitfor(btn,'Value');
        delete(lin);
        delete(plt);
    end
    try
        btn.Value = false;
    catch
        disp('The program is finished');
        return;
    end
end

%% Вспомогательные функции
% Определение точки пересечения луча со стеной
function [x,y] = intersect_lines(init_coords,k,b)
    % Определяем, с какими стенами будем работать
    x1 = init_coords(1);
    y1 = init_coords(2);
    walls = ["bottom","right","top","left"];
    curr_wall = which_wall(x1,y1);
    for i = 1:length(walls)
        if strcmp(curr_wall,walls(i))
            walls(i) = [];
            break;
        end
    end
    % Находим точку пересечения
    for i = 1:length(walls)
        [x,y] = check_wall(walls(i),k,b);
        if (x==-Inf) || (x==Inf)
            x = x1;
            break;
        end
        if ~(isnan(x) || isnan(y))
            break;
        end
    end
end

% Какой стене принадлежит точка
function num = which_wall(x,y)
    global SIZE;
    if ((x>=0)&&(x<SIZE)) && (y == -SIZE/2)
        num = "bottom";
    elseif (x == SIZE) && ((y>=-SIZE/2)&&(y<SIZE/2))
        num = "right";
    elseif ((x>0)&&(x<=SIZE)) && (y == SIZE/2)
        num = "top";
    elseif (x == 0) && ((y>-SIZE/2)&&(y<=SIZE/2))
        num = "left";
    else
        error("Error. Not wall.");
    end
end

% Нахождение точки пересечения с определенной стеной
function [x,y] = check_wall(wall,k1,b1)
    % Точка пересечения
    global SIZE;
    if strcmp(wall,"bottom")
        k2 = 0;
        b2 = -SIZE/2;
    elseif strcmp(wall,"right")
        x = SIZE;
    elseif strcmp(wall,"top")
        k2 = 0;
        b2 = SIZE/2;
    elseif strcmp(wall,"left")
        x = 0;
    else
        error("Error. Not valid wall.");
    end
    if strcmp(wall,"bottom") || strcmp(wall,"top")
        if k1 == -Inf
            x = -Inf;
            y = -SIZE/2;
            return;
        elseif k1 == Inf
            x = Inf;
            y = SIZE/2;
            return;
        end
        x = (b2-b1) / (k1-k2);
    end
    y = k1*x + b1;
    eps = 1e-6;
    if (y>=-SIZE/2-eps) && (y<=-SIZE/2+eps)
        y = -SIZE/2;
    elseif (y>=SIZE/2-eps) && (y<=SIZE/2+eps)
        y = SIZE/2;
    end
    
    % Попадает ли точка в пределы помещения
    if ~(((x>=0)&&(x<=SIZE)) && ((y>=-SIZE/2)&&(y<=SIZE/2)))
        x = NaN;
        y = NaN;
    end
end
