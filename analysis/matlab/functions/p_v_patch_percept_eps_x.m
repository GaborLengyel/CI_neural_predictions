function [v_target_retina,...
    v_target_relative,...
    v_group_relative,...
    v_target_percept] = p_v_patch_percept_eps_x(eps_target,eps_surround,model_params,n_trials,causalStruct)


% model_params=[sig_g_2,sig_r_2,sig_e_2,sig_pg_2,sig_pr_2,sig_pgr_2,alp,beta_gr];



sig_target_2=model_params(1);
sig_surround_2=model_params(2);
sig_delta_2=model_params(3);
sig_prior_target_2=model_params(4);
sig_prior_surround_2=model_params(5);
sig_prior_group_2=model_params(6);
alpha_target=model_params(7);
alpha_surround=model_params(8);
alpha_group=model_params(9);
beta_group=model_params(10);

model_params=[sig_target_2,sig_surround_2,sig_delta_2,sig_prior_target_2,sig_prior_surround_2,sig_prior_group_2,alpha_target,alpha_surround,alpha_group,beta_group];

o_target=repmat(eps_target,n_trials,1)+normrnd(0,sqrt(sig_target_2),n_trials,2);
o_surround=repmat(eps_surround,n_trials,1)+normrnd(0,sqrt(sig_surround_2),n_trials,2);

% prs - prob of those struct 16x1 dim vec
% sts identity of the struct; binary vec d=4, but 16 diff struct in 16 rows
[~,sts]=p_struct_expand(model_params,o_target,o_surround);
v = zeros(1,16);
if causalStruct==1
    v(13) = 1;
    prs=repmat(v,n_trials,1);
elseif causalStruct==2
    v(14) = 1;
    prs=repmat(v,n_trials,1);
elseif causalStruct==3
    v(15) = 1;
    prs=repmat(v,n_trials,1);
elseif causalStruct==4
    v(16) = 1;
    prs=repmat(v,n_trials,1);
elseif causalStruct==5
    v(4) = 1;
    prs=repmat(v,n_trials,1);
end
struct_samps_id = sum(rand(n_trials,1) >= cumsum(prs,2),2)+1;
struct_samps=sts(struct_samps_id,:); % struct samples
% evaluating posteriors for the structures
v_target_relative=p_vgr_o_expand(model_params,o_target,o_surround,struct_samps(:,1),struct_samps(:,2),struct_samps(:,3),struct_samps(:,4));
v_group_relative=p_vrgr_o_expand(model_params,o_target,o_surround,struct_samps(:,1),struct_samps(:,2),struct_samps(:,3),struct_samps(:,4));
v_target_retina=v_group_relative+v_target_relative;
v_target_percept=((struct_samps(:,1)==1).*v_target_relative)+((struct_samps(:,1)==0).*(struct_samps(:,3)==1).*(struct_samps(:,4)==1).*v_group_relative);

end
