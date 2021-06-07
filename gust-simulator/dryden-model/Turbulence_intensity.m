% input = V (airspeed of rocket)
%         T (final time condition)

function [] = Turbulence_intensity(V)
%% Solving for turbulence kinetic energy
uks = var(V(:,1)); %u component of k
vks = var(V(:,2)); %v component of k

k = 1/2*(uks + vks);

Ux = sum(V(:,1))/length(V(:,1));
Uy = sum(V(:,2))/length(V(:,2));
u = sqrt(2/3*k);
U = sqrt(Ux^2 + Uy^2);

I = u/U;
end
