function Hfreq = channelTimeToFreq(Htime)
    % Htime - временная матрица канала размерностью [Nrx Ntx Npath]
    % Htime - частотная матрица канала размерностью [Nrx Ntx Nfreq]

    N_FFT = 512;
    numRx = size(Htime,1);
    numTx = size(Htime,2);
    
    Hfreq = zeros(numRx,numTx,N_FFT);
    for iRx = 1:numRx
        for iTx = 1:numTx
            h_time = squeeze(Htime(iRx,iTx,:)).';
            h_freq = fft(h_time, N_FFT);
            Hfreq(iRx,iTx,:) = h_freq;
%             figure();
%             plot(mag2db(fftshift(abs(h_freq))));
        end
    end
end