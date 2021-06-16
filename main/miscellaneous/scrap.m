% scrap
clc;clf
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

% compute and display the power spectrum
nyquist=fs/2;
f = (1:n/2)/(n/2)*nyquist;
Pyy = abs(Y(1:n/2)).^2;
figure(1)
stem(f,Pyy,'linewidth',2,'MarkerFaceColor','blue')
title('Power spectrum')
xlabel('Frequency (Hz)');ylim([0 0.3])

figure(2)
plot(tspan,y)

%
LINEAR w COMPONENT
A = sigma_w*sqrt((2*L_w)/(pi*V));
B = 2*sqrt(3)*L_w/V;
C = (2*L_w/V)^2; D = (4*L_w)/V;

H_w = tf([A B],[C D 1]);


% % checks whether the velocities are NaN or zero and sets them equal to
% % themselves. subject to change.
% if isnan(V_u) || isnan(V_v)
%     V_u = 0;
%     V_v = 0;
% else
y_w = ilaplace((A*s+B)/(C*(s^2)+B*s+1));
y_w = real(double(subs(y_w)));

