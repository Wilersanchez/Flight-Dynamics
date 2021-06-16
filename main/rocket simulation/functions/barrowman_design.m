function xcp = barrowman_design(Ln,d,dF,dR,Lt,Xp,Cr,Ct,S,Lf,R,Xr,Xb,N,CN_N,nose_type,no_transition)
% 
% Barrowman variables
% http://www.rocketmime.com/rockets/Barrowman.html
% 
% (Ln) Length of Nose
% (d)  Diameter at base of nose
% (dF) Diameter at front of transition
% (dR) Diameter at rear of transition
% (Lt) Length of transition
% (Xp) Distance from tip of nose to front of transition
% (Cr) Fin root chord
% (Ct) Fin tip chord
% (S)  Fin semispan
% (Lf) Length of fin mid-chord line
% (R)  Radius of body at aft end
% (Xr) Distance between fin root leading edge and fin tip 
%      leading edge parallel to body
% (Xb) Distance from nose tip to fin root chord leading edge
% (N)  Number of fins
% (nose_cone) Cone = 1 , Ogive = 2
% (no_transition) true = 1 , false = 0

%
% equations
%

CN_T = 2*(((dR/d)^2)-((dF/d)^2));
X_T = Xp + (Lt/3)*(1 + (1-(dF/dR))/(1-((dF/dR)^2)));
CN_F = ((1 + (R/(S + R)))*((4*N*((S/d)^2))/(1+sqrt(1+(((2*Lf)/((Cr+Ct)))^2)))));
X_F = Xb + (Xr/3)*((Cr + 2*Ct)/(Cr + Ct)) + (1/6)*((Cr + Ct) - (Cr*Ct)/ ...
    (Cr + Ct));
CN_R = CN_F + CN_N;
if nose_type == 1
    X_N = 0.666*Ln; 
elseif nose_type == 2 
    X_N = 0.466*Ln;
else
    X_N = .5*Ln; 
end

if no_transition == 1
    X_T = 0;
else
end
xcp = (CN_N*X_N + CN_T*X_T + CN_F*X_F)/CN_R;
end