clc;clear;close all
%% Задаем параметры
numExp = 2;
numUsers = 4;
seed = 165;
vertical = 2;
horizontal = 2; 
lambda = 0.5;
fc = 2e9;
tilt = 12; % for polarization 4,5,6
polarization = 1;
%%
aBS = qd_arrayant ('3gpp-3d', vertical, horizontal, fc, polarization, tilt, lambda);
aMS = qd_arrayant('omni');

l = qd_layout();                                       % Create new QuaDRiGa layout
l.simpar.show_progress_bars = 0;
l.simpar.use_3GPP_baseline = 1;
l.tx_array = aBS;
l.rx_array = aMS;
l.no_rx = numUsers;                                          % Set number of MTs
l.randomize_rx_positions(200,1.5,15,0,[],55);      % 200 m radius, 1.5 m Rx height

for j=1:size(l.rx_position,2)
    if l.rx_position(1,j) < 0
        l.rx_position(1,j) = abs(l.rx_position(1,j))+20;
    end 
end
pos = l.rx_position;
l.set_scenario('3GPP_38.901_UMa',[],[],0);                      % Use NLOS scenario
%% visualize
% visualizeAll(l);
%%
b1 = l.init_builder;
rng(seed);
b1.init_sos;
b1.gen_parameters();
rng('shuffle');

cm = get_channels(b1);                       % Generate channels
H1 = [];
for i = 1:numUsers
    temp = cm(i).coeff(:,:,2);
    H1 = cat(1,H1,temp);
end
H1
% l.randomize_rx_positions(200,1.5,15,0,[],55);      % 200 m radius, 1.5 m Rx height
% 
% for j=1:size(l.rx_position,2)
%     if l.rx_position(1,j) < 0
%         l.rx_position(1,j) = abs(l.rx_position(1,j))+20;
%     end 
% end
% b2 = l.init_builder;
% rng(seed);
% b2.init_sos;
% b2.gen_parameters();
% rng('shuffle');
cm = get_channels(b1);                       % Generate channels
H2 = [];
for i = 1:numUsers
    temp = cm(i).coeff(:,:,2);
    H2 = cat(1,H2,temp);
end
H2

% H = genChannels(b,numExp,numUsers);
% H = permute(H,[2 1 3]);
% squeeze(H(:,:,1))
% squeeze(H(:,:,2))
%% Save
name ="Capacity/dataBase/q_chans_tx=" + aBS.no_elements + "_lambda=" + lambda + "_seed=" + seed + "_n=" + numExp + ".mat"; 
% save(name,"H")