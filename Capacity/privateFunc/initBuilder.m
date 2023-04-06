function b = initBuilder(layout)
    b = layout.init_builder;                    % Generate builders
    sic = size(b);
    for ib = 1: numel(b)
        [i1, i2] = qf.qind2sub(sic, ib);
        scenpar = b(i1, i2).scenpar;            % Read scenario parameters
        scenpar.SC_lambda = 0;                  % Disable spatial consistency of SSF
        b(i1, i2).scenpar_nocheck = scenpar;    % Save parameters without check (faster)
    end
    b.gen_parameters();                          % Generate LSF and SSF parameters (uncorrelated)
end