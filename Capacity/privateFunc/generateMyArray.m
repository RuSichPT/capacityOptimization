function a = generateMyArray(sizeArray, spacing, tilt, fc, arrayType)
    % sizeArray - размер решетки [vertical horizontal];
    % vertical - кол-во элементов по вертикали ось Z
    % horizontal - кол-во элементов по горизонтали ось Y
    %
    % spacing - расстояние между элементами [vertical horizontal];
    % vertical - расстояние между элементами по вертикали ось Y 
    % horizontal - расстояние между элементами по вертикали ось Z
    %
    % fc - центральная частота
    % arrayType - тип элемента решетки
    %%
    cLight = physconst('LightSpeed');
    lambda = cLight/fc;

    a = qd_arrayant(arrayType);
    a.center_frequency = fc;
    a.rotate_pattern(tilt,'y');
%     a.visualize(1);
    a.copy_element(1,sizeArray(1)*sizeArray(2));

    M = sizeArray(1);
    N = sizeArray(2);
    T = 1;
    
    % Set vertical positions
    tmp = (0:M-1) * lambda*spacing(1);
    posv = tmp - mean(tmp);
    tmp = reshape( posv(ones(1,N),:).' , 1 , [] );
    a.element_position(3,:) = reshape( tmp(ones(T,1),:) ,1,[] );
    
    % Set horizontal positions
    tmp = (0:N-1) * lambda*spacing(2);
    posh = tmp - mean(tmp);
    tmp = reshape( posh(ones(1,M),:) , 1 , [] );
    a.element_position(2,:) = reshape( tmp(ones(T,1),:) ,1,[] );
end