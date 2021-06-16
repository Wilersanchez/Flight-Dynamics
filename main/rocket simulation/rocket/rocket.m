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
% global bdp;                         % Barrowman design parameters
% bdp = readmatrix('Cp_MinieMagg.csv');
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
% Simulate launch for wind=0 m/s
%
windh = 1;
windv = 0;
[t0,y0] = ode45(@rocket_ode,[0 20],[0 0 0 0 pi/2 0 0 0]);

%
% Simulate launch for wind=10 m/s
%
windh = 9;
windv = 0;
[t1,y1] = ode45(@rocket_ode,[0 20],[0 0 0 0 pi/2 0 0 0]);


%
% Convert altitude/velocity from meters to feet

y0(:,1:4) = y0(:,1:4)/.3048;
y1(:,1:4) = y1(:,1:4)/.3048;

%
% Convert angles/rates from radians to degrees
%
y0(:,5:6) = y0(:,5:6)*180/pi;
y1(:,5:6) = y1(:,5:6)*180/pi;

%
% Compute maximum altitude
%
[apogee0,index0] = max(-y0(:,2));
[apogee1,index1] = max(-y1(:,2));
disp(['Apogee with wind v = 1  m/s ',num2str(apogee0),' (ft)']);
disp(['Apogee with wind v = 2 m/s ',num2str(apogee1),' (ft)']);

%
% Only take data until apogee
%

[~,ApogeeIndex0] = min(y0(:,2));
y0 = y0(1:ApogeeIndex0,:);
t0 = t0(1:ApogeeIndex0,:);

[~,ApogeeIndex1] = min(y1(:,2));
y1 = y1(1:ApogeeIndex1,:);
t1 = t1(1:ApogeeIndex1,:);


%
% Plot trajectory
%
figure(1)
plot(y0(:,1),-y0(:,2),'k',y1(:,1),-y1(:,2),'r');
xlabel('Downrange (ft)');
ylabel('Altitude (ft)');
legend('no wind','wind v = 10 m/s');


%
% Plot pitch angle
%
figure(2)
plot(t0,y0(:,5),'k',t1,y1(:,5),'r');
xlabel('Time (s)');
ylabel('Pitch Angle (deg)');
legend('no wind','wind v = 10 m/s');


%
% Plot trajectory with time
%
figure(3)
plot3(t0,y0(:,1),-y0(:,2),'k',t1,y1(:,1),-y1(:,2),'r');
xlabel('Time (s)');
ylabel('Downrange (ft)');
zlabel('Altitude (ft)');
legend('no wind','wind v = 10 m/s');


%
% Plot velocity
%
figure(4)
plot(t0,y0(:,3),'k',t1,y1(:,3),'r')
xlabel('Time (s)');
ylabel('Forward Velocity (m/s)');
legend('no wind','wind v = 10 m/s');
toc