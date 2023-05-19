clc;clear;close all;
%% Задаем параметры
numTx = 32;
numRx = 100;
snr = 20;             % SNR в дБ
numChan = 100;

% Задаем корреляцию
n = 0;
mu = pi/3;
d = 0.5;
arg1 = sqrt(n*n - 4*pi*pi*d*d + 4*pi*1i*n*sin(mu)*d);
arg = imag(arg1);
r = besselj(0,arg)/besseli(0,n);
R = toeplitz([1 r r zeros(1,numTx-3)]);
vec = ones(1,numTx-1)*r;
% R = toeplitz([1 vec]);
R = normColumn(R);

% Задаем связь (coupling)
A = 13.4;
a = exp(-A*d);
Z = toeplitz([1 a a zeros(1,numTx-3)]);
vec1 = ones(1,numTx-1)*a;
% Z = toeplitz([1 vec1]);
Z = normColumn(Z);
%%
% Без корреляции
Hsta = createKroneckerChannels(numTx,numRx,numChan,1,1);
[C, lambda] = calculateData(Hsta,snr,numChan);
% С корреляции
Hsta = createKroneckerChannels(numTx,numRx,numChan,R,1);
[C_r, lambda_r] = calculateData(Hsta,snr,numChan);
% Со связью
Hsta = createKroneckerChannels(numTx,numRx,numChan,1,Z);
[C_c, lambda_c] = calculateData(Hsta,snr,numChan);
% Все
Hsta = createKroneckerChannels(numTx,numRx,numChan,R,Z);
[C_r_c, lambda_r_c] = calculateData(Hsta,snr,numChan);
%% Графики
figure('Name','CDF');
hold on
[~, statsC] = cdfplot(C(:,1));
disp("mean C: " + statsC.mean);
[~, statsC_r] = cdfplot(C_r(:,1));
disp("mean C_r: " + statsC_r.mean);
[~, statsC_c] = cdfplot(C_c(:,1));
disp("mean C_c: " + statsC_c.mean);
[~, statsC_r_c] = cdfplot(C_r_c(:,1));
disp("mean C_r_c: " + statsC_r_c.mean);
legend('C','C_r','C_c','C_r_c');
%%
function Z = normColumn(Z)
    numTx = size(Z);
    for j = 1:numTx
        Z(:,j) = Z(:,j)/sum(Z(:,j),1);
    end
end
