function R_TX = calculateRtx(dy_len,dz_len,n_y,n_z,ro_int)
%%%%%%%%%%%%%%%%%% параметры АР

% dy_len = 0.5;	% расстояние между элементами по оси x в длиннах волн
% dz_len = 0.75;   % расстояние между элементами по оси z в длиннах волн

% n_x = floor(x_len/dx_len);  % число элементов по оси x
% n_z = floor(z_len/dz_len);  % число элементов по оси z
% n_y = 8;  % число элементов по оси x
% n_z = 4;  % число элементов по оси z

%%%%%%%%%%%%%%%%% формирование TX, RX корреляционных матриц

%%%%%%%%%%%%%%%%% передатчик - АР
%%%%%%%%%%%%%%%%% расчет необходимых коэффициентов корреляции
R_TX1 = zeros(n_z*2-1,n_y);
for i_x = 1:n_y
    for i_z = 1:(n_z*2-1)
        tmp = @(phi,theta)ro_int(phi,theta,dy_len*(i_x-1),dz_len*(i_z-n_z));
        R_TX1(i_z, i_x) = integral2(tmp, -pi, pi, -pi/2, pi/2);      % R_TX1 - корреляционная функция    
    end
end
%%%%%%%%%%%%%%%%%% формирование TX корреляционной матрицы с учетом свойств
%%%%%%%%%%%%%%%%%% симметрии

R_TX2 = [];
R_tmp = zeros(n_z);

bias_indx_x = 1;
bias_indx_z = 1 + n_z;
offset_indx_x = 0;
for i_x1 = 1:n_y
	offset_indx_z = 0;
	for ii = 1:n_z
		for jj = 1:n_z
			R_tmp(jj,ii) = R_TX1(bias_indx_z+offset_indx_z-jj,...
				                 bias_indx_x+offset_indx_x);
		end
		offset_indx_z = offset_indx_z + 1;
	end
	offset_indx_x = offset_indx_x + 1;
	R_TX2 = [R_TX2 R_tmp];
end

% R_TX2 - первая "строка" эрмитовой матрицы R_TX
% формирование полной матрицы R_TX
R_TX = zeros(n_y*n_z);
for ii = 1:n_y
	for jj = 1:(n_y-ii+1)
		R_TX((1:n_z)+(jj-1)*n_z, (1:n_z)+(jj-1)*n_z+(ii-1)*n_z) = R_TX2(:,(1:n_z) + (ii-1)*n_z);
		R_TX((1:n_z)+(jj-1)*n_z+(ii-1)*n_z, (1:n_z)+(jj-1)*n_z) = R_TX2(:,(1:n_z) + (ii-1)*n_z)';
	end
end
end