function R_TX = calculateRtxTwoPolarizations(dy_len,dz_len,n_y,n_z,chi_crosspol, antenna_type, BW)
load('AoD_EoD.mat');
EoD = EoD(:).*pi/180;
% EoD = pi/2-EoD;     % ������ ����� �� ��� z, 0 - �����, 90 - ��������
AoD = AoD(:).*pi/180;
% AoD = mod(AoD + pi/2, 2*pi);   % ������� � ��������� X 0 Z

%% %%%%%%%%%%%%%%%%%%% ������ ���������� ������������� �� ���� �����, ������������� �������, ���� � ��������
len = length(EoD);      % ����� ���������
theta0 = median(EoD);   % ������� �������� ���� �����
alpha = 1./(sum(abs(EoD-median(EoD)))./length(EoD));    % ������� ���� �����
%%%%%%%%%%%%%%%%%%% ��������� ����������� ��� ���� �����
pdf_theta = @(theta) alpha/2.*exp(-alpha.*abs(theta-theta0));
pdf_theta_cos = @(theta) pdf_theta(theta).*cos(theta);  % ����������� �� cos ��������� ��� ����������

%% %%%%%%%%%%%%%%%%%%% ������ ���������� ������������� �� �������, ������������� ���-������, ���� � ��������
N_AoD = length(AoD);                    % ����� ���������
phi0 = angle(mean(exp(1i.*AoD)));       % ������� �������� �������
R2 = (sum(cos(AoD))./N_AoD).^2 + (sum(sin(AoD))./N_AoD).^2;
R2e = N_AoD/(N_AoD-1)*(R2 - 1/N_AoD);
Re = sqrt(R2e);
tmp_fun = @(x)abs(besseli(1,x)./besseli(0,x)-Re);
k = fminbnd(tmp_fun, 0, 100);           % "���������" �������������

%%%%%%%%%%%%%%%%%%% ��������� ����������� ��� �������
pdf_phi = @(phi) exp(k*cos(phi-phi0))./(2*pi*besseli(0,k));


%%%%%%%%%%%%%%%%%%% ������������� ��������� 
C_theta = integral(pdf_theta_cos, -pi/2, pi/2);
C_phi = integral(pdf_phi, -pi, pi);


%%%%%%%%%%%%%%%%%% ������������ TX �������������� ������� "� ���"
%%%%%%%%%%%%%%%%%% ��������������� ��������� �������������� ������� (���
%%%%%%%%%%%%%%%%%% ��������� ��������������� �� ���������)
ro_int1 = @(phi, theta, dy, dz, m, n, k, l) exp(1i*2*pi.*((m-k).*dy.*cos(theta).*sin(phi) + (n-l).*dz.*sin(theta)))...
                              .*pdf_theta(theta).*pdf_phi(phi).*cos(theta)./C_theta./C_phi;	
						  
%%%%%%%%%%%%%%%%%% ������ � �� ���������
%%%%%%%%%%%%%%%%%% ������ ������� V, ������ H
%%%%%%%%%%%%%%%%%% ������� ����� �� � ��������� ���������� ����������
% chi_crosspol = 0.9999;	% ���� ������������������ ����� �������� � �������������������� �����������
switch antenna_type
    case 'dipole'
		element = qd_arrayant.generate('dipole');
	case 'patch'    
		element = qd_arrayant.generate('patch');
	case 'omni'
		element = qd_arrayant.generate('omni');
    case 'custom'
        element = qd_arrayant.generate('custom', BW(1), BW(2), 0);
end
xi=chi_crosspol;
% E_V = {element.Fa.*chi_crosspol,            element.Fa.*sqrt(1-chi_crosspol.^2)};
% E_H = {element.Fa.*sqrt(1-chi_crosspol.^2), element.Fa.*chi_crosspol};
%a.Fb(:,:,1)=a.Fa(:,:,1).*sqrt(xi^2/(1+xi^2));a.Fa(:,:,1)=a.Fa(:,:,1).*sqrt(1/(1+xi^2));
E_V = {element.Fa.*sqrt(1/(1+xi^2)),            element.Fa.*sqrt(xi^2/(1+xi^2))};
E_H = {element.Fa.*sqrt(xi^2/(1+xi^2)), element.Fa.*sqrt(1/(1+xi^2))};
% element_V = importdata('El_1_P2_05_lamb.mat');
% element_H = importdata('El_1_P1_05_lamb.mat');
% E_V = {element_V.Fa, element_V.Fb};
% E_H = {element_H.Fa, element_H.Fb};
%%%%%%%%%%%%%%%%%% ���������� ��������� �������
% C_x = repmat(((n_y-1):-1:0), n_z, 1);
C_y = repmat((0:1:(n_y-1)), n_z, 1);
C_y = C_y(:);
C_z = repmat(((n_z-1):-1:0).', 1, n_y);
C_z = C_z(:);
%%%%%%%%%%%%%%%%%% ������ ������������� ���������� ����� ����� ���������
% R_TX_VV = zeros(n_z*n_y);
% for n1 = 1:n_z*n_y
%     for n2 = 1:n_z*n_y
% 		tmp = @(phi,theta)ro_int1(phi,theta,dy_len,dz_len,C_y(n1),C_z(n1),C_y(n2),C_z(n2)).*...
% 			  (E_V{1}(theta, phi).*E_V{1}(theta, phi) + E_V{2}(theta, phi).*E_V{2}(theta, phi));
%         R_TX_VV(n1, n2) = integral2(tmp, -pi, pi, -pi/2, pi/2);      % R_TX_VV ���� ������� V ��������� � V    
%     end
% end

R_TX_VV = zeros(n_z*n_y);
R_TX_VH = zeros(n_z*n_y);
R_TX_HV = zeros(n_z*n_y);
R_TX_HH = zeros(n_z*n_y);
for n1 = 1:n_z*n_y
% 	tic
	for n2 = 1:n_z*n_y
		tmp = @(phi,theta)ro_int1(phi,theta,dy_len,dz_len,C_y(n1),C_z(n1),C_y(n2),C_z(n2));
		R_TX_VV(n1, n2) = eval_rho(E_V, E_V, tmp, element.elevation_grid, element.azimuth_grid);      % R_TX_VV ���� ������� V ��������� � V
		R_TX_VH(n1, n2) = eval_rho(E_V, E_H, tmp, element.elevation_grid, element.azimuth_grid);      % R_TX_VV ���� ������� V ��������� � H
		R_TX_HV(n1, n2) = eval_rho(E_H, E_V, tmp, element.elevation_grid, element.azimuth_grid);      % R_TX_VV ���� ������� H ��������� � V
		R_TX_HH(n1, n2) = eval_rho(E_H, E_H, tmp, element.elevation_grid, element.azimuth_grid);      % R_TX_VV ���� ������� H ��������� � H
	end
% 	toc
end


R_TX = [R_TX_VV R_TX_VH;
	    R_TX_HV R_TX_HH];
end

