clear; close all;

% Генерация данных для нейросети PeaksNet
%
% Данные представляют из себя следующее:
% одномерный массив размером 1х200, в котором содержаться данные о белом
% (гауссовом) шуме; в таких массивах содеражатся резкие выбросы значений
% (пики), которых может быть от 0 включительно до 5 включительно (всего 6
% классов)
% Подобных массивов генерируется нужное количество, а потом они изменяются
% таким образом, чтобы у каждого из 6 классов было равное количество таких
% массивов
% Данный скрипт позволяет генерировать как данные для обучения нейросети,
% так и тестовые данные (возможность генерировать данные для валидации не
% предусмотрена)


%% Данные для обучения

% Инициализация переменных
NumTrainData = 3000;                    % общее кол-во данных для обучения
Train_Data   = randn(NumTrainData,200); % массив данных для обучения
Train_Value  = zeros(NumTrainData,1);   % массив данных о классификации
Train_Data_per_class = NumTrainData/6;  % кол-во данных в классе

% Формирование требуемых данных
% Цикл по классам
for i = 1:5
    % Цикл по массивам класса 
    for j = i*Train_Data_per_class+1:(i+1)*Train_Data_per_class
        index = randi(size(Train_Data,2),1,i);
        k = 1;
        while k<=size(index,1)
            res = index-index(k);
            k1  = find(res==1);
            k2  = find(res==-1);
            if (~isempty(k1))||(~isempty(k2))
                index(k) = randi(size(Train_Data,2),1,1);
            else
                k = k+1;
            end
        end
        high  = randi(40,1,i)+10;
        Train_Data(j,index) = high;
        Train_Value(j) = i;
    end
end

% Приведение в требуемому формату
Train_Data  = mat2cell(Train_Data,ones(1,NumTrainData));
Train_Value = categorical(Train_Value);

% Сохранение данных
save Train_Data Train_Data;
save Train_Value Train_Value;


%% Тестовые данные

% Инициализация переменных
NumTestData = 300; % общее кол-во тестовых данных
Test_Data   = randn(NumTestData,200); % массив тестовых данных
Test_Value  = zeros(NumTestData,1);   % массив данных о классификации
Test_Data_per_class = NumTestData/6;  % кол-во данных в классе

% Формирование требуемых данных
% Цикл по классам
for i = 1:5
    % Цикл по массивам класса
    for j = i*Test_Data_per_class+1:(i+1)*Test_Data_per_class
        index = randi(size(Test_Data,2),1,i);
        k = 1;
        while k<=size(index,1)
            res = index-index(k);
            k1  = find(res==1);
            k2  = find(res==-1);
            if (~isempty(k1))||(~isempty(k2))
                index(k) = randi(size(Test_Data,2),1,1);
            else
                k = k+1;
            end
        end
        high  = randi(40,1,i)+10;
        Test_Data(j,index) = high;
        Test_Value(j) = i;
    end
end

% Приведение в требуемому формату
Test_Data  = mat2cell(Test_Data,ones(1,NumTestData));
Test_Value = categorical(Test_Value);

% Сохранение данных
save Test_Data Test_Data;
save Test_Value Test_Value;