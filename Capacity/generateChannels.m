clc;clear;close all;
%% Задаем параметры
numChan = 1;
numUsers = 100;
seed = 200;
sizeArray = [8 4]; 
power = 1e7;
myArray = 1;
spacing = 0.25;
%% Канал
[H, Ch, l, b] = generate3GPPChannels(sizeArray,spacing,numUsers,numChan,seed,power,myArray);
%% Пропускная способность
snr_dB = 0;
[C, ~] = calculateData(H,snr_dB,numChan);
%% Save
name = "Capacity/dataBase/ant=" + sizeArray(1) + "x" + sizeArray(2) + "_numChan=" + numChan + "_users=" + numUsers ...
    + "_spacing=" + spacing + "_seed=" + seed + "_my=" + myArray + ".mat";
save(name,"H","C");