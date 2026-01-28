% group relative
function [mu,sig_2,mu_samp]=p_vrgr_o_expand(model_params,o_bar_green,o_bar_red,cg,cr,cgr,sgr)

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
log_sig_5_2=logsumexp([log(sig_g_2),log(sig_r_2),log(2)+log(sig_e_2),log(cg)+log(sig_pg_2),log(cr)+log(sig_pr_2)],2);
gam_5=exp(logsumexp([log(sig_r_2),log(sig_e_2),log(cr)+log(sig_pr_2)],2)-log_sig_5_2);
log_sig_6_2=logsumexp([log_sig_5_2+log(gam_5)+log(1-gam_5),log_num],2);
gam_6=exp((log(sgr)+log(cgr)+log(sig_pgr_2))-log_sig_6_2);

% sig_5_2=sig_g_2+sig_r_2+2.*sig_e_2+cg.*sig_pg_2+cr.*sig_pr_2;
% gam_5=(sig_r_2+sig_e_2+cr.*sig_pr_2)./sig_5_2;
% sig_6_2=sig_5_2.*gam_5.*(1-gam_5)+(sig_e_2+cgr.*sig_pgr_2).*sgr;
% gam_6=sgr.*cgr.*sig_pgr_2./sig_6_2;

mu=(o_bar_green.*gam_5+o_bar_red.*(1-gam_5)).*gam_6;
sig_2=cgr.*sig_pgr_2.*(1-sgr.*gam_6);
mu_samp=mu+normrnd(0,1,size(mu,1),2).*repmat(sqrt(sig_2),1,2);
end