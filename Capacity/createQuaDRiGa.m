function [H] = createQuaDRiGa(no_rx,numChan,seed)
    c_freq = 6e9; % Гц
    s = genSimParam(c_freq);
    d_m = 5*s.wavelength;
    [aBS, aMT] = antennasSetup(d_m);

    rng(seed);
    layout = quaDRiGaSetup(no_rx,aBS,aMT,s);
    b = initBuilder(layout);
    rng('shuffle');

    H = genChannels(b,numChan,no_rx);
end
