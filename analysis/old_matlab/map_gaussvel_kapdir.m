function [thets1,kaps1]=map_gaussvel_kapdir(mus,sigs)

nus=sqrt(sum(mus.^2,2));
mus=mus./nus;
sigs=sigs./nus;

thets1=atan2(mus(:,2),mus(:,1));


load('std_kap','stds','kaps','beta_stds_greater_than_2','beta_stds_less_than_0p5');

sigs=sigs(:);
kaps1=nan(size(sigs));
ids=sigs>2;
if sum(ids)>0
xs=[ones(sum(ids),1),log(sigs(ids))];
kaps1(ids)=exp(xs*beta_stds_greater_than_2);
end
ids=sigs<0.5;
if sum(ids)>0
xs=[ones(sum(ids),1),log(sigs(ids))];
kaps1(ids)=exp(xs*beta_stds_less_than_0p5);
end
ids=sigs>=0.5 & sigs <=2;
if sum(ids)>0
kaps1(ids)=exp(interp1(log(stds'),log(kaps'),log(sigs(ids))));
end

end