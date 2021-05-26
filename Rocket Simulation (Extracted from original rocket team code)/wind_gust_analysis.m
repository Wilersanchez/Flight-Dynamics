% Wind and gust analysis for the rocket
% WORK IN PROGRESS

% Input: [N] number of simulations
% Output: 

%
% Initializing
%

global windh
global windv

function [V_wind] = gust_profile(Fs,constwindh,constwindv)
%
% INITIALIZING
%
sigma_u = 0;
L_u = 0;



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
    L_w = 1750/2;
    L_u = 1750;
    L_v = 1750/2;
end