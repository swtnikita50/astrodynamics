function  Xdot = dynamics(t,X, G_var)
mu = G_var.mu;

switch G_var.orbit
    case 'lyapunov'
        
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
    case 'halo'
        x = X(1);
        y = X(2);
        z = X(3);
        
        mu1 = 1-mu; % mass of larger  primary (nearest origin on left)
        mu2 =   mu; % mass of smaller primary (furthest from origin on right)
        
        % The Distances from the larger and Smaller Primary
        d3= ((x+mu2)^2 + y^2 + z^2)^1.5;    % P3 and larger primary
        r3= ((x-mu1)^2 + y^2 + z^2 )^1.5;   % P3 and larger primary
        
        % Partial Derivative of the Pseudo Potential Function
        Ux =  x - mu1*(x+mu2)/d3 - mu2*(x-mu1)/r3 ;
        Uy =  y - mu1* y     /d3 - mu2* y     /r3 ;
        Uz = -mu1*z/d3 - mu2*z/r3;
        
        xDot  = X(4);
        yDot  = X(5);
        zDot  = X(6);
        xDDot = 2*yDot + Ux;
        yDDot = -2*xDot + Uy;
        zDDot = Uz;
        
        Xdot = [xDot;yDot;zDot;xDDot;yDDot;zDDot];
end
end

