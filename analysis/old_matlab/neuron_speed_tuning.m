% Gamma prob density function used in DeAngelis & Uka (2003)

function r = neuron_speed_tuning(x, R0, A, alpha, tau, n)

%     r = R0 + A .* ((alpha.*(x - tau)).^n .* exp(-alpha.*(x - tau)))./(n.^n .* exp(-n));
      r = (1/A).*(R0*0 + A .* ((alpha.*(x - tau)).^n .* exp(-alpha.*(x - tau)))./(n.^n .* exp(-n)));
      
end