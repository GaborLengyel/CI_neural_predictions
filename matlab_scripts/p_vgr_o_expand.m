% g - center relative
function [mu,sig_2,mu_samp]=p_vgr_o_expand(model_params,o_bar_green,o_bar_red,cg,cr,cgr,sgr)

if size(o_bar_green,1)==1 && size(o_bar_red,1)~=1
    o_bar_green=repmat(o_bar_green,size(o_bar_red,1),1);
elseif size(o_bar_green,1)~=1 && size(o_bar_red,1)==1
    o_bar_red=repmat(o_bar_red,size(o_bar_green,1),1);
end
cg=cg(:);
cr=cr(:);
cgr=cgr(:);
sgr=sgr(:);
sz=size(cg);


sig_g_2=model_params(1)*ones(sz);
sig_r_2=model_params(2)*ones(sz);
sig_e_2=model_params(3)*ones(sz);
sig_pg_2=model_params(4)*ones(sz);
sig_pr_2=model_params(5)*ones(sz);
sig_pgr_2=model_params(6)*ones(sz);


log_num=log(sgr)+logsumexp([log(sig_e_2),log(cgr)+log(sig_pgr_2)],2);
g=-1*exp(log_num-logsumexp([log(sig_e_2),log(sig_r_2),log(cr)+log(sig_pr_2),log_num],2));
g=max(min(g,0),-1);
log_sig_4_2=logsumexp([log(sig_e_2),log(sig_g_2),log(cg)+log(sig_pg_2),log(1+g)+log_num],2);
gam_4=exp((log(cg)+log(sig_pg_2))-log_sig_4_2);

mu=(o_bar_green+o_bar_red.*g).*gam_4;
sig_2=cg.*sig_pg_2.*(1-gam_4);

mu_samp=mu+normrnd(0,1,size(mu,1),2).*repmat(sqrt(sig_2),1,2);

% 
% sig_1_2=sig_r_2+sig_g_2+2*sig_e_2;
% gam_1=(sig_r_2+sig_e_2)./sig_1_2;
% 
% if sgr~=0
%     sig_2_2=sig_1_2+(((sig_1_2.*gam_1.*(1-gam_1))+sgr.*(sig_e_2+cgr.*sig_pgr_2))./((1-gam_1).^2));
% 
%     gam_2=exp(logsumexp([(log(sig_1_2)+log(gam_1)+log(1-gam_1));log(sgr)+log(sig_e_2+cgr.*sig_pgr_2)])...
%             -logsumexp([(log(sig_1_2)+log(1-gam_1));log(sgr)+log(sig_e_2+cgr.*sig_pgr_2)]));
% 
%     gam_1_minus_gam_2=-exp((log(sgr)+log(sig_e_2+cgr.*sig_pgr_2)+log(1-gam_1))-(logsumexp([log(sig_1_2)+log(1-gam_1);log(sgr)+log(sig_e_2+cgr.*sig_pgr_2)])));
% 
%     S_gam1_eq_gam2=1;
% else
%     sig_2_2=sig_1_2./(1-gam_1);
%     gam_2=gam_1;
%     gam_1_minus_gam_2=eps;
%     S_gam1_eq_gam2=0;
% end
% 
% sig_3_2=(sig_1_2.*gam_2+cr.*sig_pr_2+sig_2_2.*(gam_1_minus_gam_2.^2)).*((1-gam_1).^2);
% gam_3=(sig_2_2.*((1-gam_1).^2).*((gam_1_minus_gam_2).^2))./(sig_3_2);
% sig_4_2=sig_2_2.*(((1-gam_1).^2).*(1-(S_gam1_eq_gam2.*gam_3)))+cg.*sig_pg_2;
% gam_4=cg.*sig_pg_2./sig_4_2;
% 
% g=-1*((sgr.*(sig_e_2+cgr.*sig_pgr_2))./(sig_e_2+sig_r_2+cr.*sig_pr_2+sgr.*(sig_e_2+cgr.*sig_pgr_2)));
% 
% 
% mi=(cgr.*sig_pgr_2)./(cgr*sig_pgr_2+cr*sig_pr_2+sig_r_2);
% mu=o_bar_green.*gam_4+(o_bar_red.*(1-gam_1).*S_gam1_eq_gam2.*gam_3.*gam_4./gam_1_minus_gam_2);
% sig_2=sig_2_2.*(1-(S_gam1_eq_gam2.*gam_3)).*gam_4.*((1-gam_1).^2);

end 