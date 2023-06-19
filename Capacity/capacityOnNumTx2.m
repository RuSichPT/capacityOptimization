clc;clear;close all;
%%
numRx = 100;
numChan = 100;
snr = [0, 10, 20, 30, 40];             % SNR в дБ
Nz = [4 5 6 7 8 9];
Ny = [8 10 12 14 16 18];
dz = [2 1.5 1.2 1 0.857 0.75];
dy = [0.514 0.4 0.33 0.277 0.24 0.212];
numTx = Nz.*Ny;
[resY,resZ] = checkAperture(Ny,dy,3.6,Nz,dz,6);
%%
C1 = zeros(length(snr),length(numTx));
C2 = zeros(length(snr),length(numTx));
antennaType = 'omni';
ro_int = initRtx(antennaType);
for i = 1:length(snr)
    for j = 1:length(numTx)
        R1 = calculateRtx(dy(j),dz(j),Ny(j),Nz(j),ro_int);
        H1 = createKroneckerChannels(numTx(j),numRx,numChan,R1,1);
        [tmpC1, ~] = calculateData(H1,snr(i),numChan);
        C1(i,j) = mean(tmpC1);

        R2 = 1; 
        H2 = createKroneckerChannels(numTx(j),numRx,numChan,R2,1);
        [tmpC2, ~] = calculateData(H2,snr(i),numChan);
        C2(i,j) = mean(tmpC2);

        disp("calculated " + i + " " + j);
    end
end
%%
figure();
str1 = cell(1,length(snr));
for i = 1:length(snr)
    plot(numTx/numRx,C1(i,:));
    hold on;
    str1{i} = "R, snr = " + num2str(snr(i)) + " dB";
end
str2 = cell(1,length(snr));
for i = 1:length(snr)
    plot(numTx/numRx,C2(i,:),"LineWidth",2);
    hold on;
    str2{i} = "R = I, snr = " + num2str(snr(i)) + " dB";
end
grid on;
xlabel('numTx/numRx');
title(antennaType)
ylabel('Mean Capacity');
legend(str1{:},str2{:});

% save(antennaType + ".mat","C1","C2");