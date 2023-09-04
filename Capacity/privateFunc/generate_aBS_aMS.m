function [aBS,aMS] = generate_aBS_aMS(sizeArray,spacing,power,myArray,fc,tilt,BW)
    % sizeArray - размер решетки [vertical horizontal];
    % spacing - расстояние между элементами [vertical horizontal];
    % power - коэффициент домножения
    % myArray - тип антенного элемента
    % tilt - повернуть ДН и поляризацию на tilt градусов
    % BW - ширина ДН [BW azimuth  BW Elevation] для custom
    %% Arrays
    polarization = 1;

    if (myArray == "omni") || (myArray == "dipole")
        aBS = generateMyArray(sizeArray,spacing,tilt,fc,myArray);    
    elseif (myArray == "3gpp-mmw")
        aBS = qd_arrayant(myArray,sizeArray(1),sizeArray(2),fc,polarization,tilt,spacing(1),1,1);
    elseif (myArray == "custom")
        [aBS, ~] = qd_arrayant.generate(myArray, BW(1), BW(2), 0);
    else
        error("Нет такой решетки")
    end

    aBS.Fa = aBS.Fa*power;
    aBS.Fb = aBS.Fb*power;

    aMS = qd_arrayant('omni');
end