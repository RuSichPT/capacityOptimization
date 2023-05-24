function R_TX = calculateRtx(dy_len,dz_len,n_y,n_z,ro_int)

    dx_len = dy_len;
    n_x = n_y;
                              
    %%%%%%%%%%%%%%%%%% параметры АР
    x_len = 3.6;      % Апертура решетки по оси х в длинах волн
    z_len = 6;    % Апертура решетки по оси z в длинах волн
    
    % dx_len = 0.5;	% расстояние между элементами по оси x в длиннах волн
    % dz_len = 0.75;   % расстояние между элементами по оси z в длиннах волн
    
    % n_x = floor(x_len/dx_len);  % число элементов по оси x
    % n_z = floor(z_len/dz_len);  % число элементов по оси z
    % n_x = 4;  % число элементов по оси x
    % n_z = 8;  % число элементов по оси z
    
    %%%%%%%%%%%%%%%%% формирование TX, RX корреляционных матриц
    
    %%%%%%%%%%%%%%%%% передатчик - АР
    R_TX1 = zeros(n_z,n_x);
    for i_x = 1:n_x
        for i_z = 1:n_z
            tmp = @(phi,theta)ro_int(phi,theta,dx_len*(i_x-1),dz_len*(i_z-1));
            R_TX1(i_z, i_x) = integral2(tmp, 0, 2*pi, 0, pi);      % R_TX1 - корреляционная функция    
        end
    end
    R_TX = toeplitz(R_TX1(:));      % сформировали корреляционную матрицу
    R_TX = normColumn(R_TX);
    
    %%%%%%%%%%%%%%%%% Приёмник с двумя антеннами, считаем сигналы в антеннах
    %%%%%%%%%%%%%%%%% некоррелированными
    R_RX = eye(2);  % один абонент с двумя антеннами
    
    %%%%%%%%%%%%%%%% Формирование случайной канальной матрицы
    %%%%%%%%%%%%% тест канальной матрицы
    R_RXm = zeros(2);
    R_TXm = zeros(n_z*n_x);
    
    for ii = 1:1000
        G = randn(2, n_x*n_z)./sqrt(2) + 1i.*randn(2, n_x*n_z)./sqrt(2);
        H = sqrtm(R_RX)*G*(sqrtm(R_TX)).';      % матрица канала
        R_RXm = R_RXm + H*H';
        R_TXm = R_TXm + H.'*conj(H);
    end
    R_RXm = R_RXm./1000;
    R_TXm = R_TXm./1000;

end