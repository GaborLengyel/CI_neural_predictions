function [prs,sts]=p_struct_expand(model_params,o_bar_green,o_bar_red)
%Order Cg,Cr,Cgr,Sgr


if size(o_bar_green,1)==1 && size(o_bar_red,1)~=1
    o_bar_green=repmat(o_bar_green,size(o_bar_red,1),1);
elseif size(o_bar_green,1)~=1 && size(o_bar_red,1)==1
    o_bar_red=repmat(o_bar_red,size(o_bar_green,1),1);
end



alp_cg=model_params(7);
alp_cr=model_params(8);
alp_cgr=model_params(9);
bet_gr=model_params(10);


for i=1:4
    st_arr{i}=[0,1];
end
sts=cartprod_cell(st_arr);


cg=sts(:,1)';
cr=sts(:,2)';
cgr=sts(:,3)';
sgr=sts(:,4)';


t1=log(alp_cg.*(1-cg)+(1-alp_cg).*(cg));
t2=log(alp_cr.*(1-cr)+(1-alp_cr).*(cr));
t3=log(alp_cgr.*(1-cgr)+(1-alp_cgr).*(cgr));
t4=log(bet_gr.*(sgr)+(1-bet_gr).*(1-sgr));


lp=t1+t2+t3+t4;
sts(isinf(lp(:)),:)=[];
lp(isinf(lp))=[];
lp=lp-logsumexp(lp,2);


lprs=zeros(size(o_bar_green,1),size(sts,1));
cg=sts(:,1)';
cr=sts(:,2)';
cgr=sts(:,3)';
sgr=sts(:,4)';

% sig_5_2=sig_g_2+sig_r_2+2.*sig_e_2+cg.*sig_pg_2+cr.*sig_pr_2;
% gam_5=(sig_r_2+sig_e_2+cr.*sig_pr_2)./sig_5_2;
% sig_6_2=sig_5_2.*gam_5.*(1-gam_5)+(sig_e_2+cgr.*sig_pgr_2).*sgr;



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
sig_5_2=exp(log_sig_5_2);
gam_5=exp(logsumexp([log(sig_r_2),log(sig_e_2),log(cr)+log(sig_pr_2)],2)-log_sig_5_2);
sig_6_2=exp(logsumexp([log_sig_5_2+log(gam_5)+log(1-gam_5),log_num],2));
sig_5_2=sig_5_2(:)';
sig_6_2=sig_6_2(:)';
gam_5=gam_5(:)';


o_bar_red=repmat(reshape(o_bar_red,[size(lprs,1),1,2]),[1,size(lprs,2),1]);
o_bar_green=repmat(reshape(o_bar_green,[size(lprs,1),1,2]),[1,size(lprs,2),1]);
sig_5_2=repmat((sig_5_2),[size(lprs,1),1,2]);
sig_6_2=repmat((sig_6_2),[size(lprs,1),1,2]);
gam_5=repmat(gam_5,[size(lprs,1),1,2]);


lprs=sum(lognormpdf(o_bar_red-o_bar_green,zeros([size(lprs),2]),sqrt(sig_5_2)),3)+...
    sum(lognormpdf(o_bar_red.*(1-gam_5)+o_bar_green.*gam_5,zeros([size(lprs),2]),sqrt(sig_6_2)),3)...
    +repmat(lp,size(lprs,1),1);

prs=exp(lprs-logsumexp(lprs,2));

end