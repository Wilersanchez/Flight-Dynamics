% This a function that introduces variability in the density as the rocket
% travels upward

% INPUT: h altitude (m)
% OUTPUT: rho density (kg/m^3), T temperature (K), and P pressure (Pa)

function [rhof,Tf,Pf] = rocket_var_stdatm(h)
%
% Defining Constants
%
h_atm = [10999 19999 32000 46999 50999 70999 85000]; % Altitude for each region
a = [-.0065 0 .001 .0028 0 -.0028 -.002]; % Lapse rate for each region [K/m]
g = 9.807;          % Gravitational acceleration [m/s^2]
rho0 = 1.225;       % Density at sea level [kg/m^3]
T0 = 288.15;        % Temperature at sea level [K]
a0 = -.0065;        % Initial lapse rate from sea level [K/m]
P0 = 101325;        % Pressure at sea level [Pa]
R = 287.057;        % Gas constant of air [J/(kg*K)]

T = 1:7;        % Initializing
T(1) = T0 + (a0*(h_atm(1)));
T(2) = T(1);
T(3) = T(2) + a(3)*((h_atm(3)-h_atm(2)));
T(4) = T(3) + a(4)*((h_atm(4)-h_atm(3)));
T(5) = T(4) + a(5)*(h_atm(5));
T(6) = T(5) + a(6)*((h_atm(6)-h_atm(5)));
T(7) = T(6) + a(7)*((h_atm(7)-h_atm(6)));

rho = 1:7;      % Initializing
rho(1) = rho0*((T(1)/T0)^((-g/(a0*R))-1));
rho(2) = rho(1)*exp((-g/(R*T(2)))*((h_atm(2)-h_atm(1)))); 
rho(3) = rho(2)*((T(3)/T(2))^(((-g/(a(3)*R))-1)));
rho(4) = rho(3)*((T(4)/T(3))^(((-g/(a(4)*R))-1)));
rho(5) = rho(4)*exp((-g/(R*T(5)))*((h_atm(5)-h_atm(4))));
rho(6) = rho(5)*((T(6)/T(5))^(((-g/(a(5)*R))-1)));
rho(7) = rho(6)*((T(7)/T(6))^(((-g/(a(6)*R))-1)));

P = 1:7;        % Initializing
P(1) = P0*((T(1)/T0)^((-g/(a0*R))-1));
P(2) = P(1)*exp((-g/(R*T(2)))*((h_atm(2)-h_atm(1))));
P(3) = P(2)*((T(3)/T(2)))^(((-g/(a(3)*R))-1));
P(4) = P(3)*((T(4)/T(3)))^(((-g/(a(4)*R))-1));
P(5) = P(4)*exp((-g/(R*T(5)))*((h_atm(5)-h_atm(4))));
P(6) = P(5)*((T(6)/T(5))^(((-g/(a(5)*R))-1)));
P(7) = P(6)*((T(7)/T(6))^(((-g/(a(6)*R))-1)));

% 
% Altitude regions
% Using the U.S. Standard Atmosphere Lapse Rates 
% https://www.tau.ac.il/~tsirel/dump/Static/knowino.org/wiki/Atmospheric_lapse_rate.html
% NOTE: The IREC Rocket only flies within the troposphere region, all other
% atmospheric regions are negligible unless dealing with higher altitude
% flight
%

if h <= h_atm(1)
    i = 1;    
    Tf = T0 + a(i)*h;
    rhof = rho0*((Tf/T0)^((-g/(a0*R))-1));
    Pf = P0*((Tf/T0)^((-g/(a0*R))-1));
    
elseif h_atm(1) < h <= h_atm(2)
    i = 2; 
    Tf = T(i-1) + a(i)*(h - h_atm(i-1));
    rhof = rho(i-1)*exp((-g/(R*Tf))*((h_atm(i-1)-h_atm(i)))); 
    Pf = P(i-1)*exp((-g/(R*Tf))*((h_atm(i)-h_atm(i-1))));
    
elseif h_atm(2) < h <= h_atm(3) 
    i = 3; 
    Tf = T(i-1) + a(i)*(h - h_atm(i-1));
    rhof = rho(i-1)*(Tf/T(i-1))^((-g/(a(i-1)*R))-1);
    Pf = P(i-1)*((Tf/T(i-1)))^(((-g/(a(i-1)*R))-1));
    
elseif  h_atm(3) < h <= h_atm(4)
    i = 4; 
    Tf = T(i-1) + a(i)*(h - h_atm(i-1)); 
    rhof = rho(i-1)*(Tf/T(i-1))^((-g/(a(i-1)*R))-1);
    Pf = P(i-1)*((Tf/T(i-1)))^(((-g/(a(i-1)*R))-1));
    
elseif h_atm(4) < h <= h_atm(5)
    i = 5; 
    Tf = T(i-1) + a(i)*(h - h_atm(i-1));
    rhof = rho(i-1)*exp((-g/(R*Tf))*((h_atm(i-1)-h_atm(i)))); 
    Pf = P(i-1)*exp((-g/(R*Tf))*((h_atm(i)-h_atm(i-1))));
    
elseif h_atm(5) < h <= h_atm(6)
    i = 6; 
    Tf = T(i-1) + a(i)*(h - h_atm(i-1));  
    rhof = rho(i-1)*(Tf/T(i-1))^((-g/(a(i-1)*R))-1); 
    Pf = P(i-1)*((Tf/T(i-1)))^(((-g/(a(i-1)*R))-1));  
    
elseif h_atm(6) < h <= h_atm(7)
    i = 7; 
    Tf = T(i-1) + a(i)*(h - h_atm(i-1)); 
    rhof = rho(i-1)*(Tf/T(i-1))^((-g/(a(i-1)*R))-1); 
    Pf = P(i-1)*((Tf/T(i-1)))^(((-g/(a(i-1)*R))-1));
    
end    
end
