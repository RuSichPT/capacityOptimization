function [resY,resZ] = checkAperture(Ny,dy,sizeY,Nz,dz,sizeZ)
    resY = check(Ny,dy,sizeY);
    resZ = check(Nz,dz,sizeZ);
end

function res = check(N,d,size)
    treshhold = 0.1;
    res = zeros(1,length(N));
    diff = zeros(1,length(N));
    for i = 1:length(N)
        res(i) = (N(i) - 1)*d(i);
        diff(i) = abs(res(i) - size);
        if diff(i) > treshhold
            error("aperture not equils");
        end
    end
end