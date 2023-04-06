clear;

load('Proba_variables.mat');
[r,phi] = Centrirovanie(r,phi);
r
phi
pause;

i = 1;
while i<=length(phi)
    if i~=length(phi)
        if (abs(phi(i)-phi(i+1))<10)&((r(i+1)-r(i))<10)
            r(i) = (r(i)+r(i+1))/2;
            phi(i) = (phi(i)+phi(i+1))/2;
            r(i+1) = [];
            phi(i+1) = [];
        else
            i = i+1;
        end
    else
        i = i+1;
    end
end

r
phi
pause;

for i = 1:length(phi)
    for j = i+1:length(phi)
        if phi(i)>phi(j)
            S = phi(i);
            phi(i) = phi(j);
            phi(j) = S;
            S = r(i);
            r(i) = r(j);
            r(j) = S;
        end
    end
end

r
phi