function f = k_func1(l,L)
    % l = 0,1...L
    % k зависит от L, поэтому передаем аргумент в функцию length(l) != L
    if l == L 
        f = nchoosek(2*L,L);
    else
        f = (-1)^(L - l)*2*nchoosek(2*L,l);
    end
end