function Treshold = CFAR(Input,guard,train,gain,value,mode)
% Данная функция вычисляет значения CFAR-порога для одномерного массива
%   Входные данные:
%       Input    - входной массив данных, для которого вычисляется порог
%       guard    - количество "мертвых" ячеек
%       train    - количество "живых" ячеек
%       gain     - значение, на которое умножается порог
%       value    - значение, на которое приподнимается порог
%       mode     - режим вычислений: сумма или среднее
%   Выходные данные:
%       Treshold - вычисленный порог

Treshold = zeros(size(Input));
for i = 1:length(Input)
    win = [i-guard-train:i-guard-1, i+guard+1:i+guard+train];
    win(win<1) = [];
    win(win>length(Input)) = [];
    if isequal(mode, "sum")
        Treshold(i) = sum(Input(win));
    elseif isequal(mode, "mean")
        Treshold(i) = mean(Input(win));
    else
        error("Error. Invalid mode '%s'.", mode);
    end
end
Treshold = gain*Treshold+value;

end

