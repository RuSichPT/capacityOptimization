clc;clear;close all;
%% Задаем параметры
numChan = 100;
numUsers = 100;
seed = 200;
power = 1e7;
myArray = 'omni';
spacing = [0.5 0.5];
tilt = 0;
%% sizeArray
range = {[4 4] [4 8] [8 4] [8 8] [16 8] [8 16] [16 16]};
for i = 1:length(range)
    sizeArray = range{i};
    % Канал
    [H, Ch, l, b] = generate3GPPChannels(sizeArray,spacing,numUsers,numChan,seed,power,myArray,tilt);
    % Пропускная способность
    snr_dB = 0;
    [C, ~] = calculateData(H,snr_dB,numChan);
    % Save
    name = "Capacity/dataBase/ant=" + sizeArray(1) + "x" + sizeArray(2) + "_numChan=" + numChan + "_users=" + numUsers ...
        + "_spacing=" + spacing + "_seed=" + seed + "_my=" + myArray + ".mat";
    save(name,"H","C","myArray");
end