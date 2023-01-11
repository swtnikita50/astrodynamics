function equilPts = getEquilPts(mu)
xe4 = cosd(60)-mu;
xe5 = xe4;

ye4 = sind(60);
ye5=-ye4;

%L3
A0 = -1+3*mu-3*mu^2;
A1 = -2 +4*mu +mu^2 -2*mu^3 +mu^4;
A2 = -1 -2*mu+6*mu^2 -4*mu^3;
A3 = 1-6*mu +6*mu^2;
A4 = 2-4*mu;

a = [1 A4 A3 A2 A1 A0];
A = roots(a);
xe3 = -real(A(imag(A) == 0));

% L2
A0 = -1+3*mu-3*mu^2;
A1 = 2 -4*mu +mu^2 -2*mu^3 +mu^4;
A2 = -1 +2*mu-6*mu^2 +4*mu^3;
A3 = 1-6*mu +6*mu^2;
A4 =-2+4*mu;

a = [1 A4 A3 A2 A1 A0];
A = roots(a);
xe2 = real(A(imag(A) == 0));

% L1
A0 = -1+3*mu-3*mu^2+2*mu^3;
A1 = 2 -4*mu +5*mu^2 -2*mu^3 +mu^4;
A2 = -1 +4*mu-6*mu^2 -4*mu^3;
A3 = 1-6*mu +6*mu^2;
A4 =-2+4*mu;

a = [1 A4 A3 A2 A1 A0];
A = roots(a);
xe1 = real(A(imag(A) == 0));

equilPts(1,:) = [xe1,0];
equilPts(2,:) = [xe2, 0];
equilPts(3,:) = [xe3, 0]; 
equilPts(4,:) = [xe4, ye4]; 
equilPts(5,:) = [xe5, ye5];

