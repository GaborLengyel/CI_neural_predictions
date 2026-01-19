
% Von Misses Distribution

function resp = neuron_dir_VonMisses_tuning(x,R0, A, mu, kappa)
    
%     resp = R0 + A.*exp(kappa.*(cos((x - mu)./180*pi) - 1*1));
    resp =  (1/A).*(R0*0 + A.*exp( kappa .* (cos( ((x-mu)./180)*pi ) -1*1 ) ));



end