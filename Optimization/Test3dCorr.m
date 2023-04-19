clear;clc;close all;
fc = 30e9;
cLight = physconst('LightSpeed');
% lambda = cLight/fc;
lambda = 1;
n = 0:5;
l = 0:4;
r = 1:4;

dx = 0.1*lambda;
dy = (0:0.05:2)*lambda;
dz = 0.0;
Rcor = zeros(1,length(dy));
for i = 1:length(dy)
    Rcor(i) = Rcor_func(dx,dy(i),dz,n,l,r);
end
figure
plot(dy,abs(Rcor)/max(abs(Rcor)));
xlabel("dy");

dx = 0.1*lambda;
dy = 0.0*lambda;
dz = (0:0.05:2)*lambda;
Rcor = zeros(1,length(dz));
for i = 1:length(dz)
    Rcor(i) = Rcor_func(dx,dy,dz(i),n,l,r);
end
figure
plot(dz,abs(Rcor)/max(abs(Rcor)));
xlabel("dz");
%%
function f = Rcor_func(dx,dy,dz,n,l,r)
    N = length(n);
    L = length(l);
    R = length(r);
    dxy = sqrt(dx^2+dy^2);
    delta = atan(dy/dx);

    r1 = zeros(1,N);
    for in = 1:N
        r2 = zeros(1,L);
        for il = 1:L
            r3 = zeros(1,R);
            for ir = 1:R
                func = @(Nr) cos(Nr*pi)*besselj(n(in)/2-Nr,pi*dxy)*besselj(n(in)/2+Nr,pi*dxy);
                N1r = (r(ir) - 2*(L-l(il)))/2;
                N2r = (r(ir) + 2*(L-l(il)))/2;
                r3(ir) = (1i)^r(ir)*besselj(r(ir),-2*pi*dz)*(func(N1r) + func(N2r));
            end
            r2(il) = k_func(l(il),L)*pi*cos(L-l(il))*(besselj(0,-2*pi*dz)*besselj(n(in)/2-(L-l(il)),pi*dxy)*besselj(n(in)/2+(L-l(il)),pi*dxy) + sum(r3));
        end
        r1(in) = a_func(n(in))*(-1i)^n(in)*cos(n(in)*delta)*sum(r2);   
    end
    a0 = a_func(0);
    k0 = k_func(0,L); 
    const = 1/(pi*a0*k0);
    f = const*sum(r1);
end