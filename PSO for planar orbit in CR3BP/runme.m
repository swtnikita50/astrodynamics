
clear all;
close all;
clc;

% System Parameters
G_var.mu = 0.01215;
G_var.librationPt = 1;
G_var.C_req = 3.14;

equilPts = getEquilPts(G_var.mu);
switch G_var.librationPt 
    case 1
        lb = [equilPts.L1(1)-0.15,0];
        ub = [equilPts.L1(1)-0.001,5];
    case 2
        lb = [equilPts.L2(1)-0.15,0];
        ub = [equilPts.L2(1)-0.001,5];
    case 3
        lb = [equilPts.L3(1)-0.15,0];
        ub = [equilPts.L3(1)-0.001,5];
end
options = optimoptions('particleswarm','SwarmSize',20,'HybridFcn',@fmincon, 'MaxIterations', 500, 'FunctionTolerance', 1e-15,'PlotFcn', 'pswplotbestf');%,'FunValCheck','on');

%rng default  % For reproducibility
EventFunc = @(t,x) Events_cres(t,x,G_var);
func = @(Y) fitnessValue(Y,G_var);
nvars = 2;
[x,fval,exitflag,output] = particleswarm(func,nvars,lb,ub,options);

% X = 0.7:0.001:0.8;
% T = 4:0.01:5;
% for i = 1:length(X)
%     for j = 1:length(T)
%         J(i,j) = fitnessValue([X(i), T(j)]);
%     end
% end
% surf(J);
tspan = [0 8];
EventFunc = @(t,x) Events_cres(t,x,G_var);
options = odeset('Reltol',1e-12,'Abstol',1e-12,'Events',EventFunc);
[t,X] = ode45(@(t,X) dynamics(t,X,G_var), tspan, [x(1); 0; 0; x(2)], options);
[t,X] = ode45(@(t,X) dynamics(t,X,G_var), [0, 2*t(end)], [x(1); 0; 0; x(2)]);

figure(2)
plot(X(:,1),X(:,2)); hold on;
% scatter(0,1-mu);
% scatter(equilPts.L1(1),equilPts.L1(2));