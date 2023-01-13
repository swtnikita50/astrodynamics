
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
G_var.orbit = 'halo';
G_var.type = 'northern';    % 'northern'/ 'southern' for halo, 'none' otherwise
G_var.C_req = 2.9;

fval = 10^5;

equilPts = getEquilPts(G_var.mu);
switch G_var.orbit
    case 'lyapunov'
        lb = [equilPts(G_var.librationPt,1)-0.15,0.01];    % [x_0, v_y0]
        ub = [equilPts(G_var.librationPt,1)-0.001,1];
    case 'halo'
        switch G_var.type
            case 'northern'         % for L1, L2: z_0 > 0, for L3: z_0 < 0 
                switch G_var.librationPt
                    case 1
                        lb = [equilPts(G_var.librationPt,1)-0.15, 0.01, 0.01];     % [x_0, z_0, v_y0] 
                        ub = [1-G_var.mu, 1, 5];    % v_y0 > 0
                    case 2
                        lb = [1-mu, 0.01, -5];         % [x_0, z_0, v_y0]
                        ub = [1-mu+1, 1, -0.01];        % v_y0 < 0
                    case 3
                        lb = [-mu-1, -1, 0.01];        % [x_0, z_0, v_y0]
                        ub = [-mu, -0.01, 5];           % v_y0 > 0
                end
            case 'southern'         % for L1, L2: z_0 < 0, for L3: z_0 > 0 
                switch G_var.librationPt
                    case 1
                        lb = [-G_var.mu, -1, 1e-6];    % [x_0, z_0, v_y0] 
                        ub = [1-G_var.mu, -1e-6, 5];    % v_y0 > 0
                    case 2
                        lb = [1-mu, -1, -5];        % [x_0, z_0, v_y0]
                        ub = [1-mu+1, -1e-6, -1e-6];        % v_y0 < 0
                    case 3
                        lb = [-mu-1, -1, 1e-6];        % [x_0, z_0, v_y0]
                        ub = [-mu, -1e-6, 5];           % v_y0 > 0
                end
        end
end
options = optimoptions('particleswarm','SwarmSize',50,'HybridFcn',@fmincon, 'MaxIterations', 250, 'FunctionTolerance', 1e-12,'PlotFcn',{'pswplotbestf',@plotEachGeneration},'UseParallel',logical(1),'ObjectiveLimit',1e-1);%,'FunValCheck','on');

%rng default  % For reproducibility
func = @(Y) fitnessValue(Y,G_var);
switch G_var.orbit
    case 'lyapunov'
        nvars = 2;
    case 'halo'
        nvars = 3;
end

while fval > 1e-1
    [x,fval,exitflag,output] = particleswarm(func,nvars,lb,ub,options);
end

fitnessValue(x,G_var);
     
switch G_var.orbit 
    case 'lyapunov'
        X0 = [x(1); 0; 0; x(2)];
    case 'halo'
        X0 = [x(1); 0; x(2); 0; x(3); 0];
end

tspan = [0 10];
EventFunc = @(t,x) Events_cres(t,x,G_var);
options = odeset('Reltol',1e-12,'Abstol',1e-12,'Events',EventFunc);
[t,~] = ode45(@(t,X) dynamics(t,X,G_var), tspan, X0, options);
[t,X] = ode45(@(t,X) dynamics(t,X,G_var), [0, 2*t(end)], X0);

figure(3)
switch G_var.orbit
    case 'lyapunov'
        plot(X(:,1),X(:,2)); hold on; grid on;
        scatter(1-G_var.mu,0,'*');
        scatter(equilPts(G_var.librationPt,1),equilPts(G_var.librationPt,2));
    case 'halo'
        plot3(X(:,1),X(:,2),X(:,3)); hold on; grid on;
        scatter3(1-G_var.mu,0, 0,'*');
        scatter3(equilPts(G_var.librationPt,1),equilPts(G_var.librationPt,2), 0);
end