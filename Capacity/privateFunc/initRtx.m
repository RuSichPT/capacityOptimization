function ro_int = initRtx(antenna_type,BW)
% BW - ширина ДН [BW azimuth  BW Elevation] для custom
    
load 'AoD_EoD.mat' AoD EoD;
EoD = EoD(:).*pi/180;
AoD = AoD(:).*pi/180;
%% %%%%%%%%%%%%%%%%%%% оценка параметров распределения по углу места, распределение Лапласа, углы в радианах
len = length(EoD);      % число измерений
theta0 = median(EoD);   % среднее значение угла места
alpha = 1./(sum(abs(EoD-median(EoD)))./length(EoD));    % разброс угла места
%%%%%%%%%%%%%%%%%%% Плотность вероятности для угла места
pdf_theta = @(theta) alpha/2.*exp(-alpha.*abs(theta-theta0));
pdf_theta_cos = @(theta) pdf_theta(theta).*cos(theta);  % домноженная на cos плотность для нормировки

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
C_theta = integral(pdf_theta_cos, -pi/2, pi/2);
C_phi = integral(pdf_phi, -pi, pi);


%% %%%%%%%%%%%%%%%%%%% Вычисление ДН излучателя
%%%%%%%%%%%%%%%%%%% Включение параметров ДН (диполь)
switch antenna_type
    case 'dipole'
        dipole = qd_arrayant.generate('dipole');
        [dipBWaz, dipBWel] = dipole.calc_beamwidth();
        
        [~, par] = qd_arrayant.generate('custom', dipBWaz, dipBWel, 0);
        parDipole.A = 1;
        parDipole.B = par.B;
        parDipole.C = par.C;
        parDipole.D = 0;
        
        E1 = @(theta, phi, a, b, c, d) a.*sqrt(b+(1-b).*cos(theta).^c.*exp(-d.*phi.^2));
        E = @(theta, phi) E1(theta, phi, parDipole.A, parDipole.B, parDipole.C, parDipole.D);
        %%%%%%%%%%%%%%%%%%% нормировка E
        E_tmp = @(theta, phi) abs(E(theta, phi)).^2.*cos(theta);
        Nrm = sqrt(4*pi./integral2(E_tmp, -pi/2, pi/2, -pi, pi));
        E_nrm = @(theta, phi) E(theta,phi).*Nrm;
        
    case 'patch'        
        %%%%%%%%%%%%%%%%%%% Включение параметров ДН (патч)
        patch = qd_arrayant.generate('patch');
        [patchBWaz, patchBWel] = patch.calc_beamwidth();

        if ~isempty(BW) 
            patchBWaz = BW(1);
            patchBWel = BW(2);
        end
        
        [~, par] = qd_arrayant.generate('custom', patchBWaz, patchBWel, 0);
        parPatch.A = 1;
        parPatch.B = par.B;
        parPatch.C = par.C;
        parPatch.D = par.D;       
        
        E1 = @(theta, phi, a, b, c, d) a.*sqrt(b+(1-b).*cos(theta).^c.*exp(-d.*phi.^2));
        E = @(theta, phi) E1(theta, phi, parPatch.A, parPatch.B, parPatch.C, parPatch.D);
        %%%%%%%%%%%%%%%%%%% нормировка E
        E_tmp = @(theta, phi) abs(E(theta, phi)).^2.*cos(theta);
        Nrm = sqrt(4*pi./integral2(E_tmp, -pi/2, pi/2, -pi, pi));
        E_nrm = @(theta, phi) E(theta,phi).*Nrm;
    case 'omni'
        E_nrm = @(theta, phi) 1;
    otherwise
        fprintf('тип элемента должен быть ''dipole'', ''patch'', ''omni''\n');
        return
end
%% %%%%%%%%%%%%%%%%%%% Подынтегральное выражение корреляционной функции
%%%%%%%%%%%%%%%%%%% phi, theta переменные интегрирования, dy, dz параметры
ro_int = @(phi, theta, dy, dz) exp(1i*2*pi.*(dy.*cos(theta).*sin(phi) + dz.*sin(theta)))...
    .*pdf_theta(theta).*pdf_phi(phi).*cos(theta)...
    .*E_nrm(theta, phi).*conj(E_nrm(theta, phi))./C_theta./C_phi;
end