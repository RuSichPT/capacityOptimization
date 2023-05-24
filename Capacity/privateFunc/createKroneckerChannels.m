function Hk = createKroneckerChannels(numTx,numRx,numChan,R,Z)
    Hk = zeros(numRx,numTx,numChan);
    for k = 1:numChan
        H = createStaticChannel(numTx,numRx);
        H = H.';
        Hk(:,:,k) = H*sqrtm(R)*Z;
    end
end