function y=lognormcdf(x,mu,sig)
t=(x-mu)./sig;
sz=size(t);
t=t(:);
y=zeros(numel(t),1);
y(t<=0)=log(0.5)+log(erfcx(-t(t<=0)/sqrt(2)))-0.5*(t(t<=0)).^2;
y(t>0)=log(0.5)+log(erfc(-t(t>0)/sqrt(2)));
y=reshape(y,sz);
end