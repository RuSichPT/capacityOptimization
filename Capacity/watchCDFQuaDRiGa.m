clc;clear;close all
%% Задаем параметры
numChan = 1;
numUsers = 100;
seed = 200;
sizeArray = [4 8];
power = 1e7;
myArray = 'omni';
spacing = [0.5 0.5];
tilt = 0;
fc = 3.5e9;
%% Канал
[aBS,aMS] = generate_aBS_aMS(sizeArray,spacing,power,myArray,fc,tilt);
[H, Ch, l, b] = generate3GPPChannels(aBS,aMS,numUsers,numChan,seed);
%%
% visualizeAll(l);
%% EOD
EoD = [];
for i = 1:size(Ch,1)
    for j = 1:size(Ch,2)
        EoD = cat(2,EoD,Ch(i,j).par.EoD_cb);
    end
end
plotPDF(EoD,180);
xlim([-90 90])
xlabel('Elevation angle')

plotCDF(EoD);
%% AOD
AoD = [];
for i = 1:size(Ch,1)
    for j = 1:size(Ch,2)
        AoD = cat(2,AoD,Ch(i,j).par.AoD_cb);
    end
end

plotPDF(AoD,360);
xlim([-180 180])
xlabel('Azimuth angle')

plotCDF(AoD);

save("Capacity/privateFunc/AoD_EoD_" + myArray + ".mat","AoD","EoD");