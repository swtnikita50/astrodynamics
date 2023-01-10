function [position,isterminal,direction] = Events_cres(t,x,G_var)

mu = G_var.mu;

isterminal = 1; 
position = x(2);

switch G_var.librationPt
    case 1
        direction = -1;
    case 2
        direction = 1;
    case 3
        direction = -1;
end

 end