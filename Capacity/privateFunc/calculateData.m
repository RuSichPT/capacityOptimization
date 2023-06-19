function [C, lambdaChan] = calculateData(H,snr,numChan)
    % H - матрица канала размерностью [numRx numTx numPath numChan] или[numRx numTx numChan]
    C = zeros(numChan,length(snr));
    lambdaChan = zeros(numChan,1);
    for i = 1:numChan
        if length(size(H)) == 4
            sqHtime = squeeze(H(:,:,:,i));
            sqHfreq = channelTimeToFreq(sqHtime);
            [C(i,:), lambda] = mimoCapacityFreq(sqHfreq,snr);
        else
            sqH = squeeze(H(:,:,i));
            [C(i,:), lambda] = mimoCapacity(sqH,snr);
        end
        lambdaChan(i) = sum(lambda);
        disp("Capacity for chan " + i + " calculated ");
    end
end
%%
function [C, lambda] = mimoCapacityFreq(H, snr_dB)
    % H - матрица канала размерностью [Nrx Ntx Nfreq]
    % snr_dB - в дБ
    numRx = size(H,1);
    numTx = size(H,2);
    numFreq = size(H,3);

    snr = 10.^(snr_dB/10);    
    C = zeros(1,length(snr));
    for iS = 1:length(snr_dB)
        Cfreq = zeros(1,numFreq);
        for iF = 1:numFreq
            sqH = squeeze(H(:,:,iF));
            sigma = svd(sqH); % eig(H*H') = svd(H)^2 
            lambda = sigma.^2;
            Cfreq(iF) = 1/numRx*sum(log2(1 + 1/numTx*snr(iS)*abs(lambda))); % 1/numSTS нормировка по потокам 
        end
        C(iS) = mean(Cfreq); 
    end
end
