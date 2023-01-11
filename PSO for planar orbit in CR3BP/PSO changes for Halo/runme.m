
clear all;
close all;
clc;


% ----------------*------------o--------------*-----o------*--------
%                 L3           m1             L1    m2     L2

% for halo orbit x_0 the bounds are decided as such

%                 L3           m1             L1    m2     L2
% ----------------*------------o--+-----------*-----o------*--------
% ----------------------------][-------------------][---------------


% System Parameters
G_var.mu = 0.01215;
G_var.librationPt = 1;
G_var.orbit = 'Lyapunov';
G_var.type = 'none';    % 'northern'/ 'southern' for halo, 'none' otherwise
G_var.C_req = 3.14;

equilPts = getEquilPts(G_var.mu);
switch G_var.orbit
    case 'Lyapunov'
        lb = [equilPts(G_var.librationPt,1)-0.15,0];    % [x_0, v_y0]
        ub = [equilPts(G_var.librationPt,1)-0.001,5];
    case 'Halo'
        switch G_var.type
            case 'northern' % for L1, L2: z_0 > 0, for L3: z_0 < 0 
                switch G_var.librationPt
                    case 1
                        lb = [-G_var.mu, 0];    % [x_0, z_0, v_y0]
                        ub = [1-G_var.mu, 5];
                    case 2
                        lb = [1-mu, 0];    % [x_0, z_0, v_y0]
                        ub = [equilPts(G_var.librationPt,1)-0.001, 5];
                    case 3
                        lb = [equilPts(G_var.librationPt,1)-0.15, -5];    % [x_0, z_0, v_y0]
                        ub = [-mu, 0];
                end
            case 'southern' % for L1, L2: z_0 < 0, for L3: z_0 > 0 
                lb = [equilPts(G_var.librationPt,1)-0.15,0];    % [x_0, z_0, v_y0]
                ub = [equilPts(G_var.librationPt,1)-0.001,5];
        end
end
options = optimoptions('particleswarm','SwarmSize',20,'HybridFcn',@fmincon, 'MaxIterations', 500, 'FunctionTolerance', 1e-15,'PlotFcn', 'pswplotbestf');%,'FunValCheck','on');

%rng default  % For reproducibility
func = @(Y) fitnessValue(Y,G_var);
switch G_var.orbit
    case 'Lyapunov'
        nvars = 2;
    case 'Halo'
        nvars = 3;
end
[x,fval,exitflag,output] = particleswarm(func,nvars,lb,ub,options);
     


tspan = [0 8];
EventFunc = @(t,x) Events_cres(t,x,G_var);
options = odeset('Reltol',1e-12,'Abstol',1e-12,'Events',EventFunc);
[t,X] = ode45(@(t,X) dynamics(t,X,G_var), tspan, [x(1); 0; 0; x(2)], options);
[t,X] = ode45(@(t,X) dynamics(t,X,G_var), [0, 2*t(end)], [x(1); 0; 0; x(2)]);

figure(2)
plot(X(:,1),X(:,2)); hold on;
scatter(1-mu,0);
scatter(equilPts.L1(1),equilPts.L1(2));