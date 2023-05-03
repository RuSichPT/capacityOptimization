clc;clear;close all;
sizeArray = [1 1];
spacing = [0.5 0.5];
%arrayType='omni';
arrayType='dipole';
%arrayType='patch';
fc = 3.5e9;

tilt = 12;
a = generateMyArray(sizeArray, spacing, 0, fc, arrayType);% здесь tilt 0; чтобы снаружи функции управлять rotate
a.rotate_pattern(tilt,'y',1);  

figure(1)
plot(-90:90,a.Fa(:,180,1));
xlabel('elevation Z');
title('az 180');
figure(2)
plot(-180:180,a.Fa(90,:,1));
xlabel('azimuth Y');
title('el 90');
a.visualize(1);