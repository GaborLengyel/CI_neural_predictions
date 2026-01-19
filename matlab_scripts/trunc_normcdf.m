function y=trunc_normcdf(x,mu,sig,a,b)
alp=(a-mu)./sig;
bet=(b-mu)./sig;
x1=(x-mu)./sig;
z=normcdf(bet)-normcdf(alp);
y=(normcdf(x1)-normcdf(alp))./z;
end