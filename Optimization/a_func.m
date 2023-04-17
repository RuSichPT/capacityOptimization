function f = a_func(n)
    % n = 0,1...N
    threshold = 30;     % db
    ang3dB = 65;        % degrees

    A_H_func = @(phi) (-min(12*((phi*180/pi)/ang3dB).^2,threshold)); % аргумент в радианах
    if n == 0
        arg = @(x) A_H_func(x) / 2;
    else
        arg = @(x) A_H_func(x).*cos(n*x);
    end
    f = 1/pi*integral(arg,-pi,pi);% в радианах!!! ошибка похоже в статье
end