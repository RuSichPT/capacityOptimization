clc;clear;close all
%% Задаем параметры
numChan = 1;
numUsers = 100;
seed = 200;
sizeArray = [4 8];
power = 1e6;
%% Канал
[H, Ch, l, b] = generate3GPPChannels(sizeArray,numUsers,numChan,seed,power);
%% EOD
EoD = [];
ch1 = Ch(1,:);
for i = 1:size(ch1,2)
    EoD = cat(2,EoD,ch1(i).par.EoD_cb);
end
figure();
histogram(EoD,180);
grid on
figure('Name','CDF');
hold on
[~, statsEoD] = cdfplot(EoD);
disp(statsEoD)

%% AOD
AoD = [];
ch1 = Ch(1,:);
for i = 1:size(ch1,2)
    AoD = cat(2,AoD,ch1(i).par.AoD_cb);
end
figure();
histogram(AoD,360);
grid on
figure('Name','CDF');
hold on
[~, statsAoD] = cdfplot(AoD);
disp(statsAoD)