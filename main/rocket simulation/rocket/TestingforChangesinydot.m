clc;clear;
t0 = 0;
tf = 15;
nsteps = 1000;
tspan = linspace(t0,tf,nsteps);
y = [1 1 1 1 pi/2 1 1];
windh = 9;
a = -2;
b = 2;
r = (a+(b-a)*randn(1,1));


V_u_rng = y(7) + windh;
dgm_ode = (real(drydengustmodel_v2(-y(2),y(3),y(4),'moderate')));

ydot(7,1) = V_u_rng + (((dgm_ode(1,1))*r-y(7)))/(dgm_ode(2,1)*1000);