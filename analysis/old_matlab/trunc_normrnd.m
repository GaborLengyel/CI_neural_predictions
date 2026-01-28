function x=trunc_normrnd(mu,sig,a,b,sz)
alp=(a-mu)./sig;
bet=(b-mu)./sig;
x=norminv(normcdf(alp)+rand(sz).*(normcdf(bet)-normcdf(alp)))*sig+mu;
end