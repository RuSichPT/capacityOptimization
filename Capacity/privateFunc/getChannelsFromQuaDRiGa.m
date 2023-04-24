function H = getChannelsFromQuaDRiGa(qd_channel)
    % qd_channel - каналы QuaDRiGa

    H = [];
    for i = 1:length(qd_channel)
        H = cat(1,H,qd_channel(i).coeff);
    end
end