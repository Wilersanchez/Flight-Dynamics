% dryden gust model specified for rockets
%
% input = h (altitude)
%         V_u (airspeed of rocket, u-component)
%         V_v (airspeed of rocket, v-component)
%         intensity (turbelence intensity classified as 'light',
%         'moderate', or 'severe')
%
% output = V_wind (gust velocity, assume 1d)

function dgm_ode = drydengustmodel_v2(h,V_u,V_v,intensity)

%
% conversion
%
m2f = 3.281;    % meters to feet 
kts2mps = 0.5144; % knots to meters per second

%
% intensity classification
%

light = 'light';
moderate = 'moderate';
severe = 'severe';

if strcmp(light,intensity)
    W_20ft = 15*kts2mps; % W_20ft is the wind speed at 20 feet
elseif strcmp(moderate,intensity)
    W_20ft = 30*kts2mps; 
elseif strcmp(severe,intensity)
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

if h ~= 0
  
% LOW ALTITUDE
    if (h*m2f) < 1000
    sigma_w = 0.1*W_20ft;
    sigma_u = (sigma_w)/((0.177 + 0.000823*h)^0.4);
    sigma_v = sigma_u;
    
    %    L_w = h/2;
    L_u = h/((0.177 + 0.000823*h)^1.2);
    L_v = L_u/2;
    
    % MED TO HIGH ALTITUDE
    elseif 1000 <= (h*m2f) < 2000
    sigma_w = 0.1*W_20ft;
    sigma_u = sigma_w;
    sigma_v = sigma_u;
    
    %    L_w = h/2;
    L_u = h;
    L_v = h/2;
    
    % HIGH ALTITUDE
    elseif 2000 <= (h*m2f)
    sigma_w = 0.1*W_20ft;
    sigma_u = sigma_w;
    sigma_v = sigma_u;
    
    %    L_w = 1750/2;        
    L_u = 1750;
    L_v = 1750/2;
    end   

    % LINEAR u COMPONENT
    A = [sigma_u*sqrt((2*L_u/pi/V_u)); L_u/V_u; 0; 0];
    % LINEAR v COMPONENT
    B = [sigma_v*sqrt((2*L_v/pi/V_v)); 2*sqrt(3)*(L_v/V_v); (2*L_v/V_v)^2; (4*L_v)/V_v];
else
    A = [0;0;0;0];
    B = [0;0;0;0];
end
dgm_ode = [A B];
end