% This script is to compare ODE solvers using a simplified physics equation
% that omits certain parameters
clc; clear;

%
% wind components (m/s)
%
global windh;
global windv;
windh = 5;
windv = 0;

[t0,y0] = ode45(@rocket_ode,[0 10],[0 0 0 0 pi/2 0]);
y0(:,1:4) = y0(:,1:4)/.3048;
y0(:,5:6) = y0(:,5:6)*180/pi;
[apogee0,index0] = max(-y0(:,2));
disp(['ode45   Apogee ',num2str(apogee0),' (ft)']);
opts = odeset('stats','on','reltol',1.e-4);
[~,~] = ode113(@rocket_ode,[0 10],[0 0 0 0 pi/2 0],opts);

[t1,y1] = ode23(@rocket_ode,[0 10],[0 0 0 0 pi/2 0]);
y1(:,1:4) = y1(:,1:4)/.3048;
y1(:,5:6) = y1(:,5:6)*180/pi;
[apogee1,index1] = max(-y1(:,2));
disp(['ode23   Apogee ',num2str(apogee1),' (ft)']);
opts = odeset('stats','on','reltol',1.e-4);
[~,~] = ode113(@rocket_ode,[0 10],[0 0 0 0 pi/2 0],opts);

[t2,y2] = ode113(@rocket_ode,[0 10],[0 0 0 0 pi/2 0]);
y2(:,1:4) = y2(:,1:4)/.3048;
y2(:,5:6) = y2(:,5:6)*180/pi;
[apogee2,index2] = max(-y2(:,2));
disp(['ode113  Apogee ',num2str(apogee2),' (ft)']);
opts = odeset('stats','on','reltol',1.e-4);
[~,~] = ode113(@rocket_ode,[0 10],[0 0 0 0 pi/2 0],opts);

[t3,y3] = ode15s(@rocket_ode,[0 10],[0 0 0 0 pi/2 0]);
y3(:,1:4) = y3(:,1:4)/.3048;
y3(:,5:6) = y3(:,5:6)*180/pi;
[apogee3,index3] = max(-y3(:,2));
disp(['ode15s  Apogee ',num2str(apogee3),' (ft)']);
opts = odeset('stats','on','reltol',1.e-4);
[~,~] = ode113(@rocket_ode,[0 10],[0 0 0 0 pi/2 0],opts);

[t4,y4] = ode23s(@rocket_ode,[0 10],[0 0 0 0 pi/2 0]);
y4(:,1:4) = y4(:,1:4)/.3048;
y4(:,5:6) = y4(:,5:6)*180/pi;
[apogee4,index4] = max(-y4(:,2));
disp(['ode23s  Apogee ',num2str(apogee4),' (ft)']);
opts = odeset('stats','on','reltol',1.e-4);
[~,~] = ode113(@rocket_ode,[0 10],[0 0 0 0 pi/2 0],opts);

[t5,y5] = ode23t(@rocket_ode,[0 10],[0 0 0 0 pi/2 0]);
y5(:,1:4) = y5(:,1:4)/.3048;
y5(:,5:6) = y5(:,5:6)*180/pi;
[apogee5,index5] = max(-y5(:,2));
disp(['ode23t  Apogee ',num2str(apogee5),' (ft)']);
opts = odeset('stats','on','reltol',1.e-4);
[~,~] = ode113(@rocket_ode,[0 10],[0 0 0 0 pi/2 0],opts);

[t6,y6] = ode23tb(@rocket_ode,[0 10],[0 0 0 0 pi/2 0]);
y6(:,1:4) = y6(:,1:4)/.3048;
y6(:,5:6) = y6(:,5:6)*180/pi;
[apogee6,index6] = max(-y6(:,2));
disp(['ode23tb Apogee ',num2str(apogee6),' (ft)']);
opts = odeset('stats','on','reltol',1.e-4);
[~,~] = ode113(@rocket_ode,[0 10],[0 0 0 0 pi/2 0],opts);
%
% Plot trajectory
%
figure(1)
plot(y0(:,1),-y0(:,2),'k',y1(:,1),-y1(:,2),'r',y2(:,1),-y2(:,2),'b' ...
    ,y3(:,1),-y3(:,2),'g',y4(:,1),-y4(:,2),'c' ...
    ,y5(:,1),-y5(:,2),'m',y6(:,1),-y6(:,2),'y');
xlabel('Downrange (ft)');
ylabel('Altitude (ft)');
legend('ODE45','ODE23','ODE113','ODE15s','ODE23s','ODE23t','ODE23tb');

%
% Plot velocity
%
figure(2)
plot(t0,y0(:,3),'k',t1,y1(:,3),'r',t2,y2(:,3),'b' ...
    ,y3(:,1),-y3(:,2),'g',y4(:,1),-y4(:,2),'c' ...
    ,y5(:,1),-y5(:,2),'m',y6(:,1),-y6(:,2),'y');
xlabel('Time (s)');
ylabel('Forward Velocity (m/s)');
legend('ODE45','ODE23','ODE113','ODE15s','ODE23s','ODE23t','ODE23tb');