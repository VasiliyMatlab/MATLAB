clear; close all;

% Генерация данных для нейросети Peaks2DNet
%
% Данные представляют из себя следующее:
% двумерный массив размером [SizeY х SizeX], в котором содержаться данные о
% белом (гауссовом) шуме; в таких массивах содержится резкий выброс
% значения (пик), который может находится в любой из ячеек массива
% Подобных массивов генерируется нужное количество, а потом они изменяются
% таким образом, чтобы у каждого из SizeX*SizeY классов было равное
% количество таких массивов
% Данный скрипт позволяет генерировать данные для обучения нейросети, ее
% валидации, а также тестовые данные 


%% Общие переменные

% Инициализация переменных
SizeX      = 35;          % Кол-во отсчетов массива по Х
SizeY      = 35;          % Кол-во отсчетов массива по Y
NumClasses = SizeX*SizeY; % Кол-во классов (общее число ячеек массива)
NumTrainData      = NumClasses*50;    % кол-во данных для обучения
NumValidationData = NumClasses;       % кол-во данных для валидации
NumTestData       = 0.1*NumTrainData; % кол-во данных для тестирования

% Сохранение переменных
save InputProperties SizeX SizeY;


%% Данные для обучения

% Инициализация переменных
TrainData  = randn(NumTrainData*SizeY,SizeX);  % массив данных для обучения
TrainData  = single(TrainData);                % понижение точности вычислений
TrainValue = zeros(NumTrainData,1);            % данные о классификации
TrainData_per_Class = NumTrainData/NumClasses; % кол-во данных в классе

% Формирование требуемых данных
% Цикл по классам
for i = 1:NumClasses
    [row,col] = ind2sub([SizeY SizeX],i);
    % Цикл по массивам класса
    for j = 1:TrainData_per_Class
        TrainData(row+(j-1)*SizeY+(i-1)*TrainData_per_Class*SizeY,col)...
            = 10*abs(randn(1))+10;
        TrainValue((i-1)*TrainData_per_Class+j) = ...
            [string(num2str(row))+string(num2str(col))];
    end
end

% Приведение в требуемому формату
TrainData  = mat2cell(TrainData,SizeY*ones(1,NumTrainData));
TrainValue = categorical(convertCharsToStrings(TrainValue));

% Сохранение данных
save Train TrainData TrainValue;


%% Данные для валидации

% Инициализация переменных
ValidationData  = randn(NumValidationData*SizeY,SizeX);  % массив данных для валидации
ValidationData  = single(ValidationData);                % понижение точности вычислений
ValidationValue = zeros(NumValidationData,1);            % данные о классификации
ValidationData_per_Class = NumValidationData/NumClasses; % кол-во данных в классе

% Формирование требуемых данных
% Цикл по классам
for i = 1:NumClasses
    [row,col] = ind2sub([SizeY SizeX],i);
    % Цикл по массивам класса
    for j = 1:ValidationData_per_Class
        ValidationData(row+(j-1)*SizeY+(i-1)*ValidationData_per_Class*...
            SizeY,col) = 10*abs(randn(1))+10;
        ValidationValue((i-1)*ValidationData_per_Class+j) = ...
            [string(num2str(row))+string(num2str(col))];
    end
end

% Приведение в требуемому формату
ValidationData  = mat2cell(single(ValidationData),SizeY*ones(1,NumValidationData));
ValidationValue = categorical(convertCharsToStrings(ValidationValue));

% Сохранение данных
save Validation ValidationData ValidationValue;


%% Тестовые данные

% Инициализация переменных
TestData  = randn(NumTestData*SizeY,SizeX);  % данные для тестирования
TestData  = single(TestData);                % понижение точности вычислений
TestValue = zeros(NumTestData,1);            % данные о классификации
TestData_per_Class = NumTestData/NumClasses; % кол-во данных в классе

% Формирование требуемых данных
% Цикл по классам
for i = 1:NumClasses
    [row,col] = ind2sub([SizeY SizeX],i);
    % Цикл по массивам класса
    for j = 1:TestData_per_Class
        TestData(row+(j-1)*SizeY+(i-1)*TestData_per_Class*SizeY,col)...
            = 10*abs(randn(1))+10;
        TestValue((i-1)*TestData_per_Class+j) = ...
            [string(num2str(row))+string(num2str(col))];
    end
end

% Приведение в требуемому формату
TestData  = mat2cell(single(TestData),SizeY*ones(1,NumTestData));
TestValue = categorical(convertCharsToStrings(TestValue));

% Сохранение данных
save Test TestData TestValue;