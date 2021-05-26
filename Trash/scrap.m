% scrap
clc;clf
n = 1000; 
dt = 0.01;
fs = 1/dt;
tspan = (0:n-1)/fs;
d_m = 2; % meters
V_m = 2 + rand(1,n)*(3);
y = (V_m./2).*(1-cos(pi.*tspan./d_m));
Y = fft(y)/n;
f = (0:n-1)*fs/n;
Y(1) = [];f(1) = [];
% compute and display the power spectrum
nyquist=fs/2;
f = (1:n/2)/(n/2)*nyquist;
Pyy = abs(Y(1:n/2)).^2;
stem(f,Pyy,'linewidth',2,'MarkerFaceColor','blue')
title('Power spectrum')
xlabel('Frequency (Hz)');ylim([0 0.3])
