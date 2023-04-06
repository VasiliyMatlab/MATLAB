function y=Temperature;
t=input('Введите температуру: ');
if(t<0)
    disp('Мороз')
elseif(t<10)
    disp('Прохладно')
elseif(t<27)
    disp('Приемлемо')
else
    disp('Жара')
end
end