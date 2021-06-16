function [M,rhof] = rocket_mach_number(V,T)
%
% Defining constants
%
R = 287.057;            % Gas constant of air [J/(kg*K)]
gamma = 1.4;            % Specific heat ratio of air for standard day conditions
a = sqrt(gamma*R*T);    % Speed of sound [m/s]
M = V/a;                % Mach number

if M < .999    % Subsonic flow
rhof = exp((-M^2)*(log(V)));

elseif .999 <= M <= 1.001   % Transonic flow
rhof = exp((-M^2)*(log(V)));

elseif 1.001 < M    % Supersonic flow
rhof = exp((-M^2)*(log(V)));

end
