% Wind and gust analysis for the rocket
% WORK IN PROGRESS

% Input: [N] number of simulations
% Output: 

%
% Initializing
%

global windh
global windv

function [windh,windv] = monte_carlo_analysis(Fs,constwindh,constwindv)
rng default
Fs = 1000;
t = 0:1/Fs:1-1/Fs;
windh = constwindh + randn(size(t));
windv = constwindv + randn(size(t)); 

end