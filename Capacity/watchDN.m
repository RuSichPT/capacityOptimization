clc;clear;close all;
%%
BDaz=[40 50 60 70 80 90 110];
BDel=[40 50 60 70 80 90 110];

figure();
for i = 1:length(BDaz)
    [custom, par ] = qd_arrayant.generate('custom', BDaz(i), BDel(i), 0);

    plot(-90:90,custom.Fa(:,181))
    hold on;
end
legend(num2str(BDaz(:)))
grid on;
ylabel("D");
xlabel("Elevation angle");
title("Pattern for azimuth = 0")
xlim([-90 90]);

figure();
for i = 1:length(BDaz)
    [custom, par ] = qd_arrayant.generate('custom', BDaz(i), BDel(i), 0);

    plot(-180:180,custom.Fa(91,:))
    hold on;
end
legend(num2str(BDaz(:)))
grid on;
ylabel("D");
title("Pattern for elevation = 0")
xlabel("Azimuth angle");
xlim([-180 180]);

