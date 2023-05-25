function ro_int = initRtx()
    load 'AoD_EoD.mat' AoD EoD;
    EoD = EoD(:).*pi/180;
    EoD = pi/2-EoD;     % отсчет углов от оси z, 0 - зенит, 90 - горизонт
    AoD = AoD(:).*pi/180;
    AoD = mod(AoD + pi/2, 2*pi);   % решетка в плоскости X 0 Z
    
    %% %%%%%%%%%%%%%%%%%%% оценка параметров распределения по углу места, распределение Лапласа, углы в радианах
    len = length(EoD);      % число измерений
    theta0 = median(EoD);   % среднее значение угла места
    alpha = 1./(sum(abs(EoD-median(EoD)))./length(EoD));    % разброс угла места
    %%%%%%%%%%%%%%%%%%% Плотность вероятности для угла места
    pdf_theta = @(theta) alpha/2.*exp(-alpha.*abs(theta-theta0));
    pdf_theta_sin = @(theta) pdf_theta(theta).*sin(theta);  % домноженная на sin плотность для нормировки
    %% %%%%%%%%%%%%%%%%%%% оценка параметров распределения по азимуту, распределение Фон-Мизеса, углы в радианах
    N_AoD = length(AoD);                    % число измерений
    phi0 = angle(mean(exp(1i.*AoD)));       % среднее значение азимута
    R2 = (sum(cos(AoD))./N_AoD).^2 + (sum(sin(AoD))./N_AoD).^2;
    R2e = N_AoD/(N_AoD-1)*(R2 - 1/N_AoD);
    Re = sqrt(R2e);
    tmp_fun = @(x)abs(besseli(1,x)./besseli(0,x)-Re);
    k = fminbnd(tmp_fun, 0, 100);           % "дисперсия" распределения
    
    %%%%%%%%%%%%%%%%%%% Плотность вероятности для азимута
    pdf_phi = @(phi) exp(k*cos(phi-phi0))./(2*pi*besseli(0,k));
    
    %%%%%%%%%%%%%%%%%%% Нормировочные константы 
    C_theta = integral(pdf_theta_sin, 0, pi);
    C_phi = integral(pdf_phi, 0, 2*pi);
    
    
    %%%%%%%%%%%%%%%%%%% Подынтегральное выражение корреляционной функции
    %%%%%%%%%%%%%%%%%%% phi, theta переменные интегрирования, dx, dz параметры
    ro_int = @(phi, theta, dx, dz) exp(1i*2*pi.*(dx.*sin(theta).*cos(phi) + dz.*cos(theta)))...
                                  .*pdf_theta(theta).*pdf_phi(phi).*sin(theta)./C_theta./C_phi;
end