function [C, lambda] = calculateData(H,numSTS,snr,numExp)
    % H - матрица канала размерностью [Nrx Ntx Nch]
    C = zeros(numExp,length(snr));
    lambda = zeros(numExp,1);
    for i = 1:numExp
        sqHtime = squeeze(H(:,:,:,i));

        sqHfreq = channelTimeToFreq(sqHtime);
%         sqH = sqH/norm(sqH,"fro");
        [C(i,:), sigma] = mimoCapacityOne(sqHfreq,snr,numSTS);
        lambda(i) = sum(sigma(1:numSTS).^2);
    end
end
%%
function [C, sigma] = mimoCapacityOne(H, snr_dB, numSTS)
    % H - матрица канала размерностью [Nrx Ntx Nfreq]
    % snr_dB - в дБ
    numTx = size(H,2);
    numFreq = size(H,3);

    snr = 10.^(snr_dB/10);    
    C = zeros(1,length(snr));
    for iS = 1:length(snr_dB)
        Cfreq = zeros(1,numFreq);
        for iF = 1:numFreq
            sqH = squeeze(H(:,:,iF));
            sigma = svd(sqH); % eig(H*H') = svd(H)^2 
            lambda = sigma(1:numSTS).^2;
            Cfreq(iF) = 1/numSTS*sum(log2(1 + 1/numTx*snr(iS)*abs(lambda))); % 1/numSTS нормировка по потокам 
        end
        C(iS) = mean(Cfreq); 
    end
end
