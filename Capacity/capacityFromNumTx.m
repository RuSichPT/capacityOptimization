clc;clear;close all;
%%
numRx = 100;
numChan = 100;
snr = [0, 10, 20, 30];             % SNR в дБ
Nz = [4 5 6 7 8 9 10];
Ny = [8 10 12 14 16 18 20];
numTx = Nz.*Ny;
%%
C = zeros(length(snr),length(numTx));
for i = 1:length(snr)
    for j = 1:length(numTx)
        H = createKroneckerChannels(numTx(j),numRx,numChan,1,1);
        [tmpC, lambda_r] = calculateData(H,snr(i),numChan);
        C(i,j) = mean(tmpC);
        disp("calculated " + i + " " + j);
    end
end
%%
figure();
str = cell(1,length(snr));
for i = 1:length(snr)
    plot(numTx/numRx,C(i,:));
    hold on;
    str{i} = "snr = " + num2str(snr(i)) + " dB";
end
grid on;
xlabel('numTx/numRx');
ylabel('Mean Capacity');
legend(str{:})