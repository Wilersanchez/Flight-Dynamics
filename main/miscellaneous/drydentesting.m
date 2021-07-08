%GUST_ODE
clc; clear;
t0 = 0;
tf = 15;
nsteps = 1000;
tspan = linspace(t0,tf,nsteps);

global h;
global u;
global w;
h = linspace(0,1500,nsteps);
u = linspace(0,100,nsteps);
w = linspace(0,100,nsteps);
[t,y] = ode45(@gust_ode,tspan,0);

function ydot = gust_ode(t,y)
global h;
global u;
global w;
%% generate limited bandwidth noise
a = -2;
b = 2;
r = (b-a)*rand(1,1)+a;
%% dryden gust model test
dgm_ode = (real(drydengustmodel_v2(h,u,w,'moderate')));
%% state derivative
ydot(1,1) = (((dgm_ode(1,1))*r-y(1)))/(dgm_ode(2,1));
end