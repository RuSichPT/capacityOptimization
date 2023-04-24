clc;clear;close all
%% Задаем параметры
numChan = 1;
numUsers = 100;
seed = 200;
sizeArray = [4 8]; 
%% Канал
[H, Ch, l, b] = generate3GPPChannels(sizeArray,numUsers,numChan,seed,'3GPP_38.901_UMa',0.8);
EoD = [];

ch1 = Ch(1,:);
for i = 1:size(ch1,2)
    EoD = cat(2,EoD,ch1(i).par.EoD_cb);
end

figure();
histogram(EoD,180);

figure('Name','CDF');
hold on
[~, ~] = cdfplot(EoD);