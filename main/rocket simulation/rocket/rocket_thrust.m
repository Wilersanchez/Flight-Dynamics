function [T] = rocket_thrust(t)

%
% Data for time (s) and thrust (N)
%
global simproperties;
tdata = simproperties(:,2);
Tdata = simproperties(:,4);

%
% Interpolate data to estimate thrust at any time
%
if t <= max(tdata)
    T  = interp1(tdata,Tdata,t);
else
    T  = 0;
end