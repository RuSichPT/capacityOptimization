clear;clc;close all;
%% Задаем параметры
numExp = 1;
numRx = 1;
seed = 165;
c_freq = 6e9; % Гц

s = genSimParam(c_freq);
d_rel = 0.25;
d_m = d_rel*s.wavelength;

[aBS, aMT] = antennasSetup(d_m);

rng(seed);
layout = quaDRiGaSetup(numRx,aBS,aMT,s);
b = initBuilder(layout);
rng('shuffle');

H = genChannels(b,numExp,numRx);
H = permute(H,[2 1 3]);
squeeze(H(:,:,1))

name ="q1_chans_tx=" + aBS.no_elements + "_d_rel=" + d_rel + "_seed=" + seed + "_n=" + numExp + ".mat"; 
% save(name,"H")
