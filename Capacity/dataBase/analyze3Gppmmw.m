clc;clear;close all
C1 = load("ant=4x4_numChan=100_users=100_spacing=0.5_seed=200_my=3gpp-mmw.mat").C;
C2 = load("ant=4x4_numChan=100_users=100_spacing=0.25_seed=200_my=3gpp-mmw.mat").C;
C3 = load("ant=4x8_numChan=100_users=100_spacing=0.5_seed=200_my=3gpp-mmw.mat").C;
C4 = load("ant=4x8_numChan=100_users=100_spacing=0.25_seed=200_my=3gpp-mmw.mat").C;
%% Size and Spacing
range = {C1 C2 C3 C4};
plotAll(range);
legend("4x4 d = 0.5","4x4 d = 0.25","4x8 d = 0.5","4x8 d = 0.25")
