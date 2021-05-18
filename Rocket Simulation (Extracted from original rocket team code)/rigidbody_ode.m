function ydot = rigidbody_ode(t,y)
% Add launch rail to launch rocket from 0 to 180 degrees
% y = [downrange distance, -altitude, forward velocity, transverse
% velocity, side velocity, side range, pitch angle, pitch rate, roll angle,
% roll rate, yaw angle, yaw rate]

%
% wind components (m/s)
%
global windh;
global windv;
%
% define constants
%
g = 9.80665;                % gravitational acceleration (m/s^2) (assume constant for all altitudes)
rho = 1.225;
xcp = 2.5;                  % distance from nose to center of pressure (m)
xcg = 2.2;                  % distance from nose to center of gravity (m)
I = 20;                     % moment of inertia (kg*m^2) (assume constant)
dfus = .2;                  % diameter of fuselage (m) 
mp = 15;                    % mass of rocket without propellant (kg)

A = pi*(dfus/2)^2;

u = y(3) + windh*cos(y(5)) + windv*sin(y(5)); %forward velocity
w = y(4) + windh*sin(y(5)) + windv*cos(y(5)); %transverse velocity
V = sqrt(u.^2 + w.^2);

if u ~= 0
    alpha = atan(w/u);
else
    alpha = pi/2;
end

CLofus = 0;                     % CLo for fuselage
CLafus = 0;                     % CLalpha for fuselage
CDofus = 0.7;                   % CDo for fuselage
CDafus = 0.1;                   % CDalpha for fuselage


L = .5*rho*V^2*(A*(CLofus + CLafus*(alpha*180/pi)));
D = .5*rho*V^2*(A*(CDofus + CDafus*(alpha*180/pi)));
T = rocket_thrust(t);
m = rocket_mass(t) + mp;
W = m*g;

if y(2) > 1
    y = y*0;
end

ydot(1,1) = y(3)*cos(y(5)) + y(4)*sin(y(5));
ydot(2,1) = -y(3)*sin(y(5)) + y(4)*cos(y(5));
ydot(3,1) = (-W*sin(y(5)) + T + L*sin(alpha) - D*cos(alpha))/m;
ydot(4,1) = (W*cos(y(5)) - L*cos(alpha) - D*sin(alpha))/m;
ydot(5,1) = y(6);
ydot(6,1) = -(xcp-xcg)*(L*cos(alpha) + D*sin(alpha))/I;