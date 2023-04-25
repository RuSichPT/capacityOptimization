function H = getChannelsFromQuaDRiGa(qd_channel)
    % qd_channel - каналы QuaDRiGa
    
    maxClusters = qd_channel(1).no_path;
    for i = 2:length(qd_channel)
        if qd_channel(i).no_path > maxClusters
            maxClusters = qd_channel(i).no_path;
        end
    end


    H = [];
    for i = 1:length(qd_channel)
        coeff = qd_channel(i).coeff;
        if size(coeff,3) < maxClusters
            zero = zeros(size(coeff,1),size(coeff,2),maxClusters-size(coeff,3));
            coeff = cat(3,coeff,zero);
        end
        H = cat(1,H,coeff);
    end
end