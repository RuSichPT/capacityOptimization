function [H, Ch, l, b] = generate3GPPChannels(sizeArray,spacing,numUsers,numChan,seed,power,myArray,tilt)
    % sizeArray - размер решетки [vertical horizontal];
    % spacing - расстояние между элементами [vertical horizontal];
    % tilt - повернуть ДН и поляризацию на tilt градусов
    % numUsers - кол-во пользователей
    % numChan - кол-во каналов
    % seed - сид ГПСЧ
    %% Sim param
    s = qd_simulation_parameters;
    s.use_3GPP_baseline = 1;
    s.show_progress_bars = 0;
    %% Arrays
    fc = 3.5e9;
    polarization = 1;

    if (myArray == "omni") || (myArray == "dipole")
        aBS = generateMyArray(sizeArray,spacing,tilt,fc,myArray);    
    elseif (myArray == "3gpp-mmw")
        aBS = qd_arrayant(myArray,sizeArray(1),sizeArray(2),fc,polarization,tilt,spacing(1),1,1);
    else
        error("Нет такой решетки")
    end

    aBS.Fa = aBS.Fa*power;
    aBS.Fb = aBS.Fb*power;

    aMS = qd_arrayant('omni');
    %% Layout
    max_dist = 200;
    l = qd_layout(s);
    l.tx_array = aBS;
    l.rx_array = aMS;
    l.no_rx = numUsers;  
    
    rng(seed)
    l.randomize_rx_positions(max_dist,1.5,1.5,0);                       % Assign random user positions
    l.rx_position(1,:) = l.rx_position(1,:) + max_dist + 20;            % Place users east of the BS
    
    floor = randi(5,1,l.no_rx) + 3;                                     % Set random floor levels
    for n = 1:l.no_rx
        floor(n) = randi(floor(n));
    end
    l.rx_position(3,:) = 3*(floor-1) + 1.5;
    
    indoor_rx = l.set_scenario('3GPP_38.901_UMa_NLOS',[],[],0.8);       % Set the scenario
    l.rx_position(3,~indoor_rx) = 1.5;                                  % Set outdoor-users to 1.5 m height
    rng('shuffle');
    %%
    b = l.init_builder;
    rng(seed)
    b.gen_parameters();
    rng('shuffle');
    
    H = [];
    Ch = [];
    for i = 1:numChan
        b.gen_ssf_parameters(0);
        b.gen_ssf_parameters();
        cm = get_channels(b);
        Ch = cat(1,Ch,cm);
        H = cat(4,H,getChannelsFromQuaDRiGa(cm));
        disp("created " + i);
    end
end