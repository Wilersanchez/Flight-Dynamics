clc; clear; close all;

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
global bdp;                         % Barrowman design parameters
bdp = readmatrix('Cp_MinieMagg.csv');
tdata = csvread('Simulation Thrust.csv', 0, 0, [0 0 97 0]);
Tdata = csvread('Simulation Thrust.csv', 0, 1, [0 1 97 1]);
mdata = csvread('Simulation Propellant Mass.csv', 0, 1, [0 1 97 1]);
alphadata = csvread('NACA 0012 Cl.csv', 0, 3, [0 3 27 3]);
CLfindata1 = csvread('NACA 0012 Cl.csv', 0, 1, [0 1 27 1]);
CLfindata2 = csvread('NACA 0012 Cd.csv', 0, 3, [0 3 17 3]);
CDfindata = csvread('NACA 0012 Cd.csv', 0, 1, [0 1 17 1]);
global i;
i = 1;
global tval;
tval = 0;
global v_uoutput;
global v_uoutputd;
global v_vinput;
global v_vinputd;
global v_voutput;
global v_voutputd;
global v_voutputdd;
v_uoutput = 0;
v_uoutputd = 0;
v_vinput = 0;
v_vinputd = 0;
v_voutput = 0;
v_voutputd = 0;
v_voutputdd = 0;

%
% Define variables for velocity of wind
%
global windv;
global windh;


%
% Simulate launch for wind=0 m/s
%
windh = 0;
windv = 0;
[t0,y0] = ode45(@rocket_ode,[0 20],[0 0 0 0 pi/2 0 0 0]);

%
% Simulate launch for wind=10 m/s
%
windh = 5 ;
windv = 0;
[t1,y1] = ode45(@rocket_ode,[0 20],[0 0 0 0 pi/2 0 2*pi 2*pi]);

% 
% %
% % Simulate launch for wind = 10 m/s
% % Use monte carlo method to analyze the effects of gusts on the apogee of
% % the rocket. Sensitivity analysis can depict how prone the rocket is to
% % wind. We can identify how we can improve on this to minimize the effect
% % of wind on the rocket and maximize apogee. 
% %
montecarloindex = rand(1000,1);
% With the assumption of the rocket being launched in gainesville somewhere
% in the beginnning months of the year.
steadywindh = 5; steadywindv = 0;
maxwind = 10; minwind = 2;
gusthm = 5;
gustvm = 0;
windh = steadywindh + gusthm;
windv = steadywindv + gustvm;
[t2,y2] = ode45(@rocket_ode,[0 20],[0 0 0 0 pi/2 0 2*pi 2*pi]);

%
% Convert altitude/velocity from meters to feet

y0(:,1:4) = y0(:,1:4)/.3048;
y1(:,1:4) = y1(:,1:4)/.3048;
y2(:,1:4) = y2(:,1:4)/.3048;

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
disp(['Apogee with wind v = 0  m/s ',num2str(apogee0),' (ft)']);
disp(['Apogee with wind v = 10 m/s ',num2str(apogee1),' (ft)']);
disp(['Apogee with wind v = 20 m/s ',num2str(apogee2),' (ft)']);

%
% Only take data until apogee
%

[~,ApogeeIndex0] = min(y0(:,2));
y0 = y0(1:ApogeeIndex0,:);
t0 = t0(1:ApogeeIndex0,:);

[~,ApogeeIndex1] = min(y1(:,2));
y1 = y1(1:ApogeeIndex1,:);
t1 = t1(1:ApogeeIndex1,:);

[~,ApogeeIndex2] = min(y2(:,2));
y2 = y2(1:ApogeeIndex2,:);
t2 = t2(1:ApogeeIndex2,:);


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
plot(t0,y0(:,5),'k',t1,y1(:,5),'r',t2,y2(:,5),'b');
xlabel('Time (s)');
ylabel('Pitch Angle (deg)');
legend('no wind','wind v = 10 m/s','wind v = 20 m/s');


%
% Plot trajectory with time
%
figure(3)
plot3(t0,y0(:,1),-y0(:,2),'k',t1,y1(:,1),-y1(:,2),'r',t2,y2(:,1),-y2(:,2),'b');
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