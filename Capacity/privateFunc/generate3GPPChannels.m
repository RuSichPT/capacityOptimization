function [H, Ch, l, b] = generate3GPPChannels(sizeArray,spacing,numUsers,numChan,seed,power,myArray)
    % sizeArray - размер решетки [vertical horizontal];
    % numUsers - кол-во пользователей
    % numChan - кол-во каналов
    % seed - сид ГПСЧ
    %% Sim param
    s = qd_simulation_parameters;
    s.use_3GPP_baseline = 1;
    s.show_progress_bars = 0;
    %% Arrays
    fc = 2e9;
    polarization = 1;
    tilt = 12; % for polarization 4,5,6

    if (myArray == "omni") || (myArray == "dipole")
        aBS = generateMyArray(sizeArray(1),sizeArray(2),fc,spacing,myArray);    
    elseif (myArray == "3gpp-mmw")
        aBS = qd_arrayant(myArray,sizeArray(1),sizeArray(2),fc,polarization,tilt,spacing,1,1);
    else
        error("Нет такой решетки")
    end

    aBS.Fa = aBS.Fa*power;
    aBS.Fb = aBS.Fb*power;

    aMS = qd_arrayant('omni');
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
    l.set_scenario('3GPP_38.901_UMa',[],[],0.8);
    rng("shuffle");
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
        disp("created " + i);
    end
end