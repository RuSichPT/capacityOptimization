clc;clear;close all;
%% Задаем параметры
snr = 20;             % SNR в дБ
numChan = 100;
numRx = 100;
Nz = 4;
Ny = 8;
dz = 2;
dy = 0.514;
XPR_dB = -40:2:-2;
XPR = db2mag(XPR_dB);
%%
C = zeros(1,length(XPR));
antennaType = 'custom';
BW(1) = 90;
BW(2) = 20;
for i = 1:length(XPR)
    R = calculateRtx1(dy,dz,Ny,Nz,XPR(i),antennaType,BW);
    numTx = Ny*Nz*2;
    H = createKroneckerChannels(numTx,numRx,numChan,R,1);
    [tmpC, lambda_r] = calculateData(H,snr,numChan);
    C(i) = mean(tmpC);
    disp("calculated " + i);
end
%%
figure();
plot(XPR_dB,C);
hold on;
grid on;
xlabel("XPR, db");
ylabel('Mean Capacity');