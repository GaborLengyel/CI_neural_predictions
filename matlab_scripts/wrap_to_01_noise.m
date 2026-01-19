function x=wrap_to_01_noise(x,mu,sig)
if numel(mu)==1 && numel(x)>1
    mu=mu*ones(size(x));
end
id=x>1;
x(id)=trunc_normcdf(x(id),mu(id),sig,1,Inf);
id=x<0;
x(id)=trunc_normcdf(x(id),mu(id),sig,-Inf,0);
end