function H = genChannels(b,numChan,no_rx)
    H = [];
    for i = 1:numChan
       tempH = generateChannel(b,no_rx);
       H = cat(3,H,tempH);
    end
end

function H = generateChannel(b,no_rx)
    sic = size(b);
    for ib = 1: numel(b)
        [i1, i2] = qf.qind2sub(sic, ib);
        b(i1,i2).gen_parameters(2);             % Generate SSF parameters 
    end
    cm = get_channels(b);                       % Generate channels
    
    H = [];
    for i = 1:no_rx
        temp = cm(i).coeff(:,:,2);
        H = cat(1,H,temp);
    end
end