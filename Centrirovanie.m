function [r,phi] = Centrirovanie(r,phi)
Y = r(1);
for i = 1:length(r)
    if r(i)~=Y(length(Y))
        Y = [Y r(i)];
    end
end

for i = 1:length(Y)
    h = find(r==Y(i));
    k = phi(h);
    sr = fix((k(length(k))+k(1))/2);
    N = find(k==sr);
    H = h(N);
    k(1:end) = -1;
    k(N) = sr;
    phi(h) = k;
    r(h) = -1;
    r(H) = Y(i);
    S = 0;
    for j = 1:length(r)
        if r(j)<0
            S = [S j];
        end
    end
    S(1) = [];
    r(S) = [];
    phi(S) = [];
end
end