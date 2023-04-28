clc;clear;close all
C1 = load("ant=4x4_numChan=100_users=100_spacing=0.5_seed=200_my=1.mat").C;
C2 = load("ant=4x8_numChan=100_users=100_spacing=0.5_seed=200_my=1.mat").C;
C3 = load("ant=8x4_numChan=100_users=100_spacing=0.5_seed=200_my=1.mat").C;
C4 = load("ant=8x8_numChan=100_users=100_spacing=0.5_seed=200_my=1.mat").C;
C5 = load("ant=8x16_numChan=100_users=100_spacing=0.5_seed=200_my=1.mat").C;
C6 = load("ant=16x8_numChan=100_users=100_spacing=0.5_seed=200_my=1.mat").C;
C7 = load("ant=16x16_numChan=100_users=100_spacing=0.5_seed=200_my=1.mat").C;
C8 = load("ant=4x4_numChan=100_users=100_spacing=0.25_seed=200_my=1.mat").C;
C9 = load("ant=4x4_numChan=100_users=100_spacing=0.1_seed=200_my=1.mat").C;
C10 = load("ant=4x8_numChan=100_users=100_spacing=0.25_seed=200_my=1.mat").C;
C11 = load("ant=8x4_numChan=100_users=100_spacing=0.25_seed=200_my=1.mat").C;
%% Size
range = {C1 C2 C3 C4 C5 C6 C7};
plotAll(range);
legend("4x4","4x8","8x4","8x8","8x16","16x8","16x16")
%% Spacing
range = {C1 C8 C9};
plotAll(range);
legend("d = 0.5","d = 0.25","d = 0.1")
%% Size and Spacing
range = {C1 C8 C2 C3 C10 C11};
plotAll(range);
legend("4x4 d = 0.5","4x4 d = 0.25","4x8 d = 0.5","8x4 d = 0.5","4x8 d = 0.25","8x4 d = 0.25")
