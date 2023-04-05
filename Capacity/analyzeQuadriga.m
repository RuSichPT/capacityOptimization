clear;clc;%close all;
addpath("privateFunc");
% coeff = 1e5; % snr = 0 db       слагаемое 0.3 - 2
% coeff = 5e5; % snr = 10 db      слагаемое 9-49
% coeff = 1e6; % snr = 20 db      слагаемое 37-199
% coeff = 2.5e6; % snr = 25 db      слагаемое 200-1200
coeff = 1e7; % snr = 30 db      слагаемое 900-5000
%% Задаем параметры
Hqua5 = loadTrans("dataBase/q1_chans_tx=8_d_rel=5_seed=165_n=1000.mat").*coeff;
Hqua05 = loadTrans("dataBase/q1_chans_tx=8_d_rel=0.5_seed=165_n=1000.mat").*coeff;
Hqua025 = loadTrans("dataBase/q1_chans_tx=8_d_rel=0.25_seed=165_n=1000.mat").*coeff;
Hqua025_16 = loadTrans("dataBase/q1_chans_tx=16_d_rel=0.25_seed=165_n=1000.mat").*coeff;
Hqua025_24 = loadTrans("dataBase/q1_chans_tx=24_d_rel=0.25_seed=165_n=1000.mat").*coeff;

numSTS = size(Hqua5,1);
numRx = numSTS;
numExp = size(Hqua5,3);
snr_dB = 0; 
%% Графики
figure('Name','CDF');
hold on
[C_5, l1, ~, ~] = calculateData(Hqua5,numSTS,snr_dB,numExp);
[~, statsC_5] = cdfplot(C_5(:,1));
disp("mean C_qua: " + statsC_5.mean);

[C_05, l2, ~, ~] = calculateData(Hqua05,numSTS,snr_dB,numExp);
[~, statsC_05] = cdfplot(C_05(:,1));
disp("mean C_qua: " + statsC_05.mean);

[C_025, l3, ~, ~] = calculateData(Hqua025,numSTS,snr_dB,numExp);
[~, statsC_025] = cdfplot(C_025(:,1));
disp("mean C_qua: " + statsC_025.mean);

[C_025_16, l4, ~, ~] = calculateData(Hqua025_16,numSTS,snr_dB,numExp);
[~, statsC_025_16] = cdfplot(C_025_16(:,1));
disp("mean C_qua: " + statsC_025_16.mean);

[C_025_24, l5, ~, ~] = calculateData(Hqua025_24,numSTS,snr_dB,numExp);
[~, statsC_025_24] = cdfplot(C_025_24(:,1));
disp("mean C_qua: " + statsC_025_24.mean);

legend("tx = 24 drel = 5", "tx = 24 drel = 0.5", "tx = 24 drel = 0.25", ...
    "tx = 48 drel = 0.25","tx = 72 drel = 0.25")
%%
function H = loadTrans(name)
    H = load(name).H;
    H = permute(H,[2 1 3]);
end