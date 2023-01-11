function val = fitnessValue(Y, G_var)
x0 = Y(1);
vy0 = Y(2);

C_req = G_var.C_req;
mu = G_var.mu;
equilPts = getEquilPts(mu);
y0 = 0;
vx0 = 0;
disp(Y)
tspan = [0 8];

EventFunc = @(t,x) Events_cres(t,x,G_var);
options = odeset('Reltol',1e-12,'Abstol',1e-12,'Events',EventFunc);
[t,X] = ode45(@(t,X) dynamics(t,X,G_var), tspan, [x0; y0; vx0; vy0], options);

U = (x0^2+y0^2)/2 + (1-mu)/sqrt((x0+mu)^2+y0^2) + mu/sqrt((x0+mu-1)^2+y0^2);
C = 2*U - (vx0^2 + vy0^2);

val = abs(X(end,3)) + abs(C_req-C);

% condition for lyapunov orbit
switch G_var.librationPt
    case 1
        if X(end,1) > 1-mu || X(end,1) < equilPts.L1(1)
            val = 1000;
        end
    case 2
        if X(end,1) > equilPts.L2(1) || X(end,1) < 1-mu
           val = 1000;
        end
    case 3
        if X(end,1) > -mu || X(end,1) < equilPts.L3(1)
           val = 1000;
        end
end
disp(val);

% figure(1)
% plot(X(:,1),X(:,2))
% pause(0.01)


end





    