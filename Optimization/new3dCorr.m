clear;clc;

N = 5;
L = 4;
R = 4;

dx = 0.0;
dy = (0:0.01:2);
dz = 0.0;
Rcor = zeros(1,length(dy));
for i = 1:length(dy)
    Rcor(i) = Rcor_func(dx,dy(i),dz,N,L,R);
end
figure
plot(dy,abs(Rcor)/max(abs(Rcor)));
xlabel("dy");

dx = 0.01;
dy = 0.0;
dz = (0:0.01:2);
Rcor = zeros(1,length(dz));
for i = 1:length(dz)
    Rcor(i) = Rcor_func(dx,dy,dz(i),N,L,R);
end
figure
plot(dz,abs(Rcor)/max(abs(Rcor)));
xlabel("dz");

dx = (0:0.01:2);
dy = 0.0;
dz = 0.0;
Rcor = zeros(1,length(dx));
for i = 1:length(dx)
    Rcor(i) = Rcor_func(dx(i),dy,dz,N,L,R);
end
figure
plot(dx,abs(Rcor)/max(abs(Rcor)));
xlabel("dx");
%%
function f = Rcor_func(dx,dy,dz,N,L,R)
    dxy = sqrt(dx^2+dy^2);
    delta = atan(dy/dx);

    r1 = zeros(1,N+1);
    for n = 0:N
        r2 = zeros(1,L+1);
        for l = 0:L
            r3 = zeros(1,R);
            for r = 1:R
                func = @(mu) sin(mu*pi)*besselj(n/2-mu,pi*dxy)*besselj(n/2+mu,pi*dxy);
                mu_a1 = (1+r)/2 + (L-l);
                mu_a2 = (1-r)/2 + (L-l);
                mu_b1 = (1+r)/2 - (L-l);
                mu_b2 = (1-r)/2 - (L-l);
                r3(r) = (1i)^r*besselj(r,-2*pi*dz)*(func(mu_a1) + func(mu_a2) + func(mu_b1) + func(mu_b2));
            end
            mu_a0 = 1/2+(L-l);
            mu_b0 = 1/2-(L-l);
            temp = besselj(0,-2*pi*dz)*(func(mu_a0) + func(mu_b0) ) + sum(r3);
            r2(l+1) = pi*k_func1(l,L)*temp;
        end
        r1(n+1) = 1/2^(2*L+1)*a_func(n)*(1i)^n*cos(n*delta)*sum(r2);
    end
    f = sum(r1)/(pi*a_func(0)*k_func1(L,L)/2^(2*L));
end