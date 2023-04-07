clear all;
%% Выбор изображения и считывание его из файла
x = input('Введите 1, 2 или 3: ');
if x == 1
    A = imread('4.jpg');
elseif x == 2
    A = imread('5.jpg');
elseif x == 3
    A = imread('7.jpg');
else 
    errordlg('Вы не ввели требуемое число','Error')
    return
end
imshow(A); pause;
%% Разложение изображения в спектр по яркостям и каналам
level_r = 0.52;
R = im2bw(A(:,:,1),level_r);
level_g = 0.55;
G = im2bw(A(:,:,2),level_g);
level_b = 0.42;
B = im2bw(A(:,:,3),level_b);
A_sum = R&G&B;

subplot(2,2,1); imshow(R);
title('Красный канал');
subplot(2,2,2); imshow(G);
title('Зеленый канал');
subplot(2,2,3); imshow(B);
title('Синий канал');
subplot(2,2,4); imshow(A_sum);
title('Сумма трех каналов'); pause;
%% Комплиментация полученной бинарной матрицы и заполнение "дыр"
A1 = imcomplement(A_sum);
A1 = imfill(A1,'holes');
figure; imshow(A1); pause;
%% Избавление от шумов и сглаживание контуров объектов
s = strel('disk',22);
A2 = imopen(A1,s); imshow(A2); pause;
%% Обнаружение объектов и расчет их параметров
A3 = regionprops(A2,'centroid');
[labeled,numObjects] = bwlabel(A2,4);
stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');
areas = [stats.Area];
eccentricities = [stats.Eccentricity];
%% Выделение объектов на исходном изображении
idxOfObjects = find(eccentricities);
statsDefects = stats(idxOfObjects);

figure; imshow(A);
hold on;
for idx = 1 : length(idxOfObjects)
    h = rectangle('Position',statsDefects(idx).BoundingBox);
    set(h,'EdgeColor',[0.75 0 0]);
    hold on;
end
title(['Найдено ',num2str(numObjects),' объектов']);