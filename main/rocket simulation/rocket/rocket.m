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


t0 = 0;
tf = 50;
nsteps = 1000;
tspan = linspace(t0,tf,nsteps);

%
% Simulate launch for wind=0 m/s
%
[t0,y0] = ode45(@rocket_ode,tspan,[0 0 0 0 pi/2 0 0]);

%
% Simulate launch for wind=10 m/s
%
[t1,y1] = ode45(@rocket_ode,tspan,[0 0 10 0 pi/2 0 0]);

%
%Simulate launch for wind=20 m/s
%
[t2,y2] = ode45(@rocket_ode,tspan,[0 0 20 0 pi/2 0 0]);

%
% Convert altitude/velocity from meters to feet

y0(:,1:4) = y0(:,1:4);
y1(:,1:4) = y1(:,1:4);
y2(:,1:4) = y2(:,1:4);

%
% Convert angles/rates from radians to degrees
%
y0(:,5:6) = y0(:,5:6)*180/pi;
y1(:,5:6) = y1(:,5:6)*180/pi;
y2(:,5:6) = y2(:,5:6)*180/pi;

%
% Compute maximum altitude
%
[apogee0,index0] = max(-y0(:,2));
[apogee1,index1] = max(-y1(:,2));
[apogee2,index2] = max(-y2(:,2));
disp(['Apogee with wind v = 0  m/s ',num2str(apogee0),' (m)']);
disp(['Apogee with wind v = 10 m/s ',num2str(apogee1),' (m)']);
disp(['Apogee with wind v = 20 m/s ',num2str(apogee1),' (m)']);

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
plot(y0(:,1),-y0(:,2),'k',y1(:,1),-y1(:,2),'r',y2(:,1),-y2(:,2),'b');
xlabel('Downrange (ft)');
ylabel('Altitude (ft)');
legend('no wind','wind v = 10 m/s','wind v = 20 m/s');


%
% Plot pitch angle
%
figure(2)
plot(t0,y0(:,5),'k',t1,y1(:,5),'r',t2,-y2(:,5),'b');
xlabel('Time (s)');
ylabel('Pitch Angle (deg)');
legend('no wind','wind v = 10 m/s','wind v = 20 m/s');


%
% Plot trajectory with time
%
figure(3)
plot3(t0,y0(:,1),-y0(:,2),'k',t1,y1(:,1),-y1(:,2),'r',...
    t2,y2(:,1),-y2(:,2),'b');
xlabel('Time (s)');
ylabel('Downrange (ft)');
zlabel('Altitude (ft)');
legend('no wind','wind v = 10 m/s','wind v = 20 m/s');


%
% Plot velocity
%
figure(4)
plot(t0,y0(:,3),'k',t1,y1(:,3),'r',t2,y2(:,3),'b')
xlabel('Time (s)');
ylabel('Forward Velocity (m/s)');
legend('no wind','wind v = 10 m/s','wind v = 20 m/s');

%
% plot altitude vs. time
%
figure(5)
plot(t0,-y0(:,2),'k',t1,-y1(:,2),'r',t2,-y2(:,2),'b');
xlabel('Altitude (m)');
ylabel('Time (s)');
legend('no wind','wind v = 10 m/s', 'wind v = 20 m/s');
toc