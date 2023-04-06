clear; close all;

N = 100;                        % размер поля
Field = zeros(N,N,2);           % создание поля
Field(:,:,1) = randn(N,N);      % начальная генерация
for i = 1:N
    for j = 1:N
        if Field(i,j,1) >= 0
            Field(i,j,1) = 1;
        else
            Field(i,j,1) = 0;
        end
    end
end
SUM = sum(Field(:,:,1),'all');  % сумма элементов поля

F = figure;
I = imagesc(Field(:,:,1));
colormap(gray);
colorbar;
axis equal;
while SUM ~= 0
    % Вычисление следующего поколения
    for i = 1:N
        for j = 1:N
            wini = i-1:i+1;
            winj = j-1:j+1;
            % Перенос вычисляемых клеток
            for k = 1:3
                if wini(k) < 1
                    wini(k) = N - wini(k);
                elseif wini(k) > N
                    wini(k) = wini(k) - N;
                end
                if winj(k) < 1
                    winj(k) = N - winj(k);
                elseif winj(k) > N
                    winj(k) = winj(k) - N;
                end
            end
            S = sum(Field(wini,winj,1),'all');
            % Если клетка была пустой
            if ~Field(i,j,1)
                if S == 3
                    Field(i,j,2) = 1;
                    continue;
                end
                Field(i,j,2) = 0;
            % Если клетка не была пустой
            else
                S = S - 1;
                switch S
                    case 2
                        Field(i,j,2) = 1;
                    case 3
                        Field(i,j,2) = 1;
                    otherwise
                        Field(i,j,2) = 0;
                end
            end
        end
    end
    % Обновление поля
    Field(:,:,1) = Field(:,:,2);
    try
        I.CData = Field(:,:,1);
    catch
        return;
    end
    drawnow;
    SUM = sum(Field(:,:,1),'all');
end