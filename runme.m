

systemParameters;
equilPts = getEquilPts(mu);
lb = [equilPts.L1(librationPt)-0.15,3];
ub = [equilPts.L1(librationPt),8];
options = optimoptions('particleswarm','SwarmSize',100,'HybridFcn',@fmincon);

rng default  % For reproducibility
nvars = 2;
[x,fval,exitflag,output] = particleswarm(@fitnessValue,nvars,lb,ub,options);