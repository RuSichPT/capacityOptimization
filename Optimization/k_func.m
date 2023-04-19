function f = k_func(l,L)
    % l = 0,1...L
    % k зависит от L, поэтому передаем аргумент в функцию length(l) != L
    if l == L 
        f = 1/(2^(2*L))*nchoosek(2*L,L);
    else
        f = 1/(2^(2*L))*(-1)^(L - l)*2*nchoosek(2*L,l);
    end
end