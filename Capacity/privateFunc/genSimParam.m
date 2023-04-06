function s = genSimParam(c_freq)
    s = qd_simulation_parameters;               % Set general simulation parameters
    s.center_frequency = c_freq;                   % Set center frequency for the simulation
    s.use_3GPP_baseline = 1;                    % Disable spherical waves
    s.show_progress_bars = 0;                   % Disable progress bar
end

