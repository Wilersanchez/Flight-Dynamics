% Wind and gust profiles for the rocket
% WORK IN PROGRESS

% Input: [N] number of simulations, Turbulence severity [Light,
% Moderate,Severe], 
% Output: 
%



function [V_wind] = gust_profile(Fs,constwindh,constwindv,severity)
%
% INITIALIZING
%
sigma_u = 0;        % Turbulence intensity
L_u = 0;            % Turbulence scale length

%
% COSINE WIND GENERATION
%
n = 10000; 
dt = 0.01;
fs = 1/dt;
tspan = (0:n-1)/fs;
d_m = 2; % meters
V_m = 1 + rand(1,n)*(10);
y = (V_m./2).*(1-cos(pi.*tspan./d_m));
Y = fft(y)/n;
f = (0:n-1)*fs/n;
Y(1) = [];f(1) = [];

%
% TRANSFER FUNCTION
%
A = (2*sqrt(3)/V)*(sigma*sqrt((2*L)/(pi/V)));
B = sigma*sqrt((2*L)/(pi/V));
C = (2*L/V)^2; D = (4*L)/V;

sys = tf([A B],[C D 1]);

%
% TURBULENCE CLASSIFICATION
%
if 'light' == severity; W_20ft = 15; % Knots
elseif 'moderate' == severity; W_20ft = 30; % Knots
elseif 'severe' == severity; W_20ft = 45; % Knots
end


%
% CONDITIONS
%


%
% PROFILES
%


%
% CATEGORIES
%
if h < 1000
    % MIL-HDBK-1797
    L_w = h/2;
    L_u = h/((0.177 + 0.000823*h)^1.2);
    L_v = L_u/2;
    
    sigma_w = 0.1*W_20feet;
    sigma_u = (sigma_w)/((0.177 + 0.000823*h)^0.4);
    sigma_v = sigma_u;
    
elseif 1000 <= h < 2000
    % Values are linearly interpolated
    
elseif 2000 <= h
    % Predetermined values for the dryden form
    L_w = 1750/2;           % [ft]
    L_u = 1750;
    L_v = 1750/2;
    
    sigma_w = 0.1*W_20feet; % Calculated using probability of exceedance
    sigma_u = sigma_w;
    sigma_v = sigma_u;
    
end
end