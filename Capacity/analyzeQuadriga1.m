clear;clc;close all;
coeff = 1e7;
%% Задаем параметры
Hqua = loadTrans("q_chans_tx=32_lambda=0.5_seed=165_n=10.mat").*coeff;

numSTS = 32;
numRx = numSTS;
numExp = size(Hqua,3);
snr_dB = 0;
%% Графики
figure('Name','CDF');
hold on
[C, l1, ~, ~] = calculateData(Hqua,numSTS,snr_dB,numExp);
[~, statsC_5] = cdfplot(C(:,1));
disp("mean C_qua: " + statsC_5.mean);
%%
function H = loadTrans(name)
    H = load(name).H;
    H = permute(H,[2 1 3]);
end