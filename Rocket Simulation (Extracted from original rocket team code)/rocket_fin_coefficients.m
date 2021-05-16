function [CLfin,CDfin] = rocket_fin_coefficients(alpha)

%
% Data for angle of attack (rad) and coefficients
%
global alphadata;
global CLfindata1;
global CLfindata2;
global CDfindata;

%
% Interpolate data to estimate coefficients at any angle of attack
%
if alpha <= max(alphadata) && alpha >= min(alphadata)
    CLfin  = interp1(alphadata,CLfindata1,alpha);
else
    CLfin  = 0;
end
CDfin  = interp1(CLfindata2,CDfindata,CLfin);