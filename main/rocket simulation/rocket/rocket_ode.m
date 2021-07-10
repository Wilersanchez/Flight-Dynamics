function ydot = rocket_ode(t,y)
%OUTPUT: [downrange distance(u),-altitude, forward velocity, transverse
%         velocity, pitch angle, pitch rate, forward dyrden gust velocity]


%% define constants
%
g = 9.80665;                % gravitational acceleration (m/s^2) (assume constant for all altitudes)
[rho,temp,pressure] = rocket_var_stdatm(-y(2));  % Variable density, temperature, and pressure of air

%% IREC rocket properties 
xcp = 2.46;                 % distance from nose to center of pressure (m)
xcg = 2.00;                 % distance from nose to center of gravity (m)
I = 348.2;                  % moment of inertia (kg*m^2) (assume constant)
dfus = 0.157;               % diameter of fuselage (m) 

% mass of rocket segmented by seperate body tubes 
m_avbaycoupler = 750; m_avionics = 1991; m_nosecone = 2495;
m_(1) = m_avbaycoupler + m_avionics + m_nosecone;

m_avbayswitchband = 71.1;
m_(2) = m_avbayswitchband;

m_upperbodytube = 1422; m_avbaybulkhead = 161; m_shockcord = 794; 
m_96main = 473; m_36drogue = 204;
m_(3) =  m_upperbodytube + m_avbaybulkhead + m_shockcord + m_96main + ...
    + m_36drogue;

m_bodytube1 = 49.3;
m_(4) = m_bodytube1;

m_bodytube2 = 690; m_payloadcoupler = 875; m_payload = 4001; 
m_bulkhead = 161;
m_(5) = m_bodytube2 + m_payloadcoupler +  m_payload + m_bulkhead*2;

m_bodytube3 = 49.3;
m_(6) = m_bodytube3;

m_aftbodytube = 2069; m_activecontrolcoupl = 875; m_activebulkhead = 161; 
m_activecontrol = 1787; m_motortube = 902; m_ring = 177; m_fins = 1820; 
m_cring = 229;
m_(7) = m_aftbodytube + m_activecontrolcoupl + m_activebulkhead*2 ...
    + m_activecontrol + m_motortube + m_ring*3 + m_fins + m_cring;

m_rocket = sum(m_(1:7))/1000; % mass of rocket without propellant (kg)

%% compute reference area for fuselage (m^2)
A = pi*(dfus/2)^2;

%% define fin planform dimensions (m)
ct = 0.406;   % fin root to tip
cr = 0.152;   % fin tip

%% compute planform area for fin (m^2)
S = pi * ct * cr;

%% dryden gust model test
dgm_ode = (real(drydengustmodel_v2(-y(2),y(3),y(4),'moderate')));

%% compute body-fixed axis velocities (m/s)
u = y(3) + y(7)*10000; %forward velocity
w = y(4);       %transverse velocity

%% compute total velocity (m/s)
V = sqrt(u^2 + w^2);

%% compute angle of attack (radians)
% (set angle of attack to pi/2 when forward velocity is 0 to avoid divide-by-zero error);
if u ~= 0
     alpha = atan((w)/(u));
else
     alpha = pi/2;
end

%% define coefficients of lift and drag (as function of angle of attack in degrees)
CLofus = 0;                     % CLo for fuselage
CLafus = 0;                     % CLalpha for fuselage
CDofus = 0.7;                   % CDo for fuselage
CDafus = 0.1;                   % CDalpha for fuselage

[CLfin, CDfin] = rocket_fin_coefficients(alpha);    % CL and CD for fins

%% compute lift using fin and fuselage aerodynamics
L = .5*rho*V^2*(A*(CLofus + CLafus*(alpha*180/pi))  ...
           + S*CLfin);

%% compute drag using fin and fuselage aerodynamics
D = .5*rho*V^2*(A*(CDofus + CDafus*(alpha*180/pi)) ...
           + S*CDfin);

%% generate the thrust and mass of propellant
T  = rocket_thrust(t);
m_motorpropellent = rocket_mass(t);

%% generate weight
m = m_motorpropellent + m_rocket;
W = m*g;

%% Computing mach number
[M,rhom] = rocket_mach_number(V,temp);
% disp(M)
% disp(rhom)

%% end simulation if rocket has hit ground already
if y(2) > 1
    y = y*0;
end

%% generate limited bandwidth noise
a = -2;
b = 2;
r = (b-a)*rand(1,1)+a;

%% generate state derivatives
ydot(1,1) = y(3)*cos(y(5)) + y(4)*sin(y(5));                        % Downrange
ydot(2,1) = -y(3)*sin(y(5)) + y(4)*cos(y(5));                       % -Altitude
ydot(3,1) = (-W*sin(y(5)) + T + L*sin(alpha) - D*cos(alpha))/m;     % Forward velocity
ydot(4,1) = (W*cos(y(5)) - L*cos(alpha) - D*sin(alpha))/m;          % Transverse velocity
ydot(5,1) = y(6);                                                   % Pitch angle
ydot(6,1) = -(xcp-xcg)*(L*cos(alpha) + D*sin(alpha))/I;             % Pitch rate
dgm_ode(isnan(dgm_ode)) = 0;                                        % Gust
    if (dgm_ode(2,1) ~= 0)
    ydot(7,1) =(((dgm_ode(1,1))*r-y(7)))/(dgm_ode(2,1)*1000);
    else
    ydot(7,1) = 0;
    end