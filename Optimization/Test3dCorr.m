clear; clc;
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

dx = 0.1*lambda;
dy = 0.0*lambda;
dz = (0:0.05:2)*lambda;
Rcor = zeros(1,length(dz));
for i = 1:length(dz)
    Rcor(i) = Rcor_func(dx,dy,dz(i),n,l,r);
end
figure
plot(dz,abs(Rcor)/max(abs(Rcor)));
%%
% n = 0,1...N
function f = a_func(n)
    threshold = 30;     % db
    ang3dB = 65;        % degrees

    A_H_func = @(phi) (-min(12*((phi*180/pi)/ang3dB).^2,threshold)); % аргумент в радианах
    if n == 0
        arg = A_H_func;
    else
        arg = @(x) A_H_func(x).*cos(n*x);
    end
    f = 1/pi*integral(arg,-pi,pi);% в радианах!!! ошибка похоже в статье
end

% l = 0,1...L
% k зависит от L, поэтому передаем аргумент в функцию length(l) != L
function f = k_func(l,L)    
    if l == 0
        f = 1/(2^(2*L))*nchoosek(2*L,L);
    else
        f = 1/(2^(2*L))*(-1)^l*2*nchoosek(2*L,L-1);
    end
end

function f = Rcor_func(dx,dy,dz,n,l,r)
    N = length(n);
    L = length(l);
    R = length(r);
    dxy = sqrt(dx^2+dy^2);
    delta = 1/tan(dy/dx);
    if delta == inf
        delta = 1e9;
    end

    r1 = zeros(1,N);
    for in = 1:N
        r2 = zeros(1,L);
        for il = 1:L
            r3 = zeros(1,R);
            for ir = 1:R
                func = @(Nr) cos(Nr*pi)*besselj(n(in)/2-Nr,pi*dxy)*besselj(n(in)/2+Nr,pi*dxy);
                N1r = (n(in) - l(il))/2;
                N2r = (n(in) - l(il))/2;
                r3(ir) = (1i)^r(ir)*besselj(r(ir),-2*pi*dz)*(func(N1r) + func(N2r));
            end
            r2(il) = besselj(0,-2*pi*dz)*besselj(n(in)/2-l(il),pi*dxy)*besselj(n(in)/2+l(il),pi*dxy) + sum(r3);
        end
        r1(in) = a_func(n(in))*(-1i)^n(in)*cos(n(in)*delta)*sum(r2);   
    end
    a0 = a_func(0);
    k0 = k_func(0,L); 
    const = 1/(pi*a0*k0);
    f = const*sum(r1);
end