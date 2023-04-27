clc;clear;close all;
%% Задаем параметры
numChan = 100;
numUsers = 100;
seed = 200;
power = 1e7;
myArray = 1;
sizeArray = [4 4];
%% sizeArray
range = [0.25 0.1];
for i = 1:length(range)
    spacing = range(i);
    % Канал
    [H, Ch, l, b] = generate3GPPChannels(sizeArray,spacing,numUsers,numChan,seed,power,myArray);
    % Пропускная способность
    snr_dB = 0;
    [C, ~] = calculateData(H,snr_dB,numChan);
    % Save
    name = "Capacity/dataBase/ant=" + sizeArray(1) + "x" + sizeArray(2) + "_numChan=" + numChan + "_users=" + numUsers ...
        + "_spacing=" + spacing + "_seed=" + seed + "_my=" + myArray + ".mat";
    save(name,"H","C");
end