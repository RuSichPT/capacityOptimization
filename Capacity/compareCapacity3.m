clc;clear;close all;
%% Задаем параметры
snr = 20;             % SNR в дБ
numChan = 100;
numRx = 100;
Nz = [4 5 6];
Ny = [8 10];
dz = [2 1.5 1.2];
dy = [0.514 0.4 ];
[resY,resZ] = checkAperture(Ny,dy,3.6,Nz,dz,6);
%%
C = zeros(length(Ny),length(Nz));
antennaType = 'custom';
BW(1) = 90;
BW(2) = 20;
for i = 1:length(Ny)
    for j = 1:length(Nz)
        R = calculateRtx1(dy(i),dz(j),Ny(i),Nz(j),1,antennaType,BW);
        numTx = Ny(i)*Nz(j)*2;% двухполяризационные элементы
        H = createKroneckerChannels(numTx,numRx,numChan,R,1);
        [tmpC, lambda_r] = calculateData(H,snr,numChan);
        C(i,j) = mean(tmpC);
        disp("calculated " + i + " " + j);
    end
end
%%
figure();
str = cell(1,length(Nz));
for j = 1:length(Nz)
    plot(Ny,C(:,j));
    hold on;
    str{j} = "Nz = " + num2str(Nz(j));
end
grid on;
xlabel("Ny " + antennaType + " " + BW(1) + "x" + BW(2));
ylabel('Mean Capacity');
legend(str{:})

figure();
str = cell(1,length(Ny));
for j = 1:length(Ny)
    plot(Nz,C(j,:));
    hold on;
    str{j} = "Ny = " + num2str(Ny(j));
end
grid on;
xlabel("Nz " + antennaType + " " + BW(1) + "x" + BW(2));
ylabel('Mean Capacity');
legend(str{:})