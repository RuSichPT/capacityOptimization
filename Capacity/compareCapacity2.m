clc;clear;close all;
%% Задаем параметры
snr = 20;             % SNR в дБ
numChan = 100;
numRx = 100;
Nz = [4 8];
Ny = [8 10 12 14];
dz = [2 0.857];
dy = [0.514 0.4 0.33 0.277];
[resY,resZ] = checkAperture(Ny,dy,3.6,Nz,dz,6);
%%
C1 = zeros(length(Ny),length(Nz));
C2 = zeros(length(Ny),length(Nz));
antennaType = 'omni';
ro_int = initRtx(antennaType);
for i = 1:length(Ny)
    for j = 1:length(Nz)
        numTx = Ny(i)*Nz(j);
        R1 = calculateRtx(dy(i),dz(j),Ny(i),Nz(j),ro_int);
        H1 = createKroneckerChannels(numTx,numRx,numChan,R1,1);
        [tmpC1, ~] = calculateData(H1,snr,numChan);
        C1(i,j) = mean(tmpC1);

        R2 = 1; 
        H2 = createKroneckerChannels(numTx,numRx,numChan,R2,1);
        [tmpC2, ~] = calculateData(H2,snr,numChan);
        C2(i,j) = mean(tmpC2);

        disp("calculated " + i + " " + j);
    end
end
%%
figure();
str1 = cell(1,length(Nz));
for j = 1:length(Nz)
    plot(Ny,C1(:,j));
    hold on;
    str1{j} = "R, Nz = " + num2str(Nz(j));
end
str2 = cell(1,length(Nz));
for j = 1:length(Nz)
    plot(Ny,C2(:,j));
    hold on;
    str2{j} = "R = I, Nz = " + num2str(Nz(j));
end
grid on;
xlabel("Ny " + antennaType);
ylabel('Mean Capacity');
legend(str1{:},str2{:});