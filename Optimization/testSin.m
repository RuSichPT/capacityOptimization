clear;clc;close all;
L = 4;
l = 0:L;
thetta = (0:180)*pi/180;
f = sin(thetta).^(2*L);
figure()
plot(thetta,f);

f1 = zeros(1,length(thetta));
for ith = 1:length(thetta)
    for il = 1:length(l)
        arg = 2*(L-l(il));
        k(il) = k_func(l(il),L)*cos(arg*thetta(ith));
    end
    f1(ith) = sum(k);
end
figure()
plot(thetta,f1);

s = @(l) (-1).^(L - l)*2*nchoosek(2*L,l);

f2 = zeros(1,length(thetta));
for ith = 1:length(thetta)
    for il = 1:length(l)-1
        arg = 2*(L-l(il));
        temp(il) = s(l(il))*cos(arg*thetta(ith));
    end
    f2(ith) = 1/(2^(2*L))*( sum(temp) + nchoosek(2*L,L));
end
figure()
plot(thetta,f2);
k_func(L,L)
1/(2^(2*L))*nchoosek(2*L,L)