function [C, lambda, condH, rankH] = calculateData(H,numSTS,snr,numExp)
    % H - матрица канала размерностью [Nrx Ntx Nch]
    F = 1;
    C = zeros(numExp,length(snr));
    lambda = zeros(numExp,1);
    condH = zeros(numExp,1);
    rankH = zeros(numExp,1);
    for i = 1:numExp
        sqH = squeeze(H(:,:,i));
%         sqH = sqH/norm(sqH,"fro");
        [C(i,:), sigma] = mimoCapacityOne(sqH, F, snr, numSTS);
        lambda(i) = sum(sigma(1:numSTS).^2);
        condH(i) = cond(sqH);
        rankH(i) = rank(sqH);
    end
end
%%
function [C, sigma] = mimoCapacityOne(H, F, snr_dB, numSTS)
    % H - матрица канала размерностью [Nrx Ntx Nch]
    % F - матрица прекодирования
    % snr_dB - в дБ
    numTx = size(H,2);
    if size(H,1) > size(H,2)
        warning("maybe dimensions are confused");
    end

    snr = 10.^(snr_dB/10);    
    C = zeros(1,length(snr));
    for i = 1:length(snr_dB)
        sigma = svd(H*F); % eig(H*H') = svd(H)^2 
        lambda = sigma(1:numSTS).^2;
%         sum(lambda)
        C(i) = 1/numSTS*sum(log2(1 + 1/numTx*snr(i)*abs(lambda))); % 1/numSTS нормировка по потокам 
    end
end
