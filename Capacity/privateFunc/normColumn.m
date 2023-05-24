function Z = normColumn(Z)
    numTx = size(Z);
    for j = 1:numTx
        Z(:,j) = Z(:,j)/sum(Z(:,j),1);
    end
end