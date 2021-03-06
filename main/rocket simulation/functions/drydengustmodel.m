% dryden gust model specified for rockets
%
% input = h (altitude)
%         V_u (airspeed of rocket, u-component)
%         V_v (airspeed of rocket, v-component)
%         intensity (turbelence intensity classified as 'light',
%         'moderate', or 'severe')
%
% output = V_wind (gust velocity, assume 1d)

function Vwind = drydengustmodel(h,V_u,V_v,intensity,t)
%
% initializing global variables
%
global i;
global tval;
global v_uoutput;
global v_uoutputd;
global v_vinput;
global v_vinputd;
global v_voutput;
global v_voutputd;
global v_voutputdd;

%
% initialize
%
Vwind_u = 0;
Vwind_v = 0;
tval(i+1) = t;

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

%
% transfer function
%

% intitialzing symbolic variables for inverse laplace transform
% syms s t

% LINEAR u COMPONENT
A = sigma_u*sqrt((2*V_u)/(pi*L_u));
B = V_u/L_u;
Vwind_u = A*exp(-B*t);

% if (V_u ~= 0) && ~isnan(V_u)
%     A = sigma_u*sqrt((2*L_u)/(pi*V_u));
%     if V_u < 10^-5
%         B = 1;
%     else
%         B = L_u/V_u;
%     end
% else
%     V_u = 0;
%     A = 0;
%     B = 1;
% end
% 
% % MATLAB's 'tf' function
% % H_u = tf(A,[B 1]);
% 
% % inverse laplace form 
% % y_u = ilaplace(A/(1+B*s));
% % y_u = real(double(subs(y_u)));
% 
% %
% % solving the transfer function numerically to obtain the filtered wind
% % velocity values (u-component)
% %
% if i == 1 || (V_u < (10^-5))
%     % initial cond for first timestep
%         v_uoutputd(i) = 0;
%         v_uoutput(i) = V_u;
% else
%     % iterate i to integrate the differential equation
%         v_uoutputd(i) = real((A/B)*V_u + ...
%             (1/B)*v_uoutput(i-1)); 
%         v_uoutput(i) = real(v_uoutput(i-1) + ...
%             (tval(i)-tval(i-1))*v_uoutputd(i));    
%         Vwind_u = v_uoutput(i);
% end

% LINEAR v COMPONENT

if (V_v ~= 0) && ~isnan(V_v)    % avoid divide-by-zero
    % dryden transfer function 
    A = sigma_v*sqrt((2*L_v)/(pi*V_v));
    B = 2*sqrt(3)*L_v/V_v;
    % avoid dividing by small value
    if V_v < 10^-5
        C = 1;
    else
        C = (2*L_v/V_v)^2;
    end
    D = (4*L_v)/V_v;
else
    V_v = 0;
    A = 0;
    B = 0;
    C = 1;
    D = 0;
end


% MATLAB's 'tf' function
% H_v = tf([B*A A],[C D 1]);

% inverse laplace form 
% y_v = ilaplace((B*A*s+A)/(C*(s^2)+D*s+1));
% y_v = real(double(subs(y_v)));

%
% solving the transfer function numerically to obtain the filtered wind
% velocity values (v-component)
%
if i == 1 || (V_v < (10^-5))
        v_vinput(i) = 0;
        v_vinput(i+1) = V_v;
        v_vinputd(i) = 0; 
        v_voutputd(i) = 0;
        v_voutput(i) = 0;
        v_voutputd(i) = 0;
        v_voutputdd(i) =(1/C)*( A*v_vinput(i) - v_voutput(i) ...
            - D*v_voutputd(i) - (A*B)*v_vinputd(i));
else
        v_vinput(i) = V_v;
        v_vinputd(i) = (v_vinput(i) - v_vinput(i-1))/(tval(i)-tval(i-1));
        v_voutputd(i) = real(v_voutput(i-1) ...
            + (tval(i)-tval(i-1)*v_voutputdd(i-1)));
        v_voutput(i) = real(v_voutput(i-1) + ...
            (tval(i)-tval(i-1)*v_voutputd(i-1))); 
        v_voutputdd(i) = real((1/C)*( A*v_vinput(i) - v_voutput(i)...
            - D*v_voutputd(i) - (A*B)*v_vinputd(i)));
        Vwind_v = v_voutput(i);
end


% output vector of MATLAB's 'tf' values (requires controls toolbox')
% H = [H_u;H_v;H_w];

% output wind velocity components
Vwind = [Vwind_u;Vwind_v];

% globally iterating i value for timestep alignments in 'numerically
% solving diffeq' section ()
i = i + 1;
