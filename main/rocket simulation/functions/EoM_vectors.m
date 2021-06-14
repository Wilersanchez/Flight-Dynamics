% Roll transformation matrix
R1(phi) = [1 0 0;0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];

% Pitch transformation matrix
R2(theta) = [cos(theta) 0 sin(theta); 0 1 0;-sin(theta) 0 cos(theta)];

% Yaw transformation matrix
R3(psi) = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];

% 3-1-3 
p = [u;v;w];
pdot = R3(-psi)*R2(-theta)*R1(-phi)*p;

q = [p;q;r];
qdot = [1 sin(phi)*tan(theta) cos(phi)*tan(theta); 0 cos(phi) -sin(phi); ...
        0 sin(phi)*sec(theta) cos(phi)*sec(theta)];