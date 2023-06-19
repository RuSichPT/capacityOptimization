clc;clear;close all;
%%
numChan = 10;
numRx = 100;
snr = 20;             % SNR в дБ
Ny = 8;
dy = 0.514;
Nz = 4;
dz = 2;
numTx = Nz*Ny;
antennaType = 'patch';
BW = [10 20 40 50 60 70 80 90 100 110];
%% 
Caz = zeros(1,length(BW));
Cel = zeros(1,length(BW));
for i = 1:length(BW)
    ro_az = initRtx(antennaType,[BW(i) 90]);
    Raz = calculateRtx(dy,dz,Ny,Nz,ro_az);
    Haz = createKroneckerChannels(numTx,numRx,numChan,Raz,1);
    [tmpCaz, ~] = calculateData(Haz,snr,numChan);
    Caz(i) = mean(tmpCaz);

    ro_el = initRtx(antennaType,[90 BW(i)]);
    Rel = calculateRtx(dy,dz,Ny,Nz,ro_el);
    Hel = createKroneckerChannels(numTx,numRx,numChan,Rel,1);
    [tmpCel, ~] = calculateData(Hel,snr,numChan);
    Cel(i) = mean(tmpCel);

    disp("BW " + i + " calculated")
end
%%
figure();
plot(BW,Caz,"LineWidth",1.5)
grid on;
ylabel("Mean Capacity");
xlabel("Azimuth width");

figure();
plot(BW,Cel,"LineWidth",1.5);
grid on;
ylabel("Mean Capacity");
xlabel("Elevation width");
