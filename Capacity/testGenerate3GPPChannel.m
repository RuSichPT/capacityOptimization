clc;clear;close all
%% Задаем параметры
numChan = 1000;
numUsers = 2;
seed = 200;
sizeArray = [4 8]; 
%% Канал
[H, Ch, l, b] = generate3GPPChannels(sizeArray,numUsers,numChan,seed,'3GPP_38.901_UMa_NLOS',0);

coeff = 1e7;
H = H*coeff;
size(H)
disp(squeeze(H(:,:,2,1)));
disp(squeeze(H(:,:,2,2)));
%%  Пропускная способность
numSTS = min([size(H,1) size(H,2)]);
numRx = numSTS;
numChan = size(H,4);
snr_dB = 0;
[C, ~] = calculateData(H,numSTS,snr_dB,numChan);
%% Графики
figure('Name','CDF');
hold on
[~, statsC] = cdfplot(C(:,1));

disp("mean C_qua: " + statsC.mean);