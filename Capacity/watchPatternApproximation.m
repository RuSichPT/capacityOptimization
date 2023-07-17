clc;clear;close all;
%% Параметры
bw3dB = 65; 
threshold = 30;     %dB
tilt = 0;
phi = -180:180;
theta = (-90:90) + tilt;
%% Парабола
A_H_func_dB = @(phi) (-min(12*(((phi))/bw3dB).^2,threshold)); 
A_V_func_dB = @(theta) (-min(12*((theta - tilt)/bw3dB).^2,threshold));
A_H = A_H_func_dB(phi);
A_V = A_V_func_dB(theta);
%% Квадрига
[custom, parCust] = qd_arrayant.generate('custom', bw3dB, bw3dB, 0);
par.A = 1; par.B = parCust.B; par.C = parCust.C; par.D = parCust.D;
parametric = qd_arrayant.generate('parametric', par.A, par.B, par.C, par.D);
% parametric.visualize;

E1 = @(theta, phi, a, b, c, d) a.*sqrt(b+(1-b).*cos(theta).^c.*exp(-d.*phi.^2));
E_func = @(theta, phi) E1(theta, phi, par.A, par.B, par.C, par.D);
% E_tmp = @(theta, phi) abs(E(theta, phi)).^2.*cos(theta);
% Nrm = sqrt(4*pi./integral2(E_tmp, -pi/2, pi/2, -pi, pi));
% E_func = @(theta, phi) E(theta,phi).*Nrm;

Ephi = E_func(tilt,phi*pi/180);
Ephi = 10*log10(abs(Ephi));
Etheta = E_func(theta*pi/180,0);
Etheta = 10*log10(abs(Etheta));
%% Усков
L = 10;
a = bw3dB;% / 2*sqrt(-2*log(L));
b = bw3dB;% / 2*sqrt(-2*log(L));
F = @(theta, phi) ( exp( -(theta+tilt).^2 ./ (2*a.^2) ) .* exp( -(phi).^2 ./ (2*b.^2) ) ); % убрал смещение -90
Fphi = 10*log10(F(0,phi));
Ftheta = 10*log10(F(theta,0));
%% Рисунки
figure;
plot(phi,A_H,"LineWidth",1.5);
hold on;
plot(phi,Ephi,"LineWidth",1.5);
plot(phi,Fphi,"LineWidth",1.5);

grid on
title("Pattern for elevation=" + tilt);
xlabel('Azimuth angle');
ylabel("D, dB");
ylim([-50 0])
legend("Parabola","QuaDRiGA","Uskov");

figure;
plot(theta,A_V,"LineWidth",1.5);
hold on;
plot(theta,Etheta,"LineWidth",1.5);
plot(theta,Ftheta,"LineWidth",1.5);

grid on
title("Pattern for azimuth=0");
xlabel("Elevation angle");
ylabel("D, dB");
ylim([-50 0])
legend("Parabola","QuaDRiGA","Uskov");
