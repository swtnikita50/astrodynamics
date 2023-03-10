function  Xdot = dynamics(t,X, G_var)
mu = G_var.mu;

x = X(1);
y = X(2);


mu1 = 1-mu; % mass of larger  primary (nearest origin on left)
mu2 =   mu; % mass of smaller primary (furthest from origin on right)

% The Distances from the larger and Smaller Primary
d3= ((x+mu2)^2 + y^2)^1.5;    
r3= ((x-mu1)^2 + y^2 )^1.5;

% Partial Derivative of the Pseudo Potential Function

Ux =  x - mu1*(x+mu2)/d3 - mu2*(x-mu1)/r3 ;
Uy =  y - mu1* y     /d3 - mu2* y     /r3 ;

xDot  = X(3);
yDot  = X(4);

xDDot = 2*yDot + Ux;
yDDot = -2*xDot + Uy;


Xdot = [xDot;yDot;xDDot;yDDot];
end

