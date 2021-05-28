function [mP] = rocket_mass(t)

%
% Data for time (s) and propellant mass (kg)
%
global tdata;
global mdata;
mdata = mdata/1000;


%
% Interpolate data to estimate propellant mass at any time
%
if t <= max(tdata)
    mP = interp1(tdata,mdata,t);
else
    mP = 0;
end