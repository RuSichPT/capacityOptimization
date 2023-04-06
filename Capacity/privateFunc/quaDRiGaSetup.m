function layout = quaDRiGaSetup(no_rx,aBS,aMT,s)
    % no_rx - Number of MTs (directly scales the simulation time)   
    isd = 300;                                  % Inter-site distance [m]
    no_go_dist = 35;                            % Min. UE-eNB 2D distance [m]
    
    layout = qd_layout.generate('hexagonal', 1, isd, aBS);       
    layout.tx_position(3,:) = 25;               % meters BS height
    layout.simpar = s;                          % Set simulation parameters
    layout.name = 'UMa';
    layout.no_rx = no_rx;

    % Create UE positions
    ind = true(1, no_rx);                       % UMa / UMi placement
    while any(ind)
        layout.randomize_rx_positions(0.93 * isd, 1.5, 1.5, 0, ind);
        ind = sqrt(layout.rx_position(1, :) .^ 2 + layout.rx_position(2, :) .^ 2) < no_go_dist;
    end
    floor = randi(5, 1, layout.no_rx) + 3;      % Number of floors in the building
    for i = 1:layout.no_rx
        floor(i) = randi(floor(i));             % Floor level of the UE
    end
    layout.rx_position(3, :) = 3 * (floor - 1) + 1.5;
    
    indoor_rx = layout.set_scenario('3GPP_38.901_UMa', [], [], 0.8);
    layout.rx_position(3, ~indoor_rx) = 1.5;    % Set outdoor-users to 1.5 m height
    layout.rx_array = aMT;                      % MT antenna setting
end
