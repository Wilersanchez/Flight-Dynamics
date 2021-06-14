clc; clear;
omega = 20;        % circular frequency
tspan = [0 10];

sigma = .3;        % turbulence intensity

Lu = 1;            % turbulence scale length

V = 100;           % velocity

A = sigma*sqrt(2*Lu/pi/V);

B = Lu/V;


gustode =@(t,y)  (A/B)*randn(1,1) - (1/B)*y;


[tgust,ygust] = ode45(gustode,tspan,0);

plot(tgust,ygust)