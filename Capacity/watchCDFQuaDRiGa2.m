clc;clear;close all

load('Capacity\privateFunc\AoD_EoD_omni.mat');
AoD_omni = AoD;
EoD_omni = EoD;

load('Capacity\privateFunc\AoD_EoD_dipole.mat');
AoD_dipole = AoD;
EoD_dipole = EoD;
clear AoD EoD
%%
plotPDF(AoD_omni,360);
xlim([-180 180])
xlabel('Azimuth angle')

plotPDF(EoD_omni,180);
xlim([-90 90])
xlabel('Elevation angle')

plotPDF(AoD_dipole,360);
xlim([-180 180])
xlabel('Azimuth angle')

plotPDF(EoD_dipole,180);
xlim([-90 90])
xlabel('Elevation angle')