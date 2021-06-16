function ydot = rocket_ode(t,y)
% y = [downrange distance, -altitude, forward velocity, transverse velocity,
%      pitch angle, pitch rate, side range, side velocity, roll angle, roll
%      rate, yaw angle, yaw rate]

% TEST

%
% wind components (m/s)
%
global windh;
global windv;


%
% define constants
%
g = 9.80665;                % gravitational acceleration (m/s^2) (assume constant for all altitudes)
[rho,temp,pressure] = rocket_var_stdatm(-y(2));  % Variable density, temperature, and pressure of air


% IREC rocket properties 
xcp = 2.66;                 % distance from nose to center of pressure (m)
xcg = 2.32;                 % distance from nose to center of gravity (m)
I = 230.499;                % moment of inertia (kg*m^2) (assume constant)
dfus = 0.14;                % diameter of fuselage (m) 
mMinusPropellant = 14.659;  % mass of rocket without propellant (kg)

%
% define fin planform dimensions (m)
%
fin_span  = 0.127;  % fin span (root to tip)
fin_chord = 0.1905; % mean fin chord length

%
% compute reference area for fuselage (m^2)
%
A = pi*(dfus/2)^2;

%
% compute planform area for fin (m^2)
%
S = fin_span * fin_chord;

%
% dryden gust model test
%
dgm_ode = (real(drydengustmodel_v2(-y(2),y(3),y(4),'light')));

%
% compute body-fixed axis velocities (m/s)
%
u = y(3);%forward velocity
w = y(4);%transverse velocity

%
% compute total velocity (m/s)
%
V = sqrt(u^2 + w^2);
V_u_rng = y(7) + windh;
V_v_rng = y(8) + windv;
V_wind = sqrt(V_u_rng^2 + V_v_rng^2);

% compute angle of attack (radians)
% (set angle of attack to pi/2 when forward velocity is 0 to avoid divide-by-zero error);
%
if u ~= 0
    alpha = atan((w + V_wind*sin(y(6)))/(u + V_wind*cos(y(6))));
else
    alpha = pi/2;
end

%
% define coefficients of lift and drag (as function of angle of attack in degrees)
%
CLofus = 0;                     % CLo for fuselage
CLafus = 0;                     % CLalpha for fuselage
CDofus = 0.7;                   % CDo for fuselage
CDafus = 0.1;                   % CDalpha for fuselage

[CLfin, CDfin] = rocket_fin_coefficients(alpha);    % CL and CD for fins

%
% compute lift and drag at this velocity and angle-of-attack
%

%
% compute lift using fin and fuselage aerodynamics
%
L = .5*rho*V^2*(A*(CLofus + CLafus*(alpha*180/pi))  ...
           + S*CLfin);

%
% compute drag using fin and fuselage aerodynamics
%
D = .5*rho*V^2*(A*(CDofus + CDafus*(alpha*180/pi)) ...
           + S*CDfin);

%
% generate the thrust and mass of propellant
%
T  = rocket_thrust(t);
mp = rocket_mass(t);


%
% generate weight
%
m = mp + mMinusPropellant;
W = m*g;

%
% Computing mach number
%
[M,rhom] = rocket_mach_number(V,temp);
% disp(M)
% disp(rhom)

%
% end simulation if rocket has hit ground already
%
if y(2) > 1
    y = y*0;
end

%
% generate state derivatives
%
ydot(1,1) = y(3)*cos(y(5)) + y(4)*sin(y(5)); % Downrange
ydot(2,1) = -y(3)*sin(y(5)) + y(4)*cos(y(5)); % -Altitude
ydot(3,1) = (-W*sin(y(5)) + T + L*sin(alpha) - D*cos(alpha))/m; % Forward velocity
ydot(4,1) = (W*cos(y(5)) - L*cos(alpha) - D*sin(alpha))/m; % Transverse velocity
ydot(5,1) = y(6); % Pitch angle
ydot(6,1) = -(xcp-xcg)*(L*cos(alpha) + D*sin(alpha))/I; % Pitch rate
dgm_ode(isnan(dgm_ode)) = 0;
    if ((dgm_ode(2,1) && dgm_ode(2,2)) ~= 0)
    ydot(7,1) = V_u_rng + (dgm_ode(1,1)/dgm_ode(2,1))*(randn(1,1)/1000) - (1/dgm_ode(2,1))*y(7);
    ydot(8,1) = V_v_rng + (dgm_ode(1,2)/dgm_ode(2,2))*(randn(1,1)/1000) - (1/dgm_ode(2,2))*y(8);
    else
    ydot(7,1) = windh;
    ydot(8,1) = windv;
    end