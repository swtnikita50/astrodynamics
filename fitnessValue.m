function val = fitnessValue(Y)
x0 = Y(1);
T = Y(2);

y0 = 0;
gamma0 = pi/2;

[t,X] = ode45(@dynamics, [0, T], [x0; y0; gamma0]);

val = abs(X(1,1)-X(end,1)) + abs(X(end,2)) + ...
    min([mod(abs(X(end,3)-pi/2), 2*pi), abs(mod(-abs(X(end,3)-pi/2),2*pi))]);

end

function  Xdot = dynamics(t,X)
%systemParameters;
mu = 0.1215;
librationPt = 1;
C = 3.15;

x = X(1);
y = X(2);
gamma = X(3);
U = (x^2+y^2)/2 + (1-mu)/sqrt((x+mu)^2+y^2) + mu/sqrt((x+mu-1)^2+y^2);
Ux = x + (1-mu)*(x+mu)/((x+mu)^2+y^2)^(3/2) + mu*(x+mu-1)/((x+mu-1)^2+y^2)^(3/2);
Uy = y + (1-mu)*y/((x+mu)^2+y^2)^(3/2) + mu*y/((x+mu-1)^2+y^2)^(3/2);

vx = sqrt(2*U-C)*cos(gamma);
vy = sqrt(2*U-C)*sin(gamma);
gammadot = (Ux*cos(gamma)-Uy*sin(gamma))/sqrt(2*U-C)-2;
Xdot = [vx; vy; gammadot];
end




    