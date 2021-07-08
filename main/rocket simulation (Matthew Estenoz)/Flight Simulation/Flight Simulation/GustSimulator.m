% gust simulator script 
clc; clear; close all; tic

%
% Define variables for velocity of wind
%
global windv;
global windh;

%
% convert to fixed time step solver
%
t0 = 0;
tf = 15;
nsteps = 1000;
tspan = linspace(t0,tf,nsteps);

%
% Simulate launch for wind=0 m/s
%
windh = 10; % for some reason doesn't have an affect on the apogee.
windv = 0;
for i = 1:100
    [x] = ode45(@differentialEquation,tspan,[0 0 0 0 pi/2 0 0]);
    apogee(i) = max(-x(:,3));
end
apogee(0 == apogee) = nan;
figure(1)
edges = 1300:10:1500;
histogram(apogee,edges);