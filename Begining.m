function y=Begining(high);
x=(1:50);
for k=1:high
    y(k,x)=log(x+k)-k*k;
end;
plot(x,y)
