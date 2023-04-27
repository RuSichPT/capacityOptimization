function [C, lambda] = calculateData(H,snr,numExp)
    % H - матрица канала размерностью [Nrx Ntx Nch]
    C = zeros(numExp,length(snr));
    lambda = zeros(numExp,1);
    for i = 1:numExp
        sqHtime = squeeze(H(:,:,:,i));

        sqHfreq = channelTimeToFreq(sqHtime);
%         sqH = sqH/norm(sqH,"fro");
        [C(i,:), sigma] = mimoCapacityFreq(sqHfreq,snr);
        lambda(i) = sum(sigma.^2);
        disp("calculated " + i);
    end
end
%%
function [C, sigma] = mimoCapacityFreq(H, snr_dB)
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
