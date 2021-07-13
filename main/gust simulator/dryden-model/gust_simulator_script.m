% gust simulator script 
clc; clear; close all; tic

%
% Initialize time (s), thrust (N), propellant mass (g), angle of attack (deg), and aerodynamic
% coefficients data for Aerotech M2500T and NACA 0012
%

global alphadata;
global CLfindata1;
global CLfindata2;
global CDfindata;
alphadata = csvread('NACA 0012 Cl.csv', 0, 3, [0 3 27 3]);
CLfindata1 = csvread('NACA 0012 Cl.csv', 0, 1, [0 1 27 1]);
CLfindata2 = csvread('NACA 0012 Cd.csv', 0, 3, [0 3 17 3]);
CDfindata = csvread('NACA 0012 Cd.csv', 0, 1, [0 1 17 1]);

global simproperties;
simproperties = readmatrix('simproperties.csv');

%
% convert to fixed time step solver
%
t0 = 0;
tf = 50;
nsteps = 1000;
tspan = linspace(t0,tf,nsteps);

for i = 1:10
    [t0,y0] = ode45(@rocket_ode,tspan,[0 0 0 0 pi/2 0 0]);
    apogee(i) = max(-y0(:,2));
end

apogee(0 == apogee) = nan;
figure(1)
edges = 2500:1:2750;
histogram(apogee,edges);
toc