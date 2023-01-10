clear;
close all;
clc;

addpath('D:\NIKKY\Software\mice\lib')
addpath('D:\NIKKY\Software\mice\src\mice')

% Construct a meta kernel, "standard.tm”, which will be used to load the needed
% generic kernels: "naif0009.tls," "de421.bsp,” and "pck0009.tpc.”
% Load the generic kernels using the meta kernel, and a Cassini spk.
%****************************%
%     Load SPICE kernels     %
%****************************%
cspice_furnsh('./kernel.txt')
%****************************%

muSUN = 132712440041.939400;
day2sec = 60*60*24;
et = cspice_str2et({'Jan 1, 2025','Dec 1, 2025'});
departureTimes = et(1):day2sec:et(2);
arrivalTimes = departureTimes + 365*day2sec;
launchWindow = length(arrivalTimes);

%% code check
earth = 3;
mars = 4;

%% code check end
parfor i = 1:launchWindow
    disp(i);
    TOFarr = zeros(1, launchWindow);
    dVI = zeros(1,launchWindow);
    dVF = zeros(1,launchWindow);
    [stateEARTH(:,i), icEARTH(i,:), ~] = et2sv(earth,departureTimes(i));
    stateMARS = zeros(6,launchWindow);
    icMARS = zeros(launchWindow,6);
    frnameMARS = zeros(launchWindow);
    svEARTH = stateEARTH(:,i);
    for j = 1:launchWindow
        TOFarr(j) = arrivalTimes(j)-departureTimes(i);
        [stateMARS(:,j), icMARS(j,:), ~] = et2sv(mars,arrivalTimes(j));
        [~,~,~,~,VI,VF,~,~] = lambertMR(svEARTH(1:3),stateMARS(1:3,j),TOFarr(j),muSUN,0);
        dVI(j) = norm(VI-svEARTH(4:6)');
        dVF(j) = norm(stateMARS(4:6,j)' - VF);
    end
    TOF(i,:) = TOFarr(:);
    deltaVI(i,:) = dVI(:);
    deltaVF(i,:) = dVF(:);
end

% plot3(posEARTH(1,:), posEARTH(2,:), posEARTH(3,:));hold on;
% plot3(posMARS(1,:), posMARS(2,:), posMARS(3,:));hold on;
% grid on
% scatter3(0,0,0,'p')