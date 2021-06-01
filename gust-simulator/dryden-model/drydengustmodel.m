% dryden gust model specified for rockets
%
% input = dt (sampling time for white noise)
%         c (relative length of rocket dependent on orientation)
%         h (altitude of rocket)
%         V (airspeed of rocket)
%         intensity (turbelence intensity classified as 'light',
%         'moderate', or 'severe')
%
% output = V_gust (gust velocity, assume 1d)


function [] = drydengustmodel(dt,c,h,V,intensity)
%
% constants
%
er = 0.01;  % error variable

%
% conversion
%
m2f = 3.281;    % meters to feet 
kts2mps = 0.5144; % knots to meters per second

%
% intensity classification
%
% W_20ft is the wind speed at 20 feet
if intensity == 'light' 
    W_20ft = 15*kts2mps; 
elseif intensity == 'moderate' 
    W_20ft = 30*kts2mps; 
elseif intensity == 'severe' 
    W_20ft = 45*kts2mps; 
else
    error("Unknown turbulence classification");
end

%
% turbulence parameters
%
% sigma = turbulence intensity
% L = turbulence scale length
%

% For MIL-HDBK-1797 and MIL-HDBK-1797B tables
% LOW ALTITUDE
if (h*m2f) < 1000
    sigma_w = 0.1*W_20feet;
    sigma_u = (sigma_w)/((0.177 + 0.000823*h)^0.4);
    sigma_v = sigma_u;
    
    L_w = h/2;
    L_u = h/((0.177 + 0.000823*h)^1.2);
    L_v = L_u/2;
    
% MED ALTITUDE
elseif 1000*(1-er) < (h*m2f) < 1000*(1+er) 
    sigma_w = 0.1*W_20feet;
    sigma_u = sigma_w;
    sigma_v = sigma_u;
    
    L_w = h/2;
    L_u = h;
    L_v = h/2;
    
% MED TO HIGH ALTITUDE %Figure out interpolation
elseif 1000*(1+er) <= (h*m2f) < 2000
    sigma_w = 0.1*W_20feet;
    sigma_u = sigma_w;
    sigma_v = sigma_u;
    
    L_w = h/2;
    L_u = h;
    L_v = h/2;
    
% HIGH ALTITUDE
elseif 2000 <= (h*m2f)
    sigma_w = 0.1*W_20feet;
    sigma_u = sigma_w;
    sigma_v = sigma_u;
    
    L_w = 1750/2;        
    L_u = 1750;
    L_v = 1750/2;
    
%
% transfer function
%

% LINEAR u COMPONENT

A = sigma_u*sqrt((2*L_u)/(pi*V));
B = L_u/V;

H_u = tf(A,[B 1]);

% LINEAR v COMPONENT
A = sigma_v*sqrt((2*L_v)/(pi*V));
B = 2*sqrt(3)*L_v/V;
C = (2*L_v/V)^2; D = (4*L)/V;

H_v = tf([A B],[C D 1]);

% LINEAR w COMPONENT
A = (2*sqrt(3)/V)*(sigma*sqrt((2*L)/(pi/V)));
B = sigma*sqrt((2*L)/(pi/V));
C = (2*L/V)^2; D = (4*L)/V;

H_u = tf([A B],[C D 1]);
end