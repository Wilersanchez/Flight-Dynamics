% gust simulator script 
clc; clear; close all; tic

%
% Initialize time (s), thrust (N), propellant mass (g), angle of attack (deg), and aerodynamic
% coefficients data for Aerotech L1150 and NACA 0012
%
global tdata;
global Tdata;
global mdata;
global alphadata;
global CLfindata1;
global CLfindata2;
global CDfindata;
tdata = csvread('Simulation Thrust.csv', 0, 0, [0 0 97 0]);
Tdata = csvread('Simulation Thrust.csv', 0, 1, [0 1 97 1]);
mdata = csvread('Simulation Propellant Mass.csv', 0, 1, [0 1 97 1]);
alphadata = csvread('NACA 0012 Cl.csv', 0, 3, [0 3 27 3]);
CLfindata1 = csvread('NACA 0012 Cl.csv', 0, 1, [0 1 27 1]);
CLfindata2 = csvread('NACA 0012 Cd.csv', 0, 3, [0 3 17 3]);
CDfindata = csvread('NACA 0012 Cd.csv', 0, 1, [0 1 17 1]);


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
nsteps = 50;
tspan = linspace(t0,tf,nsteps);

%
% Simulate launch for wind=0 m/s
%
windh = 5; % for some reason doesn't have an effect on the apogee.
windv = 0;

for i = 1:1000
    [t0,y0] = ode45(@rocket_ode,tspan,[0 0 0 0 pi/2 0 0]);
    apogee(i) = max(-y0(:,2));
end

apogee(0 == apogee) = nan;
figure(1)
edges = 1300:10:1500;
histogram(apogee,edges);