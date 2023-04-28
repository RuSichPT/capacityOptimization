function a = generateMyArray(vertical, horizontal, fc, spacing, arrayType)
    % vertical - кол-во элементов по вертикали ось Z
    % horizontal - кол-во элементов по вертикали ось Y

    cLight = physconst('LightSpeed');
    lambda = cLight/fc;

    a = qd_arrayant (arrayType);
    a.center_frequency = fc;
    a.copy_element(1,vertical*horizontal);

    M = vertical;
    N = horizontal;
    T = 1;
    
    % Set vertical positions
    tmp = (0:M-1) * lambda*spacing;
    posv = tmp - mean(tmp);
    tmp = reshape( posv(ones(1,N),:).' , 1 , [] );
    a.element_position(3,:) = reshape( tmp(ones(T,1),:) ,1,[] );
    
    % Set horizontal positions
    tmp = (0:N-1) * lambda*spacing;
    posh = tmp - mean(tmp);
    tmp = reshape( posh(ones(1,M),:) , 1 , [] );
    a.element_position(2,:) = reshape( tmp(ones(T,1),:) ,1,[] );
end