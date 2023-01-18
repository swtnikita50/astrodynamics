function val = fitnessValue(Y, G_var)

mu = G_var.mu;
C_req = G_var.C_req;
equilPts = getEquilPts(mu);
disp(Y)
tspan = [0 10];

switch G_var.orbit
    case 'lyapunov'
        x_0 = Y(1);
        v_y0 = Y(2);
        y_0 = 0;
        v_x0 = 0;
        X0 = [x_0; y_0; v_x0; v_y0];
        U = (x_0^2+y_0^2)/2 + (1-mu)/sqrt((x_0+mu)^2+y_0^2) + mu/sqrt((x_0+mu-1)^2+y_0^2);
        C = 2*U - (v_x0^2 + v_y0^2);
    case 'halo'
        x_0 = Y(1);
        z_0 = Y(2);
        v_y0 = Y(3);
        y_0 = 0;
        v_x0 = 0;
        v_z0 = 0;
        X0 = [x_0; y_0; z_0; v_x0; v_y0; v_z0];
        U = (x_0^2 + y_0^2)/2 + (1 - mu)/sqrt((x_0 + mu)^2 + y_0^2 + z_0^2) + mu/sqrt((x_0 + mu - 1)^2 + y_0^2 + z_0^2);
        C = 2*U - (v_x0^2 + v_y0^2 + v_z0^2);
    case 'axial'
        x_0 = Y(1);
        v_y0 = Y(2);
        v_z0 = Y(3);
        y_0 = 0;
        z_0 = 0;
        v_x0 = 0;
        X0 = [x_0; y_0; z_0; v_x0; v_y0; v_z0];
        U = (x_0^2 + y_0^2)/2 + (1 - mu)/sqrt((x_0 + mu)^2 + y_0^2 + z_0^2) + mu/sqrt((x_0 + mu - 1)^2 + y_0^2 + z_0^2);
        C = 2*U - (v_x0^2 + v_y0^2 + v_z0^2);
end


EventFunc = @(t,x) Events_cres(t,x,G_var);
options = odeset('Reltol',1e-12,'Abstol',1e-12,'Events',EventFunc);
[t,X] = ode45(@(t,X) dynamics(t,X,G_var), tspan, X0, options);
[t,X] = ode45(@(t,X) dynamics(t,X,G_var), [0 2*t(end)], X0);

switch G_var.orbit
    case 'lyapunov'
        val = abs(X(end,1)-X(1,1)) + abs(X(end,2)) + abs(X(end,3)) + abs(X(end,4)-X(1,4)) + 10*abs(C_req-C);
    case {'halo', 'axial'}
        val = abs(X(end,1)-X(1,1)) + abs(X(end,2)-X(1,2)) + abs(X(end,3)-X(1,3)) +...
            abs(X(end,4)-X(1,4)) + abs(X(end,5)-X(1,5)) + abs(X(end,6)-X(1,6)) + 10*abs(C_req-C);  
end

[t,X] = ode45(@(t,X) dynamics(t,X,G_var), [0 t(end)/2], X0);
% condition for lyapunov orbit
switch G_var.orbit
    case 'lyapunov'
        switch G_var.librationPt
            case 1
                if X(end,1) > 1-mu || X(end,1) < equilPts(G_var.librationPt,1)
                    val = 10^5;
                end
            case 2
                if X(end,1) > equilPts(G_var.librationPt,1) || X(end,1) < 1-mu
                    val = 10^5;
                end
            case 3
                if X(end,1) > -mu || X(end,1) < equilPts(G_var.librationPt,1)
                    val = 10^5;
                end
        end
    case 'halo'
        if X(end,3) == 0
            val = 10^5;
        end
end

disp(val);

% figure(1)
% plot3(X(:,1),X(:,2), X(:,3))
% pause(0.01)


end





    