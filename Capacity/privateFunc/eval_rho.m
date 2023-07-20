function [I] = eval_rho(E1, E2, func, elevation_grid, azimuth_grid)
%EVAL_RHO численно рассчитывает корреляционный интеграл с учетом ДН
%   E1 - ДН первого элемента (в формате quadriga)
%   E2 - ДН второго элемента (в формате quadriga)
%	func - function_handle содержащий подынтегральное выражение в
%	аналитическом виде (кроме ДН)

theta = elevation_grid.';
phi = azimuth_grid.';
V1 = E1{1};
H1 = E1{2};
V2 = E2{1};
H2 = E2{2};

theta1 = repmat(theta, 1, length(phi));
phi1 = repmat(phi.', length(theta), 1);
tmp1 = func(phi1, theta1).*(V1.*V2 + H1.*H2);

% for ii = 1:length(theta)
% 	for jj = 1:length(phi)
% 		tmp(ii,jj) = func(phi(jj), theta(ii)).*...
% 			(V1(ii, jj).*V2(ii, jj) + H1(ii, jj).*H2(ii, jj));
% 	end
% end

I = trapz(phi,trapz(theta, tmp1));
end

