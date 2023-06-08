function plotCDF(x)
    figure('Name','CDF');
    hold on
    [~, statsEoD] = cdfplot(x);
    disp(statsEoD)
end