clc;clear;close all;
%% Задаем параметры
numChan = 100;
numUsers = 100;
seed = 200;
sizeArray = [4 4]; 
power = 1e7;
myArray = '3gpp-mmw';
spacing = 0.5;
%% Канал
[H, Ch, l, b] = generate3GPPChannels(sizeArray,spacing,numUsers,numChan,seed,power,myArray);
%%
% visualizeAll(l);
%%
% size(H)
% disp("H1");
% disp(squeeze(H(:,:,2,1)));
% disp("H2");
% disp(squeeze(H(:,:,2,2)));
%%  Пропускная способность
snr_dB = 0;
[C, ~] = calculateData(H,snr_dB,numChan);
%% Графики
figure('Name','CDF');
hold on
[~, statsC] = cdfplot(C(:,1));

disp("mean C_qua: " + statsC.mean);