
h = 100;
V = 100;
intensity = 'light';
dt = 0.01;
t = 0:dt:10;
u = ones(size(t));
u(1) = 0;
%
% initialize
%
W_20ft = 0;

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
light = 'light';
moderate = 'moderate';
severe = 'severe';

if strcmp(light,intensity)
    W_20ft = 15*kts2mps; 
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
    
    L_w = h/2;
    L_u = h/((0.177 + 0.000823*h)^1.2);
    L_v = L_u/2;
    
% MED ALTITUDE
elseif 1000*(1-er) < (h*m2f) < 1000*(1+er) 
    sigma_w = 0.1*W_20ft;
    sigma_u = sigma_w;
    sigma_v = sigma_u;
    
    L_w = h/2;
    L_u = h;
    L_v = h/2;
    
% MED TO HIGH ALTITUDE
elseif 1000*(1+er) <= (h*m2f) < 2000
    sigma_w = 0.1*W_20ft;
    sigma_u = sigma_w;
    sigma_v = sigma_u;
    
    L_w = h/2;
    L_u = h;
    L_v = h/2;
    
% HIGH ALTITUDE
elseif 2000 <= (h*m2f)
    sigma_w = 0.1*W_20ft;
    sigma_u = sigma_w;
    sigma_v = sigma_u;
    
    L_w = 1750/2;        
    L_u = 1750;
    L_v = 1750/2;
end   
%
% transfer function
%
syms s 

% LINEAR u COMPONENT

A = sigma_u*sqrt((2*L_u)/(pi*V));
B = L_u/V;

H_u = tf(A,[B 1]);
y_u = ilaplace(A/(1+B*s));
y_u = subs(t);
double y_u

% LINEAR v COMPONENT
A = sigma_v*sqrt((2*L_v)/(pi*V));
B = 2*sqrt(3)*L_v/V;
C = (2*L_v/V)^2; D = (4*L_v)/V;

H_v = tf([B*A A],[C D 1]);
y_v = ilaplace((B*A*s+A)/(C*(s^2)+D*s+1));
y_v = subs(t);
double y_v

% LINEAR w COMPONENT
A = sigma_w*sqrt((2*L_w)/(pi*V));
B = 2*sqrt(3)*L_w/V;
C = (2*L_w/V)^2; D = (4*L_w)/V;

H_w = tf([A B],[C D 1]);
y_w = ilaplace((A*s+B)/(C*(s^2)+B*s+1));
y_w = subs(t);
double y_w


Vwind = [y_u;y_v;y_w];
t1 = linspace(0,10,length(Vwind(:,1)));
t2 = linspace(0,10,length(Vwind(:,2)));
t3 = linspace(0,10,length(Vwind(:,3)));

figure(1)
plot(t1,Vwind(:,1),'Linewidth',2);
grid
legend('Velocity of wind in u-component')
xlabel('time [seconds]'); ylabel('Velocity [m/s]');
figure(2)
plot(t2,Vwind(:,2),'Linewidth',2);
grid
legend('Velocity of wind in v-component')
xlabel('time [seconds]'); ylabel('Velocity [m/s]');
figure(3)
plot(t3,Vwind(:,3),'Linewidth',2);
grid
legend('Velocity of wind in w-component')
xlabel('time [seconds]'); ylabel('Velocity [m/s]');