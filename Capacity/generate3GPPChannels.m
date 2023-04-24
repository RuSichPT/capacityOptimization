function [H, Ch, l, b] = generate3GPPChannels(sizeArray,numUsers,numChan,seed,scenario,indoor_frc)
    % size - размер решетки [vertical horizontal];
    % numUsers - кол-во пользователей
    % numChan - кол-во каналов
    % seed - сид ГПСЧ
    %% Sim param
    s = qd_simulation_parameters;
    s.use_3GPP_baseline = 1;
    s.show_progress_bars = 0;
    %% Arrays
    fc = 2e9;
    lambda = 0.5;
    polarization = 1;
    tilt = 12; % for polarization 4,5,6
    aBS = qd_arrayant ('3gpp-mmw', sizeArray(1), sizeArray(2), fc, polarization, tilt, lambda);
    aMS = qd_arrayant('omni');
    % aMS.copy_element(1,2);
    %% Layout
    l = qd_layout(s);
    l.tx_array = aBS;
    l.rx_array = aMS;
    l.no_rx = numUsers;  
    
    rng(seed)
    l.randomize_rx_positions(200,1.5,15,0,[],55);      % 200 m radius, 1.5 m Rx height
    for j = 1:size(l.rx_position,2)
        if l.rx_position(1,j) < 0
            l.rx_position(1,j) = abs(l.rx_position(1,j));
        end 
    end
%     l.rx_position(1,1) = 50;
%     l.rx_position(2,1) = 10;
%     l.rx_position(1,2) = 50;
%     l.rx_position(2,2) = -10;
    rng("shuffle");
    l.set_scenario(scenario,[],[],indoor_frc);
    %%
    visualizeAll(l);
    %%
    b = l.init_builder;
    rng(seed)
    b.gen_parameters();
    rng("shuffle");
    
    H = [];
    Ch = [];
    for i = 1:numChan
        b.gen_ssf_parameters(0);
        b.gen_ssf_parameters();
        cm = get_channels(b);
        Ch = cat(1,Ch,cm);
        H = cat(4,H,getChannelsFromQuaDRiGa(cm));
        disp("numChan " + i);
    end
end