function plotAll(range)
    figure('Name','CDF');
    hold on
    for i = 1:length(range)
        C = range{i};
        % Графики
        [h, statsC] = cdfplot(C(:,1));  
        h.LineWidth = 2;
        disp("mean C_qua: " + statsC.mean);
    end
    disp(newline);
end