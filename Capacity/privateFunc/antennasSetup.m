function [aBS, aMT] = antennasSetup(d_m)
    % BS antenna configuration
    aBS = qd_arrayant('ula8');
    appendArray(aBS)
    aBS.combine_pattern;                        % Calculate array response
    aBS.element_position(1,:) = d_m;            % Distance from pole in [m]
    
    aMT = qd_arrayant('omni');                  % MT antenna configuration
    aMT.copy_element(1,2);                      % Duplicate the dipole
end

function appendArray(aBS)
    add = qd_arrayant('ula8');
    aBS.append_array(add)
%     aBS.append_array(add)
end
