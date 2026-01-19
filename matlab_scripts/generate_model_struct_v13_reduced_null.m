function model = generate_model_struct_v13_reduced_null(id,subj_data,use_groups,model_type,decision_strat,incomplete_dir_save)
model.params_names = {...
    'Group1 sensory uncertainty',...
    'Group2 sensory uncertainty',...
    'Computational noise',...
    'Prior uncertainty',...
    'Weight on delta',...
    'Prior probability of combining group 1 and group2',...
    'lapse_rate',...
    'lapse_mu',...
    'lapse_sig',...
    'bias',...
    'motor_noise',...
    'nsamp'...
    };


if ~exist('use_groups','var')
    use_groups=unique(subj_data.conds(:,1));
else
    ids_del=setdiff(unique(subj_data.conds(:,1)),use_groups);
    for i=1:numel(ids_del)
        id_del_i=subj_data.conds(:,1)==ids_del(i);
        subj_data.resps(id_del_i)=[];
        subj_data.angs(id_del_i)=[];
        subj_data.conds(id_del_i,:)=[];
    end
end

model.id = id;


if exist('incomplete_dir_save','var')
    model.incomplete_dir_save=incomplete_dir_save;
end
% Parameter family
% Beta(a,b)=1
% Gamma(k,theta)=2
% Normal(mu,sig)=3
% Lognormal(mu,sig)=4
% Beta-prime(mu,sig)=5

model.min_sig=1e-10;
model.min_lapse=1e-4;

model.reduce=0;
model.tie=0;
model.add_noise_01=0.5;
model.use_bads=0;


if model_type<=9
    model_types=double(dec2bin(0:15,4))-48;
    model_types(:,3:4)=model_types(:,3:4).*model_types(:,1:2);
    model_types=unique(model_types,'rows');
    model_type1=model_types(model_type,:);
    model.use_separate_sigma=model_type1(1); %different variable
    model.use_separate_alps=model_type1(2);
    model.use_separate_sigp=model_type1(3);  %different duration
    model.use_separate_delta=model_type1(4);
else
    model.use_separate_sigma=1; %different variable
    model.use_separate_alps=0;
    model.use_separate_sigp=1;  %different duration
    model.use_separate_delta=0;
end



model.decision_strategy=decision_strat;




model.params_family = [5,5*ones(1,5),3,         4,4,3,3*ones(1,5),3,3*ones(1,5),  1,3,3*ones(1,5),3,3*ones(1,5) ,1,  1,3,4,  3,4];
model.params_additive_offset = [0,0*ones(1,5),0,      model.min_sig,model.min_sig,0,0*ones(1,5),0,0*ones(1,5),  zeros(1,1+2*6),0,  model.min_lapse,0,model.min_sig  ,0,model.min_sig];
model.params_multiplicative_offset = [1,1*ones(1,5),1,       1,1,ones(1,2*6), 1*ones(1,1+2*6),1,  1-model.min_lapse,1,1,  1,1];
model.params_hyperprior_params{1} = [1,1*ones(1,5),0,          -2,-2,0,zeros(1,5),0,zeros(1,5),      1.25,0,zeros(1,5),0,zeros(1,5),1.25,  1,0,0,  0,0];
model.params_hyperprior_params{2} = [1,1*ones(1,5),4,          2,2,4,4*ones(1,5),4,4*ones(1,5),  1.25,model.add_noise_01,model.add_noise_01*ones(1,5),model.add_noise_01,model.add_noise_01*ones(1,5),1.25,  5,pi,2.35, pi/2,2.35];
%motor noise lies between 0.01 and 100



model.exact_inference=0;

model.normprior_std = 1;
model.max_phi=6*model.normprior_std;
model.ns_inf=100;
model.eps_max=atand((0.5*60.96)/50); %Maximum eccentricity

model.num_params = length(model.params_family);
model.num_eff_params = model.num_params;

model.phi_theta = @(phi, model) phi_theta(phi, model);
model.theta_phi = @(theta, model) theta_phi(theta, model);

model.npts_quad = 3;
[model.pts_leg, model.wts_leg] = GaussLegendre(model.npts_quad);


load('std_kap','stds','kaps','beta_stds_greater_than_2','beta_stds_less_than_0p5');
model.stds=stds;
model.kaps=kaps;
model.beta_stds_greater_than_2=beta_stds_greater_than_2;
model.beta_stds_less_than_0p5=beta_stds_less_than_0p5;
% model.stds=stds;
% model.kaps=kaps;
% model.bet_log_ls_m0p8=bet_log_ls_m0p8;
% model.bet_log_gr_0p6=bet_log_gr_0p6;


ngroups=unique(subj_data.conds(:,1));

for i=1:numel(ngroups)
    id=subj_data.conds(:,1)==ngroups(i);

    angs=unique(subj_data.conds(id,2));

    vx=ones(size(angs));
    model.design_matrix{i}.angs_green=angs;
    model.design_matrix{i}.angs_red=zeros(size(angs));
    model.design_matrix{i}.eps_green=[vx,tand(angs)];
    if ngroups(i)~=0
        model.design_matrix{i}.eps_red=[vx,zeros(size(vx))];
        model.design_matrix{i}.num_groups=ngroups(i);
    else
        model.design_matrix{i}.eps_red=0*[vx,zeros(size(vx))];
        model.design_matrix{i}.num_groups=0;
    end

    for j=1:numel(angs)
        id1=(subj_data.conds(:,1)==ngroups(i)) & (subj_data.conds(:,2)==angs(j));
        model.data{i}.num_trials(j)=sum(id1);
        model.data{i}.resps{j}=subj_data.angs(id1);
        x=wrapTo180(subj_data.angs(id1));
        %         x(abs(x)>135)=[];
        model.data{i}.mu(j)=rad2deg(circ_mean(deg2rad(x)));
        model.data{i}.med(j)=rad2deg(median(deg2rad(x)));
        model.data{i}.mad(j)=rad2deg(1.4826*median(abs(circ_dist((deg2rad(x)),median(deg2rad(x))))));
        model.data{i}.se(j)=rad2deg(circ_std(deg2rad(x)));
        model.data{i}.iqr(j)=iqr(x(:));
        model.data{i}.vars(j)=var(deg2rad(x));
    end

    angs_pred=linspace(min(subj_data.conds(:,2)),max(subj_data.conds(:,2)),51)';
    vx1=sign(angs_pred);
    model.design_matrix_pred{i}.angs_green=angs_pred;
    model.design_matrix_pred{i}.angs_red=zeros(size(angs_pred));
    model.design_matrix_pred{i}.eps_green=[vx1,tand(angs_pred)];
    if ngroups(i)~=0
        model.design_matrix_pred{i}.eps_red=[vx1,zeros(size(vx1))];
        model.design_matrix_pred{i}.num_groups=ngroups(i);
    else
        model.design_matrix_pred{i}.eps_red=0*[vx1,zeros(size(vx1))];
        model.design_matrix_pred{i}.num_groups=0;
    end

end



model.set_default = [];
model.default_values = [];
if model.use_separate_sigma==0
    model.set_default = [model.set_default,10,16];
    model.default_values = [model.default_values,zeros(1,2)];
end
if model.use_separate_alps==0
    model.set_default = [model.set_default,23,29];
    model.default_values = [model.default_values,zeros(1,2)];
end
if model.use_separate_sigp==0
    model.set_default = [model.set_default,11:15,17:21];
    model.default_values = [model.default_values,zeros(1,10)];
end
if model.use_separate_delta==0
    model.set_default = [model.set_default,24:28,30:34];
    model.default_values = [model.default_values,zeros(1,10)];
end
if model_type==10
    model.set_default = [model.set_default,22];
    model.default_values = [model.default_values,0];
end



[~, ids_sort] = sort(model.set_default, 'descend');
model.num_eff_params = model.num_params - numel(model.set_default);
model.set_default = model.set_default(ids_sort);
model.default_values = model.default_values(ids_sort);

model.params_family_eff = model.params_family;
model.params_additive_offset_eff = model.params_additive_offset;
model.params_multiplicative_offset_eff = model.params_multiplicative_offset;
model.params_hyperprior_params_eff = model.params_hyperprior_params;
model.params_family_eff(model.set_default) = [];
model.params_additive_offset_eff(model.set_default) = [];
model.params_multiplicative_offset_eff(model.set_default) = [];
for jj = 1:numel(model.params_hyperprior_params)
    model.params_hyperprior_params_eff{jj}(model.set_default) = [];
end
model.params_theta = rand(1, model.num_eff_params);
model.params_theta(model.params_family_eff == 1) = betainv(model.params_theta(model.params_family_eff == 1), ...
    model.params_hyperprior_params_eff{1}(model.params_family_eff == 1), ...
    model.params_hyperprior_params_eff{2}(model.params_family_eff == 1));
model.params_theta(model.params_family_eff == 2) = gaminv(model.params_theta(model.params_family_eff == 2), ...
    model.params_hyperprior_params_eff{1}(model.params_family_eff == 2), ...
    model.params_hyperprior_params_eff{2}(model.params_family_eff == 2));
model.params_theta(model.params_family_eff == 3) = norminv(model.params_theta(model.params_family_eff == 3), ...
    model.params_hyperprior_params_eff{1}(model.params_family_eff == 3), ...
    sqrt(model.params_hyperprior_params_eff{2}(model.params_family_eff == 3)));
model.params_theta = model.params_multiplicative_offset_eff .* model.params_theta + model.params_additive_offset_eff;
model.params_phi = model.theta_phi(model.params_theta, model);

model.simulate_data = @(params_phi,model,ntrials) simulate_data(params_phi,model,ntrials);

model.simulate_prob_resp = @(params, model) simulate_prob_resp(params, model);
model.simulate_prob_resp_pred = @(params, model) simulate_prob_resp_pred(params, model);

% model.plot_model_pred=@(model,figid,showlegend) plot_model_pred(model,figid,showlegend);
model.plot_model_pred = @(model, fig_num,fig_size,plt_id, cond,col,plot_transp) plot_model_pred(model, fig_num,fig_size,plt_id, cond,col,plot_transp);
model.plot_model_pred_flipped = @(model, fig_num,fig_size,plt_id, cond,col,plot_transp) plot_model_pred_flipped(model, fig_num,fig_size,plt_id, cond,col,plot_transp);


model.get_samples_posterior = @(model, numchains, num_samples, num_samples_save) get_samples_posterior(model, numchains, num_samples, num_samples_save);
model.get_samples_posterior_parallel = @(model, numchains, num_samples, num_samples_save) get_samples_posterior_parallel(model, numchains, num_samples, num_samples_save);
model.get_annealed_samples_posterior_parallel = @(model, numchains, num_samples, num_samples_save) get_annealed_samples_posterior_parallel(model, numchains, num_samples, num_samples_save);

model.log_unnorm_post = @(params, model) log_unnorm_post(params, model);
model.log_likelihood = @(params, model) log_likelihood(params, model);
model.log_prior_theta = @(theta, model) log_prior_theta(theta, model);
model.log_prior_phi = @(phi, model) log_prior_phi(phi, model);

model.get_map = @(model, nstart, gethessian, useparallel) get_map(model, nstart, gethessian, useparallel);
model.get_annealed_map = @(model, nstart,temp, gethessian, useparallel) get_annealed_map(model, nstart,temp, gethessian, useparallel);
model.get_map_phi = @(model, nstart, gethessian, useparallel) get_map_phi(model, nstart, gethessian, useparallel);
model.get_mle = @(model, nstart, gethessian, useparallel) get_mle(model, nstart, gethessian, useparallel);
model.get_full_params= @(theta0, model) get_full_params(theta0, model);
model.get_bootstraps_map = @(model, nboot) get_bootstraps_map(model, nboot);
model.get_bootstraps_mle = @(model, nboot) get_bootstraps_mle(model, nboot);
model.get_params_struct = @(params_phi,model) get_params_struct(params_phi,model);
model.generate_flipped_data=@(model) generate_flipped_data(model);
end

function theta = phi_theta(phi, model)
phi=min(model.max_phi,max(-1*model.max_phi,phi));
theta = normcdf(phi, 0, model.normprior_std);
if sum(model.params_family_eff == 1)>0
    theta(:,model.params_family_eff == 1) = betainv(theta(:,model.params_family_eff == 1), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 1),size(phi,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 1),size(phi,1),1));
end
if sum(model.params_family_eff == 2)>0
    theta(:,model.params_family_eff == 2) = gaminv(theta(:,model.params_family_eff == 2), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 2),size(phi,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 2),size(phi,1),1));
end
if sum(model.params_family_eff == 3)>0
    theta(:,model.params_family_eff == 3) = norminv(theta(:,model.params_family_eff == 3), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 3),size(phi,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 3),size(phi,1),1));
end
if sum(model.params_family_eff == 4)>0
    theta(:,model.params_family_eff == 4) = logninv(theta(:,model.params_family_eff == 4), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 4),size(phi,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 4),size(phi,1),1));
end
if sum(model.params_family_eff == 5)>0
    theta(:,model.params_family_eff == 5) = betaprinv(theta(:,model.params_family_eff == 5), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 5),size(phi,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 5),size(phi,1),1));
end



theta = theta.*repmat(model.params_multiplicative_offset_eff,size(theta,1),1) + repmat(model.params_additive_offset_eff,size(theta,1),1);
end

function phi = theta_phi(theta, model)

phi = (theta - repmat(model.params_additive_offset_eff,size(theta,1),1)) ./ repmat(model.params_multiplicative_offset_eff,size(theta,1),1);
if sum(model.params_family_eff == 1)>0
    phi(:,model.params_family_eff == 1) = betacdf(phi(:,model.params_family_eff == 1), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 1),size(phi,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 1),size(phi,1),1));
end
if sum(model.params_family_eff == 2)>0
    phi(:,model.params_family_eff == 2) = gamcdf(phi(:,model.params_family_eff == 2), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 2),size(phi,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 2),size(phi,1),1));
end
if sum(model.params_family_eff == 3)>0
    phi(:,model.params_family_eff == 3) = normcdf(phi(:,model.params_family_eff == 3), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 3),size(phi,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 3),size(phi,1),1));
end
if sum(model.params_family_eff == 4)>0
    phi(:,model.params_family_eff == 4) = logncdf(phi(:,model.params_family_eff == 4), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 4),size(phi,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 4),size(phi,1),1));
end
if sum(model.params_family_eff == 5)>0
    phi(:,model.params_family_eff == 5) = betaprcdf(phi(:,model.params_family_eff == 5), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 5),size(phi,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 5),size(phi,1),1));
end

phi = norminv(phi, 0, model.normprior_std);
phi=min(model.max_phi,max(-1*model.max_phi,phi));
end


function model=generate_flipped_data(model)
for cond=1:numel(model.data)
    model.design_matrix{cond}.eps_green_flipped=model.design_matrix{cond}.eps_green(6:end,:);
    model.design_matrix{cond}.eps_red_flipped=model.design_matrix{cond}.eps_red(6:end,:);
    model.design_matrix{cond}.angs_green_flipped=model.design_matrix{cond}.angs_green(6:end);
    model.design_matrix{cond}.angs_red_flipped=model.design_matrix{cond}.angs_red(6:end);
    model.data{cond}.resps_flipped{1}=model.data{cond}.resps{6};
    for j=1:5
        model.data{cond}.resps_flipped{1+j}=[model.data{cond}.resps{6+j};-1*model.data{cond}.resps{6-j}];
    end

    for j=1:numel(model.data{cond}.resps_flipped)
        x=model.data{cond}.resps_flipped{j};
        model.data{cond}.mu_flipped(j)=rad2deg(circ_mean(deg2rad(x)));
        %         model.data{cond}.med_flipped(j)=rad2deg(median(deg2rad(x)));
        model.data{cond}.med_flipped(j)=rad2deg(circ_marg_median(deg2rad(x)));
        %         model.data{cond}.med_flipped_ci(j,:)=bootci(1e4,@(x1) rad2deg(circ_marg_median(deg2rad(x1))),x);

        %         model.data{cond}.mad_flipped(j)=rad2deg(1.4826*median(abs(circ_dist((deg2rad(x)),median(deg2rad(x))))));
        model.data{cond}.mad_flipped(j)=rad2deg(median(abs(circ_dist((deg2rad(x)),median(deg2rad(x))))));
        %         model.data{cond}.mad_flipped_ci(j,:)=bootci(1e4,@(x1) rad2deg(median(abs(circ_dist((deg2rad(x)),median(deg2rad(x)))))),x);
        model.data{cond}.se_flipped(j)=rad2deg(circ_std(deg2rad(x)));
        model.data{cond}.iqr_flipped(j)=iqr(x(:));
        model.data{cond}.vars_flipped(j)=var(deg2rad(x));
    end
end
end



function model=simulate_data(params_phi,model,ntrials)
pt=model.phi_theta(params_phi,model);
resp_struct1=simulate_prob_resp(pt,model);
pt=get_full_params(pt,model);
motor_noise=pt(40);

for jj=1:numel(model.design_matrix)

    if model.decision_strategy==2
        %     kap_s=(motor_noise.*resp_struct1{cond}.kap)./(resp_struct1{cond}.kap+motor_noise);
        kap_s=motor_noise;
        wp1=resp_struct1{jj}.wts;
        mu1=resp_struct1{jj}.mu;
        wq1=resp_struct1{jj}.wts_quad;
        pred_resp_mu=sum(wp1.*mu1,3);
        for kk=1:numel(model.design_matrix{jj}.angs_green)
            ind=randsample(size(pred_resp_mu,1),ntrials,true,wq1);
            res{kk}=nan*ones(ntrials,1);
            for mm=1:size(pred_resp_mu,1)
                id=find(ind==mm);
                res{kk}(id)=rad2deg(circ_vmrnd(pred_resp_mu(mm,kk),kap_s,numel(id)));
            end
        end
        res_mu(kk)=rad2deg(circ_mean(deg2rad(res{kk})));
    elseif model.decision_strategy==3
        kap_s=motor_noise;
        wq1=resp_struct1{jj}.wts_quad;
        for kk=1:numel(model.design_matrix{jj}.angs_green)

            wp1=reshape(resp_struct1{jj}.wts(:,kk,:),size(resp_struct1{jj}.wts,1),size(resp_struct1{jj}.wts,3));
            mu1=reshape(resp_struct1{jj}.mu(:,kk,:),size(resp_struct1{jj}.wts,1),size(resp_struct1{jj}.wts,3));
            pred_resp_mu(:,kk)=mu1(wp1==max(wp1,[],2));
            ind=randsample(size(pred_resp_mu,1),ntrials,true,wq1);
            res{kk}=nan*ones(ntrials,1);
            for mm=1:size(pred_resp_mu,1)
                id=find(ind==mm);
                res{kk}(id)=rad2deg(circ_vmrnd(pred_resp_mu(mm,kk),kap_s,numel(id)));
            end
        end
        res_mu(kk)=rad2deg(circ_mean(deg2rad(res{kk})));
    elseif model.decision_strategy==1




        x11=linspace(-180,180,1000);
        x11=0.5*(x11(1:end-1)+x11(2:end));
        for i1=1:numel(x11)
            pred_resp_wts=(resp_struct1{jj}.wts).*repmat(resp_struct1{jj}.wts_quad,[1,size(resp_struct1{jj}.wts,2),size(resp_struct1{jj}.wts,3)]);
            pred_resp_kap=resp_struct1{jj}.kap;

            log_kap_s=kap_eff_vmcomb(log(motor_noise),log(pred_resp_kap),cos(deg2rad(x11(i1))*ones(size(resp_struct1{cond}.mu))-resp_struct1{cond}.mu));
            tmp=logbesseli0_app(log_kap_s,1)-(log(2*pi)+logbesseli0_app(log(motor_noise),1)+logbesseli0_app(log(pred_resp_kap),1));
            tmp1=logsumexp_signed(log(abs(pred_resp_wts))+tmp,[1,3],sign(pred_resp_wts));

            y11(i1,:)=tmp1;
        end
        dy11=mean(diff(x11));
        y11=exp(y11+log(dy11)-logsumexp(y11+log(dy11),1));
        for kk=1:numel(model.design_matrix{jj}.angs_green)
            ind=randsample(size(y11,1),ntrials,true,y11(:,kk));
            x11=x11(:);
            res{kk}=x11(ind)+dy11*(rand(ntrials,1)-0.5);
            res_mu(kk)=rad2deg(circ_mean(deg2rad(res{kk})));
        end



        %         kap_s=(motor_noise.*resp_struct1{jj}.kap)./(resp_struct1{jj}.kap+motor_noise);
        %         x11=linspace(-180,180,1000);
        %         x11=0.5*(x11(1:end-1)+x11(2:end));
        %         for i1=1:numel(x11)
        %             wt1=(resp_struct1{jj}.wts).*repmat(resp_struct1{jj}.wts_quad,[1,1,size(resp_struct1{jj}.wts,3)]);
        %             tmp=logsumexp_signed(log(abs(wt1))+logcirc_vmpdf(deg2rad(x11(i1)*ones(size(resp_struct1{jj}.mu))),resp_struct1{jj}.mu,kap_s),1,sign(wt1));
        %             y11(i1,:)=logsumexp_signed(real(tmp),3,sign(isreal_vec(tmp)-0.5));
        %         end
        %         dy11=mean(diff(x11));
        %         y11=exp(y11+log(dy11)-logsumexp(y11+log(dy11),1));
        %         for kk=1:numel(model.design_matrix{jj}.angs_green)
        %             ind=randsample(size(y11,1),ntrials,true,y11(:,kk));
        %             x11=x11(:);
        %             res{kk}=x11(ind)+dy11*(rand(ntrials,1)-0.5);
        %             res_mu(kk)=rad2deg(circ_mean(deg2rad(res{kk})));
        %         end

    elseif model.decision_strategy==4
        kap_s=motor_noise;
        wp11=(resp_struct1{jj}.wts).*repmat(resp_struct1{jj}.wts_quad,[1,1,size(resp_struct1{jj}.wts,3)]);
        for kk=1:numel(model.design_matrix{jj}.angs_green)
            wp1=reshape(wp11(:,kk,:),size(wp11,1)*size(wp11,3),1);
            mu1=reshape(resp_struct1{jj}.mu(:,kk,:),size(wp11,1)*size(wp11,3),1);
            ind=randsample(size(mu1,1),ntrials,true,wp1);
            res{kk}=nan*ones(ntrials,1);
            for mm=1:size(mu1,1)
                id=find(ind==mm);
                res{kk}(id)=rad2deg(circ_vmrnd(mu1(mm),kap_s,numel(id)));
            end
        end
        res_mu(kk)=rad2deg(circ_mean(deg2rad(res{kk})));
    else
        nsamp=1;
        kap_s=(motor_noise.*resp_struct1{jj}.kap*nsamp)./(resp_struct1{jj}.kap*nsamp+motor_noise);
        wp11=(resp_struct1{jj}.wts).*repmat(resp_struct1{jj}.wts_quad,[1,1,size(resp_struct1{jj}.wts,3)]);
        for kk=1:numel(model.design_matrix{jj}.angs_green)
            wp1=reshape(wp11(:,kk,:),size(wp11,1)*size(wp11,3),1);
            mu1=reshape(resp_struct1{jj}.mu(:,kk,:),size(wp11,1)*size(wp11,3),1);
            kap1=reshape(kap_s(:,kk,:),size(wp11,1)*size(wp11,3),1);
            ind=randsample(size(mu1,1),ntrials,true,wp1);
            res{kk}=nan*ones(ntrials,1);
            for mm=1:size(mu1,1)
                id=find(ind==mm);
                res{kk}(id)=rad2deg(circ_vmrnd(mu1(mm),kap1(mm),numel(id)));
            end
        end
        res_mu(kk)=rad2deg(circ_mean(deg2rad(res{kk})));
    end
    model.data{jj}.num_trials=ntrials*ones(1,numel(model.design_matrix{jj}.angs_green));
    model.data{jj}.mu=res_mu;
    model.data{jj}.resps=res;
end

end



% % % function plot_model_pred_flipped(model, fig_num,fig_size,plt_id, cond,col,plot_transp)
% % % 
% % % plot_modelpred=1;
% % % plot_data=1;
% % % % plot_transp=1;
% % % 
% % % 
% % % 
% % % if isfield(model,'params_phi_map')
% % %     pt=model.phi_theta(model.params_phi_map,model);
% % %     resp_struct1=simulate_prob_resp(pt,model);
% % %     %     resp_struct=simulate_prob_resp_pred(pt,model,cond);
% % %     pt=get_full_params(pt,model);
% % % elseif isfield(model,'params_phi_mle')
% % %     pt=model.phi_theta(model.params_phi_mle,model);
% % %     resp_struct1=simulate_prob_resp(pt,model);
% % %     %     resp_struct=simulate_prob_resp_pred(pt,model,cond);
% % %     pt=get_full_params(pt,model);
% % % else
% % %     pt=model.phi_theta(model.params_phi,model);
% % %     resp_struct1=simulate_prob_resp(pt,model);
% % %     %     resp_struct=simulate_prob_resp_pred(pt,model,cond);
% % %     pt=get_full_params(pt,model);
% % % end
% % % 
% % % figure(fig_num);
% % % hold on
% % % 
% % % bin_width=0.2;
% % % subplot(fig_size(1),fig_size(2),plt_id);
% % % 
% % % 
% % % 
% % % x1=linspace(-180,180,51);
% % % x1(x1<-10)=-10+(x1(x1<-10)+10)*(20/170);
% % % x1(x1>100)=100+(x1(x1>100)-100)*(20/80);
% % % x11=linspace(-180,180,51);
% % % motor_noise=pt(40);
% % % if model.decision_strategy==2
% % %     %     kap_s=(motor_noise.*resp_struct1{cond}.kap)./(resp_struct1{cond}.kap+motor_noise);
% % %     kap_s=motor_noise;
% % %     wp1=resp_struct1{cond}.wts;
% % %     mu1=resp_struct1{cond}.mu;
% % %     wq1=resp_struct1{cond}.wts_quad;
% % %     pred_resp_mu=sum(wp1.*mu1,3);
% % %     for i1=1:numel(x11)
% % %         y11(i1,:)=logsumexp(log(wq1)+logcirc_vmpdf(deg2rad(x11(i1))*ones(size(pred_resp_mu)),pred_resp_mu,kap_s),1);
% % %     end
% % % elseif model.decision_strategy==3
% % %     kap_s=motor_noise;
% % %     wq1=resp_struct1{cond}.wts_quad;
% % %     for kk=1:numel(model.data{cond}.resps)
% % %         wp1=reshape(resp_struct1{cond}.wts(:,kk,:),size(resp_struct1{cond}.wts,1),size(resp_struct1{cond}.wts,3));
% % %         mu1=reshape(resp_struct1{cond}.mu(:,kk,:),size(resp_struct1{cond}.wts,1),size(resp_struct1{cond}.wts,3));
% % %         pred_resp_mu(:,kk)=mu1(wp1==max(wp1,[],2));
% % %     end
% % %     for i1=1:numel(x11)
% % %         y11(i1,:)=logsumexp(log(wq1)+logcirc_vmpdf(deg2rad(x11(i1))*ones(size(pred_resp_mu)),pred_resp_mu,kap_s),1);
% % %     end
% % % elseif model.decision_strategy==1
% % % 
% % %     for i1=1:numel(x11)
% % %         pred_resp_wts=(resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,size(resp_struct1{cond}.wts,2),size(resp_struct1{cond}.wts,3)]);
% % %         pred_resp_kap=resp_struct1{cond}.kap;
% % % 
% % %         log_kap_s=kap_eff_vmcomb(log(motor_noise),log(pred_resp_kap),cos(deg2rad(x11(i1))*ones(size(resp_struct1{cond}.mu))-resp_struct1{cond}.mu));
% % %         tmp=logbesseli0_app(log_kap_s,1)-(log(2*pi)+logbesseli0_app(log(motor_noise),1)+logbesseli0_app(log(pred_resp_kap),1));
% % %         tmp1=logsumexp_signed(log(abs(pred_resp_wts))+tmp,[1,3],sign(pred_resp_wts));
% % %         y11(i1,:)=tmp1;
% % %     end
% % % 
% % % 
% % %     %     kap_s=(motor_noise.*resp_struct1{cond}.kap)./(resp_struct1{cond}.kap+motor_noise);
% % %     %     for i1=1:numel(x11)
% % %     %         wt1=(resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,1,size(resp_struct1{cond}.wts,3)]);
% % %     %         tmp=logsumexp_signed(log(abs(wt1))+logcirc_vmpdf(deg2rad(x11(i1)*ones(size(resp_struct1{cond}.mu))),resp_struct1{cond}.mu,kap_s),1,sign(wt1));
% % %     %         y11(i1,:)=logsumexp_signed(real(tmp),3,sign(isreal_vec(tmp)-0.5));
% % %     %     end
% % % 
% % % elseif model.decision_strategy==4
% % %     kap_s=motor_noise;
% % %     for i1=1:numel(x11)
% % %         y11(i1,:)=logsumexp(logsumexp(log((resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,1,size(resp_struct1{cond}.wts,3)]))+logcirc_vmpdf(deg2rad(x11(i1)*ones(size(resp_struct1{cond}.mu))),resp_struct1{cond}.mu,kap_s),1),3);
% % %     end
% % % 
% % % else
% % %     nsamp=1;
% % %     kap_s=(motor_noise.*resp_struct1{cond}.kap*nsamp)./(resp_struct1{cond}.kap*nsamp+motor_noise);
% % %     for i1=1:numel(x11)
% % %         y11(i1,:)=logsumexp(logsumexp(log((resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,1,size(resp_struct1{cond}.wts,3)]))+logcirc_vmpdf(deg2rad(x11(i1)*ones(size(resp_struct1{cond}.mu))),resp_struct1{cond}.mu,kap_s),1),3);
% % %     end
% % % 
% % % end
% % % 
% % % 
% % % violin_width=0.2;
% % % 
% % % ysp=[0:floor(0.5*numel(model.design_matrix{cond}.angs_green))];
% % % ysp=map_signed_logspace(model.design_matrix{cond}.angs_green(ceil(0.5*numel(model.design_matrix{cond}.angs_green)):end))';
% % % 
% % % 
% % % xsp=model.design_matrix{cond}.angs_green(6:end)';
% % % %  xsp_pred=model.design_matrix_pred{cond}.angs_green(:)';
% % % % ysp_pred=interp1(xsp,ysp,xsp_pred);
% % % 
% % % y11=[y11(:,6),log(0.5*(flipud(fliplr(exp(y11(:,1:5))))+(exp(y11(:,7:11)))))];
% % % 
% % % 
% % % if plot_modelpred==1
% % %     for i1=1:size(y11,2)
% % %         violin_x=(exp(y11(:,i1))./max(exp(y11(:,i1))))*violin_width;
% % %         %     plot(ysp(i1)+violin_x,x1,'k','linewidth',0.5);
% % %         %     plot(ysp(i1)-violin_x,x1,'k','linewidth',0.5);
% % %         patch([ysp(i1)+violin_x(:);flipud(ysp(i1)-violin_x(:))],map_signed_logspace([x1(:);flipud(x1(:))]),col*0.25+[1,1,1]*0.75);
% % %         hold on
% % %         drawnow
% % %     end
% % % end
% % % 
% % % 
% % % for j=1:5
% % %     model.data{cond}.resps{6+j}=[model.data{cond}.resps{6+j};-1*model.data{cond}.resps{6-j}];
% % % end
% % % model.data{cond}.resps=model.data{cond}.resps(6:end);
% % % 
% % % if plot_data==1
% % %     if plot_transp==0
% % %         for j=1:numel(ysp)
% % %             %     plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}))-0.5)),model.data{cond}.resps{j},'k.','markersize',10);
% % %             id1=model.data{cond}.resps{j}<100 & model.data{cond}.resps{j}>-10;
% % %             plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}(id1)))-0.5)),map_signed_logspace(model.data{cond}.resps{j}(id1)),'.','Color',col,'markersize',5);
% % %             hold on;drawnow
% % %             id2=model.data{cond}.resps{j}>100;
% % %             plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}(id2)))-0.5)),map_signed_logspace(100+(model.data{cond}.resps{j}(id2)-100)*(20/80)),'.','Color',col,'markersize',5);
% % %             id3=model.data{cond}.resps{j}<-10;
% % %             plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}(id3)))-0.5)),map_signed_logspace(-10+(model.data{cond}.resps{j}(id3)+10)*(20/170)),'.','Color',col,'markersize',5);
% % %         end
% % %     else
% % %         transp_marker=0.005;
% % %         for j=1:numel(ysp)
% % %             %     plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}))-0.5)),model.data{cond}.resps{j},'k.','markersize',10);
% % %             id1=model.data{cond}.resps{j}<100 & model.data{cond}.resps{j}>-10;
% % %             scatter(repmat(ysp(j),sum(id1),1),model.data{cond}.resps{j}(id1),50,'filled','markerfacecolor',col,'markerfacealpha',transp_marker);
% % %             hold on;drawnow
% % %             id2=model.data{cond}.resps{j}>100;
% % %             scatter(repmat(ysp(j),sum(id2),1),100+(model.data{cond}.resps{j}(id2)-100)*(20/80),50,'filled','markerfacecolor',col,'markerfacealpha',transp_marker);
% % %             id3=model.data{cond}.resps{j}<-10;
% % %             scatter(repmat(ysp(j),sum(id3),1),-10+(model.data{cond}.resps{j}(id3)+10)*(20/170),50,'filled','markerfacecolor',col,'markerfacealpha',transp_marker);
% % %         end
% % %     end
% % % end
% % % % xsp_pred=atan2d(sum((resp_struct.wts).*sin(resp_struct.mu),[1,3]),sum((resp_struct.wts).*cos(resp_struct.mu),[1,3]));
% % % % plot(ysp_pred,xsp_pred,'k','linewidth',2);
% % % 
% % % 
% % % 
% % % 
% % % 
% % % ylim(map_signed_logspace([-30,120]));
% % % % yticks([-30,-10,0:30:90,100,120]);
% % % % yticklabels([-180,-10,0:30:90,100,180]);
% % % yticks(map_signed_logspace([-30,-20,-5,-2.5,0,2.5,5,20,45,90,120]));
% % % yticklabels([-180,-20,-5,-2.5,0,2.5,5,20,45,90,180]);
% % % xticks(ysp);xticklabels(model.design_matrix{cond}.angs_green(ceil(0.5*numel(model.design_matrix{cond}.angs_green)):end));
% % % xlim(map_signed_logspace([-0.5,68]))
% % % plot(ysp,map_signed_logspace(xsp),'k--')
% % % plot(ysp,map_signed_logspace(90*ones(size(ysp))),'k-.');
% % % plot(ysp,map_signed_logspace(-90*ones(size(ysp))),'k-.');
% % % plot(ysp,map_signed_logspace(0*ones(size(ysp))),'k-');
% % % 
% % % ylabel('reported target direction');
% % % xlabel('retinal target direction');
% % % axis square
% % % 
% % % end
function plot_model_pred_flipped(model, fig_num,fig_size,plt_id, cond,col,plot_transp)

plot_modelpred=1;
plot_data=1;
% plot_transp=1;



if isfield(model,'params_phi_map')
    pt=model.phi_theta(model.params_phi_map,model);
    resp_struct1=simulate_prob_resp(pt,model);
    %     resp_struct=simulate_prob_resp_pred(pt,model,cond);
    pt=get_full_params(pt,model);
elseif isfield(model,'params_phi_mle')
    pt=model.phi_theta(model.params_phi_mle,model);
    resp_struct1=simulate_prob_resp(pt,model);
    %     resp_struct=simulate_prob_resp_pred(pt,model,cond);
    pt=get_full_params(pt,model);
else
    pt=model.phi_theta(model.params_phi,model);
    resp_struct1=simulate_prob_resp(pt,model);
    %     resp_struct=simulate_prob_resp_pred(pt,model,cond);
    pt=get_full_params(pt,model);
end

figure(fig_num);
hold on

bin_width=0.2;
subplot(fig_size(1),fig_size(2),plt_id);



x1=linspace(-180,180,51);
% x1(x1<-10)=-10+(x1(x1<-10)+10)*(20/170);
% x1(x1>100)=100+(x1(x1>100)-100)*(20/80);
x1(x1<-20)=-20+(x1(x1<-20)+20)*(10/160);
x1(x1>110)=110+(x1(x1>110)-110)*(10/70);
x11=linspace(-180,180,51);
motor_noise=pt(40);
if model.decision_strategy==2
    %     kap_s=(motor_noise.*resp_struct1{cond}.kap)./(resp_struct1{cond}.kap+motor_noise);
    kap_s=motor_noise;
    wp1=resp_struct1{cond}.wts;
    mu1=resp_struct1{cond}.mu;
    wq1=resp_struct1{cond}.wts_quad;
    pred_resp_mu=sum(wp1.*mu1,3);
    for i1=1:numel(x11)
        y11(i1,:)=logsumexp(log(wq1)+logcirc_vmpdf(deg2rad(x11(i1))*ones(size(pred_resp_mu)),pred_resp_mu,kap_s),1);
    end
elseif model.decision_strategy==3
    kap_s=motor_noise;
    wq1=resp_struct1{cond}.wts_quad;
    for kk=1:numel(model.data{cond}.resps)
        wp1=reshape(resp_struct1{cond}.wts(:,kk,:),size(resp_struct1{cond}.wts,1),size(resp_struct1{cond}.wts,3));
        mu1=reshape(resp_struct1{cond}.mu(:,kk,:),size(resp_struct1{cond}.wts,1),size(resp_struct1{cond}.wts,3));
        pred_resp_mu(:,kk)=mu1(wp1==max(wp1,[],2));
    end
    for i1=1:numel(x11)
        y11(i1,:)=logsumexp(log(wq1)+logcirc_vmpdf(deg2rad(x11(i1))*ones(size(pred_resp_mu)),pred_resp_mu,kap_s),1);
    end
elseif model.decision_strategy==1

    for i1=1:numel(x11)
        pred_resp_wts=(resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,size(resp_struct1{cond}.wts,2),size(resp_struct1{cond}.wts,3)]);
        pred_resp_kap=resp_struct1{cond}.kap;

        log_kap_s=kap_eff_vmcomb(log(motor_noise),log(pred_resp_kap),cos(deg2rad(x11(i1))*ones(size(resp_struct1{cond}.mu))-resp_struct1{cond}.mu));
        tmp=logbesseli0_app(log_kap_s,1)-(log(2*pi)+logbesseli0_app(log(motor_noise),1)+logbesseli0_app(log(pred_resp_kap),1));
        tmp1=logsumexp_signed(log(abs(pred_resp_wts))+tmp,[1,3],sign(pred_resp_wts));
        y11(i1,:)=tmp1;
    end


    %     kap_s=(motor_noise.*resp_struct1{cond}.kap)./(resp_struct1{cond}.kap+motor_noise);
    %     for i1=1:numel(x11)
    %         wt1=(resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,1,size(resp_struct1{cond}.wts,3)]);
    %         tmp=logsumexp_signed(log(abs(wt1))+logcirc_vmpdf(deg2rad(x11(i1)*ones(size(resp_struct1{cond}.mu))),resp_struct1{cond}.mu,kap_s),1,sign(wt1));
    %         y11(i1,:)=logsumexp_signed(real(tmp),3,sign(isreal_vec(tmp)-0.5));
    %     end

elseif model.decision_strategy==4
    kap_s=motor_noise;
    for i1=1:numel(x11)
        y11(i1,:)=logsumexp(logsumexp(log((resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,1,size(resp_struct1{cond}.wts,3)]))+logcirc_vmpdf(deg2rad(x11(i1)*ones(size(resp_struct1{cond}.mu))),resp_struct1{cond}.mu,kap_s),1),3);
    end

else
    nsamp=1;
    kap_s=(motor_noise.*resp_struct1{cond}.kap*nsamp)./(resp_struct1{cond}.kap*nsamp+motor_noise);
    for i1=1:numel(x11)
        y11(i1,:)=logsumexp(logsumexp(log((resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,1,size(resp_struct1{cond}.wts,3)]))+logcirc_vmpdf(deg2rad(x11(i1)*ones(size(resp_struct1{cond}.mu))),resp_struct1{cond}.mu,kap_s),1),3);
    end

end


violin_width=0.2;



yspp=model.design_matrix{cond}.angs_green(ceil(0.5*numel(model.design_matrix{cond}.angs_green)):end);
ysp=map_signed_logspace(yspp)';
% global rdds
% global idd
% ysp=ysp+0.1*rdds(idd,:);


xsp=model.design_matrix{cond}.angs_green(6:end)';
%  xsp_pred=model.design_matrix_pred{cond}.angs_green(:)';
% ysp_pred=interp1(xsp,ysp,xsp_pred);

y11=[y11(:,6),log(0.5*(flipud(fliplr(exp(y11(:,1:5))))+(exp(y11(:,7:11)))))];


if plot_modelpred==1
    for i1=1:size(y11,2)
        violin_x=(exp(y11(:,i1))./max(exp(y11(:,i1))))*violin_width;
        %     plot(ysp(i1)+violin_x,x1,'k','linewidth',0.5);
        %     plot(ysp(i1)-violin_x,x1,'k','linewidth',0.5);
        patch([ysp(i1)+violin_x(:);flipud(ysp(i1)-violin_x(:))],[x1(:);flipud(x1(:))],col*0.25+[1,1,1]*0.75);
        hold on
        drawnow
    end
end


for j=1:5
    model.data{cond}.resps{6+j}=[model.data{cond}.resps{6+j};-1*model.data{cond}.resps{6-j}];
end
model.data{cond}.resps=model.data{cond}.resps(6:end);

if plot_data==1
    if plot_transp==0
        for j=1:numel(ysp)
            %     plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}))-0.5)),model.data{cond}.resps{j},'k.','markersize',10);
            id1=model.data{cond}.resps{j}<100 & model.data{cond}.resps{j}>-10;
            plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}(id1)))-0.5)),model.data{cond}.resps{j}(id1),'.','Color',col,'markersize',5);
            hold on;drawnow
            id2=model.data{cond}.resps{j}>100;
            plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}(id2)))-0.5)),100+(model.data{cond}.resps{j}(id2)-100)*(20/80),'.','Color',col,'markersize',5);
            id3=model.data{cond}.resps{j}<-10;
            plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}(id3)))-0.5)),-10+(model.data{cond}.resps{j}(id3)+10)*(20/170),'.','Color',col,'markersize',5);
        end
    else
        transp_marker=1;
        for j=1:numel(ysp)
            %     plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}))-0.5)),model.data{cond}.resps{j},'k.','markersize',10);
             % id1=model.data{cond}.resps{j}<100 & model.data{cond}.resps{j}>-10;
            % scatter(repmat(ysp(j),sum(id1),1),model.data{cond}.resps{j}(id1),50,'filled','markerfacecolor',col,'markerfacealpha',transp_marker);
            % hold on;drawnow
            % id2=model.data{cond}.resps{j}>100;
            % scatter(repmat(ysp(j),sum(id2),1),100+(model.data{cond}.resps{j}(id2)-100)*(20/80),50,'filled','markerfacecolor',col,'markerfacealpha',transp_marker);
            % id3=model.data{cond}.resps{j}<-10;
            % scatter(repmat(ysp(j),sum(id3),1),-10+(model.data{cond}.resps{j}(id3)+10)*(20/170),50,'filled','markerfacecolor',col,'markerfacealpha',transp_marker);
            hold on;drawnow;
            id1=model.data{cond}.resps{j}<=180 & model.data{cond}.resps{j}>-180;
            
             plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}(id1)))-0.5)),map_perc_mi([1,tand(yspp(j))],[1,0],model.data{cond}.resps{j}(id1)),'.','Color',col,'markersize',5);

        end
    end
end
% xsp_pred=atan2d(sum((resp_struct.wts).*sin(resp_struct.mu),[1,3]),sum((resp_struct.wts).*cos(resp_struct.mu),[1,3]));
% plot(ysp_pred,xsp_pred,'k','linewidth',2);


ysp=map_signed_logspace(yspp)';


ylim([-30,120]);
% ylim([-1,1]);
xlim(map_signed_logspace([-0.5,68]));
% xlim(map_signed_logspace([2,45*5/4]));
% yticks([-30,-10,0:30:90,100,120]);

% yticklabels([-180,-10,0:30:90,100,180]);

yt=[-180:45:180];

yt(yt<-20)=-20+(yt(yt<-20)+20)*(10/160);
yt(yt>110)=110+(yt(yt>110)-110)*(10/70);
yticks(yt);
% yticks([-1:0.5:1])
% plot(map_signed_logspace([-0.5,-0.5]),[-30,-20],'color',[0.75,0.75,0.75],'linewidth',1.5);
% plot(map_signed_logspace([-0.5,-0.5]),[110,120],'color',[0.75,0.75,0.75],'linewidth',1.5);

yticklabels(yt);
xticks(ysp);xticklabels(model.design_matrix{cond}.angs_green(ceil(0.5*numel(model.design_matrix{cond}.angs_green)):end));
plot(ysp,xsp,'k--')
plot(ysp,90*ones(size(ysp)),'k-.');
plot(ysp,-90*ones(size(ysp)),'k-.');
plot(ysp,0*ones(size(ysp)),'k-');

ylabel('reported target direction');
xlabel('retinal target direction');
axis fill

end






function plot_model_pred(model, fig_num,fig_size,plt_id, cond,col,plot_transp)
plot_modelpred=1;
plot_data=1;
% plot_transp=1;


if isfield(model,'params_phi_map')
    pt=model.phi_theta(model.params_phi_map,model);
    resp_struct1=simulate_prob_resp(pt,model);
    %     resp_struct=simulate_prob_resp_pred(pt,model,cond);
    pt=get_full_params(pt,model);
elseif isfield(model,'params_phi_mle')
    pt=model.phi_theta(model.params_phi_mle,model);
    resp_struct1=simulate_prob_resp(pt,model);
    %     resp_struct=simulate_prob_resp_pred(pt,model,cond);
    pt=get_full_params(pt,model);
else
    pt=model.phi_theta(model.params_phi,model);
    resp_struct1=simulate_prob_resp(pt,model);
    %     resp_struct=simulate_prob_resp_pred(pt,model,cond);
    pt=get_full_params(pt,model);
end

figure(fig_num);
hold on

bin_width=0.2;
subplot(fig_size(1),fig_size(2),plt_id);



x1=linspace(-180,180,51);
x1(x1<-100)=-100+(x1(x1<-100)+100)*(20/80);
x1(x1>100)=100+(x1(x1>100)-100)*(20/80);
x11=linspace(-180,180,51);
motor_noise=pt(40);
if model.decision_strategy==2
    %     kap_s=(motor_noise.*resp_struct1{cond}.kap)./(resp_struct1{cond}.kap+motor_noise);
    kap_s=motor_noise;
    wp1=resp_struct1{cond}.wts;
    mu1=resp_struct1{cond}.mu;
    wq1=resp_struct1{cond}.wts_quad;
    pred_resp_mu=sum(wp1.*mu1,3);
    for i1=1:numel(x11)
        y11(i1,:)=logsumexp(log(wq1)+logcirc_vmpdf(deg2rad(x11(i1))*ones(size(pred_resp_mu)),pred_resp_mu,kap_s),1);
    end
elseif model.decision_strategy==3
    kap_s=motor_noise;
    wq1=resp_struct1{cond}.wts_quad;
    for kk=1:numel(model.data{cond}.resps)
        wp1=reshape(resp_struct1{cond}.wts(:,kk,:),size(resp_struct1{cond}.wts,1),size(resp_struct1{cond}.wts,3));
        mu1=reshape(resp_struct1{cond}.mu(:,kk,:),size(resp_struct1{cond}.wts,1),size(resp_struct1{cond}.wts,3));
        pred_resp_mu(:,kk)=mu1(wp1==max(wp1,[],2));
    end
    for i1=1:numel(x11)
        y11(i1,:)=logsumexp(log(wq1)+logcirc_vmpdf(deg2rad(x11(i1))*ones(size(pred_resp_mu)),pred_resp_mu,kap_s),1);
    end
elseif model.decision_strategy==1

    for i1=1:numel(x11)
        pred_resp_wts=(resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,size(resp_struct1{cond}.wts,2),size(resp_struct1{cond}.wts,3)]);
        pred_resp_kap=resp_struct1{cond}.kap;

        log_kap_s=kap_eff_vmcomb(log(motor_noise),log(pred_resp_kap),cos(deg2rad(x11(i1))*ones(size(resp_struct1{cond}.mu))-resp_struct1{cond}.mu));
        tmp=logbesseli0_app(log_kap_s,1)-(log(2*pi)+logbesseli0_app(log(motor_noise),1)+logbesseli0_app(log(pred_resp_kap),1));
        tmp1=logsumexp_signed(log(abs(pred_resp_wts))+tmp,[1,3],sign(pred_resp_wts));
        y11(i1,:)=tmp1;
    end


    %     kap_s=(motor_noise.*resp_struct1{cond}.kap)./(resp_struct1{cond}.kap+motor_noise);
    %     for i1=1:numel(x11)
    %         wt1=(resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,1,size(resp_struct1{cond}.wts,3)]);
    %         tmp=logsumexp_signed(log(abs(wt1))+logcirc_vmpdf(deg2rad(x11(i1)*ones(size(resp_struct1{cond}.mu))),resp_struct1{cond}.mu,kap_s),1,sign(wt1));
    %         y11(i1,:)=logsumexp_signed(real(tmp),3,sign(isreal_vec(tmp)-0.5));
    %     end

elseif model.decision_strategy==4
    kap_s=motor_noise;
    for i1=1:numel(x11)
        y11(i1,:)=logsumexp(logsumexp(log((resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,1,size(resp_struct1{cond}.wts,3)]))+logcirc_vmpdf(deg2rad(x11(i1)*ones(size(resp_struct1{cond}.mu))),resp_struct1{cond}.mu,kap_s),1),3);
    end

else
    kap_s=(motor_noise.*resp_struct1{cond}.kap*nsamp)./(resp_struct1{cond}.kap*nsamp+motor_noise);
    for i1=1:numel(x11)
        y11(i1,:)=logsumexp(logsumexp(log((resp_struct1{cond}.wts).*repmat(resp_struct1{cond}.wts_quad,[1,1,size(resp_struct1{cond}.wts,3)]))+logcirc_vmpdf(deg2rad(x11(i1)*ones(size(resp_struct1{cond}.mu))),resp_struct1{cond}.mu,kap_s),1),3);
    end

end


violin_width=0.2;

ysp=[1:numel(model.design_matrix{cond}.angs_green)]-ceil(0.5.*numel(model.design_matrix{cond}.angs_green));
xsp=model.design_matrix{cond}.angs_green(:)';
% ysp=[0:floor(0.5*numel(model.design_matrix{cond}.angs_green))];
% xsp=model.design_matrix{cond}.angs_green(6:end)';
%  xsp_pred=model.design_matrix_pred{cond}.angs_green(:)';
% ysp_pred=interp1(xsp,ysp,xsp_pred);

% y11=[y11(:,6),log(0.5*(flipud(fliplr(exp(y11(:,1:5))))+(exp(y11(:,7:11)))))];


if plot_modelpred==1
    for i1=1:size(y11,2)
        violin_x=(exp(y11(:,i1))./max(exp(y11(:,i1))))*violin_width;
        %     plot(ysp(i1)+violin_x,x1,'k','linewidth',0.5);
        %     plot(ysp(i1)-violin_x,x1,'k','linewidth',0.5);
        patch([ysp(i1)+violin_x(:);flipud(ysp(i1)-violin_x(:))],[x1(:);flipud(x1(:))],col*0.25+[1,1,1]*0.75);
        hold on
        drawnow
    end
end


% for j=1:5
%     model.data{cond}.resps{6+j}=[model.data{cond}.resps{6+j};-1*model.data{cond}.resps{6-j}];
% end
% model.data{cond}.resps=model.data{cond}.resps(6:end);

if plot_data==1
    if plot_transp==0
        for j=1:numel(ysp)
            %     plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}))-0.5)),model.data{cond}.resps{j},'k.','markersize',10);
            id1=model.data{cond}.resps{j}<100 & model.data{cond}.resps{j}>-100;
            plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}(id1)))-0.5)),model.data{cond}.resps{j}(id1),'.','Color',col,'markersize',5);
            hold on;drawnow
            id2=model.data{cond}.resps{j}>100;
            plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}(id2)))-0.5)),100+(model.data{cond}.resps{j}(id2)-100)*(20/80),'.','Color',col,'markersize',5);
            id3=model.data{cond}.resps{j}<-100;
            plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}(id3)))-0.5)),-100+(model.data{cond}.resps{j}(id3)+100)*(20/80),'.','Color',col,'markersize',5);
        end
    else
        transp_marker=0.005;
        for j=1:numel(ysp)
            %     plot(ysp(j)+(bin_width*(rand(size(model.data{cond}.resps{j}))-0.5)),model.data{cond}.resps{j},'k.','markersize',10);
            id1=model.data{cond}.resps{j}<100 & model.data{cond}.resps{j}>-100;
            scatter(repmat(ysp(j),sum(id1),1),model.data{cond}.resps{j}(id1),50,'filled','markerfacecolor',col,'markerfacealpha',transp_marker);
            hold on;drawnow
            id2=model.data{cond}.resps{j}>100;
            scatter(repmat(ysp(j),sum(id2),1),100+(model.data{cond}.resps{j}(id2)-100)*(20/80),50,'filled','markerfacecolor',col,'markerfacealpha',transp_marker);
            id3=model.data{cond}.resps{j}<-100;
            scatter(repmat(ysp(j),sum(id3),1),-100+(model.data{cond}.resps{j}(id3)+100)*(20/80),50,'filled','markerfacecolor',col,'markerfacealpha',transp_marker);
        end
    end
end
% xsp_pred=atan2d(sum((resp_struct.wts).*sin(resp_struct.mu),[1,3]),sum((resp_struct.wts).*cos(resp_struct.mu),[1,3]));
% plot(ysp_pred,xsp_pred,'k','linewidth',2);





ylim([-120,120]);
yticks([-120,-100,-90:30:90,100,120]);
yticklabels([-180,-100,-90:30:90,100,180]);
xticks(ysp);xticklabels(model.design_matrix{cond}.angs_green);
plot(ysp,xsp,'k--')
plot(ysp,90*ones(size(ysp)),'k-.');
plot(ysp,-90*ones(size(ysp)),'k-.');
plot(ysp,0*ones(size(ysp)),'k-');

ylabel('reported target direction');
xlabel('retinal target direction');
axis square

end



function model = get_samples_posterior(model, numchains, num_samples, num_samples_save)
model = gess_model(model, numchains, num_samples, num_samples_save, 0, 0);
end

function model = get_samples_posterior_parallel(model, numchains, num_samples, num_samples_save)
if isfield(model, 'incomplete_dir_save')

    model = gess_parallel_v2(model.incomplete_dir_save,model, numchains, num_samples, num_samples_save, 0, 0);
else
    model = gess_parallel(model, numchains, num_samples, num_samples_save, 0, 0);
end

end
function model = get_annealed_samples_posterior_parallel(model, numchains, num_samples, num_samples_save)
if isfield(model, 'incomplete_dir_save')

    model = annealed_gess_parallel_v2(model.incomplete_dir_save,model, numchains, num_samples, num_samples_save, 0, 0);
else
    model = annealed_gess_parallel(model, numchains, num_samples, num_samples_save, 0, 0);
end

end

function model1 = get_bootstraps_map(model, nboot)


options = optimoptions(@fminunc, 'Display', 'iter', 'MaxFunctionEvaluations', 1e4,'MaxIterations',1e4);

for i = 1:nboot
    model1{i} = model;
    model1{i}.data{1}.num_ch1 = binornd(model1{i}.data{1}.num_repeats, model1{i}.data{1}.num_ch1 ./ model1{i}.data{1}.num_repeats);
end

parfor i = 1:nboot
    i

    param0 = normrnd(0, model.normprior_std, [1, model1{i}.num_eff_params]);
    boots(i, :) = fminunc(@(x) - 1 * (model.log_likelihood(x, model) + model.log_prior_theta(model.phi_theta(x, model), model)), param0, options);
end
model.boots = boots;
end

function model1 = get_bootstraps_mle(model, nboot)


options = optimoptions(@fminunc, 'Display', 'iter', 'MaxFunctionEvaluations', 1e4,'MaxIterations',1e4);

for i = 1:nboot
    model1{i} = model;
    model1{i}.data{1}.num_ch1 = binornd(model1{i}.data{1}.num_repeats, model1{i}.data{1}.num_ch1 ./ model1{i}.data{1}.num_repeats);
end

parfor i = 1:nboot
    i

    param0 = normrnd(0, model.normprior_std, [1, model1{i}.num_eff_params]);
    boots(i, :) = fminunc(@(x) - 1 * (model.log_likelihood(x, model)), param0, options);
end
model.boots = boots;
end

function model = get_map_phi(model, nstart, gethessian, useparallel)

options = optimoptions(@fminunc, 'Display', 'iter', 'MaxFunctionEvaluations', 1e5,'MaxIterations',1e5);
np=model.num_eff_params;
if isfield(model,'init')
    init=model.init;
    sd=1e-2*model.normprior_std;
else
    init=zeros(1,np);
    sd=model.normprior_std;
end

sd0=model.normprior_std;
if isfield(model,'prop_prior')
    prop_prior=model.prop_prior;
else
    prop_prior=0.3;
end
ns_prior=floor((1-prop_prior)*nstart);
ll=@(x) model.log_likelihood(x,model);
lp=@(x) model.log_prior_phi(x, model);

if useparallel == 1



    parfor i = 1:nstart
        if i>1
            if i>ns_prior
                param0=normrnd(0,sd0,[1,np]);
            else
                param0=init+normrnd(0, sd, [1, np]);
            end

        else
            param0=init;
        end
        ll0=ll(param0) + lp(param0);
        while(isinf(ll0) || isnan(ll0))
            param0=normrnd(0,sd0,[1,np]);
            ll0=ll(param0) + lp(param0);
        end
        if gethessian == 1

            [fit(i, :), neg_lups(i), ~, ~, ~, hes{i}] = fminunc(@(x) -1*(ll(x) + lp(x)), param0, options);

        else
            %             try
            if model.use_bads==1
                [fit(i, :), neg_lups(i)] = bads(@(x) -1*(ll(x) + lp(x)), param0, -6*ones(1,model.num_eff_params), 6*ones(1,model.num_eff_params));

            else

                try
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), param0, options);
                catch
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), normrnd(0,sd0,[1,np]), options);
                end


            end
            %             catch er
            %                 keyboard
            %             end
        end
    end
else

    for i = 1:nstart


        if i>1
            if i>ns_prior
                param0=normrnd(0,sd0,[1,np]);
            else
                param0=init+normrnd(0, sd, [1, np]);
            end

        else
            param0=init;
        end
        ll0=ll(param0) + lp(param0);
        while(isinf(ll0) || isnan(ll0))
            param0=normrnd(0,sd0,[1,np]);
            ll0=ll(param0) + lp(param0);
        end
        if gethessian == 1
            [fit(i, :), neg_lups(i), ~, ~, ~, hes{i}] = fminunc(@(x) -1*(ll(x) + lp(x)), param0, options);

        else
            %             try
            if model.use_bads==1
                [fit(i, :), neg_lups(i)] = bads(@(x) -1*(ll(x) + lp(x)), param0, -6*ones(1,model.num_eff_params), 6*ones(1,model.num_eff_params));

            else

                try
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), param0, options);
                catch
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), normrnd(0,sd0,[1,np]), options);
                end

            end
            %             catch er
            %                 keyboard
            %             end
        end
    end
end

model.params_phi_map = fit(find(neg_lups == min(neg_lups), 1), :);
model.map_allparams=fit;
model.map_neg_lups=neg_lups;
if gethessian == 1
    model.params_phi_hessian = hes{find(neg_lups == min(neg_lups), 1)};

end
end

function model = get_map(model, nstart, gethessian, useparallel)

options = optimoptions(@fminunc, 'Display', 'iter', 'MaxFunctionEvaluations', 1e5,'MaxIterations',1e5);
np=model.num_eff_params;
if isfield(model,'init')
    init=model.init;
    sd=1e-2*model.normprior_std;
else
    init=zeros(1,np);
    sd=model.normprior_std;
end
sd0=model.normprior_std;
if isfield(model,'prop_prior')
    prop_prior=model.prop_prior;
else
    prop_prior=0.3;
end
ns_prior=floor((1-prop_prior)*nstart);


ll=@(x) model.log_likelihood(x,model);
lp=@(x) model.log_prior_theta(model.phi_theta(x,model), model);

if useparallel == 1



    parfor i = 1:nstart
        if i>1
            if i>ns_prior
                param0=normrnd(0,sd0,[1,np]);
            else
                param0=init+normrnd(0, sd, [1, np]);
            end

        else
            param0=init;
        end
        ll0=ll(param0) + lp(param0);
        while(isinf(ll0) || isnan(ll0))
            param0=normrnd(0,sd0,[1,np]);
            ll0=ll(param0) + lp(param0);
        end
        if gethessian == 1

            [fit(i, :), neg_lups(i), ~, ~, ~, hes{i}] = fminunc(@(x) -1*(ll(x) + lp(x)), param0, options);

        else
            %             try
            if model.use_bads==1
                [fit(i, :), neg_lups(i)] = bads(@(x) -1*(ll(x) + lp(x)), param0, -6*ones(1,model.num_eff_params), 6*ones(1,model.num_eff_params));

            else

                try
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), param0, options);
                catch
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), normrnd(0,sd0,[1,np]), options);
                end

            end
            %             catch er
            %                 keyboard
            %             end
        end
    end
else

    for i = 1:nstart


        if i>1
            if i>ns_prior
                param0=normrnd(0,sd0,[1,np]);
            else
                param0=init+normrnd(0, sd, [1, np]);
            end

        else
            param0=init;
        end
        ll0=ll(param0) + lp(param0);
        while(isinf(ll0) || isnan(ll0))
            param0=normrnd(0,sd0,[1,np]);
            ll0=ll(param0) + lp(param0);
        end
        if gethessian == 1
            [fit(i, :), neg_lups(i), ~, ~, ~, hes{i}] = fminunc(@(x) -1*(ll(x) + lp(x)), param0, options);

        else
            %             try
            if model.use_bads==1
                [fit(i, :), neg_lups(i)] = bads(@(x) -1*(ll(x) + lp(x)), param0, -6*ones(1,model.num_eff_params), 6*ones(1,model.num_eff_params));

            else
                try
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), param0, options);
                catch
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), normrnd(0,sd0,[1,np]), options);
                end
            end
            %             catch er
            %                 keyboard
            %             end
        end
    end
end

model.params_phi_map = fit(find(neg_lups == min(neg_lups), 1), :);
model.map_allparams=fit;
model.map_neg_lups=neg_lups;
if gethessian == 1
    model.params_phi_hessian = hes{find(neg_lups == min(neg_lups), 1)};

end
end

function model = get_annealed_map(model, nstart,temp, gethessian, useparallel)

options = optimoptions(@fminunc, 'Display', 'iter', 'MaxFunctionEvaluations', 1e5,'MaxIterations',1e5);
np=model.num_eff_params;
if isfield(model,'init')
    init=model.init;
    sd=1e-2*model.normprior_std;
else
    init=zeros(1,np);
    sd=model.normprior_std;
end
sd0=model.normprior_std;
if isfield(model,'prop_prior')
    prop_prior=model.prop_prior;
else
    prop_prior=0.3;
end
ns_prior=floor((1-prop_prior)*nstart);
ll=@(x) (temp==0)*0+(temp~=0)*temp*model.log_likelihood(x,model);
lp=@(x) model.log_prior_theta(model.phi_theta(x,model), model);

if useparallel == 1



    parfor i = 1:nstart
        if i>1
            if i>ns_prior
                param0=normrnd(0,sd0,[1,np]);
            else
                param0=init+normrnd(0, sd, [1, np]);
            end

        else
            param0=init;
        end
        ll0=ll(param0) + lp(param0);
        while(isinf(ll0) || isnan(ll0))
            param0=normrnd(0,sd0,[1,np]);
            ll0=ll(param0) + lp(param0);
        end
        if gethessian == 1

            [fit(i, :), neg_lups(i), ~, ~, ~, hes{i}] = fminunc(@(x) - 1 * (ll(x) + lp(x)), param0, options);

        else
            %             try
            if model.use_bads==1
                [fit(i, :), neg_lups(i)] = bads(@(x) - 1 * (ll(x) + lp(x)), param0, -6*ones(1,model.num_eff_params), 6*ones(1,model.num_eff_params));

            else
                try
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), param0, options);
                catch
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), normrnd(0,sd0,[1,np]), options);
                end
            end
            %             catch er
            %                 keyboard
            %             end
        end
    end
else

    for i = 1:nstart


        if i>1
            param0=init+normrnd(0, sd, [1, np]);
        else
            param0=init;
        end
        ll0=ll(param0) + lp(param0);
        while(isinf(ll0) || isnan(ll0))
            param0=normrnd(0,sd0,[1,np]);
            ll0=ll(param0) + lp(param0);
        end
        if gethessian == 1
            [fit(i, :), neg_lups(i), ~, ~, ~, hes{i}] = fminunc(@(x) - 1 * (ll(x) + lp(x)), param0, options);

        else
            %             try
            if model.use_bads==1
                [fit(i, :), neg_lups(i)] = bads(@(x) - 1 * (ll(x) + lp(x)), param0, -6*ones(1,model.num_eff_params), 6*ones(1,model.num_eff_params));

            else

                try
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), param0, options);
                catch
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*(ll(x) + lp(x)), normrnd(0,sd0,[1,np]), options);
                end


            end
            %             catch er
            %                 keyboard
            %             end
        end
    end
end

model.params_phi_map = fit(find(neg_lups == min(neg_lups), 1), :);
model.map_allparams=fit;
model.map_neg_lups=neg_lups;
if gethessian == 1
    model.params_phi_hessian = hes{find(neg_lups == min(neg_lups), 1)};

end
end

function model = get_mle(model, nstart, gethessian, useparallel)
np=model.num_eff_params;
options = optimoptions(@fminunc, 'Display', 'iter', 'MaxFunctionEvaluations', 1e5,'MaxIterations',1e5);
if isfield(model,'init')
    init=model.init;
    sd=1e-2*model.normprior_std;
else
    init=zeros(1,np);
    sd=model.normprior_std;
end
sd0=model.normprior_std;
if isfield(model,'prop_prior')
    prop_prior=model.prop_prior;
else
    prop_prior=0.3;
end
ns_prior=floor((1-prop_prior)*nstart);
ll=@(x) model.log_likelihood(x,model);
if useparallel == 1

    parfor i = 1:nstart
        if i>1
            if i>ns_prior
                param0=normrnd(0,sd0,[1,np]);
            else
                param0=init+normrnd(0, sd, [1, np]);
            end

        else
            param0=init;
        end
        ll0=ll(param0);
        while(isinf(ll0) || isnan(ll0))
            param0=normrnd(0,sd0,[1,np]);
            ll0=ll(param0);
        end
        if gethessian == 1

            [fit(i, :), neg_lups(i), ~, ~, ~, hes{i}] = fminunc(@(x) -1*ll(x), param0, options);
        else
            if model.use_bads==1
                [fit(i, :), neg_lups(i)] = bads(@(x) -1*ll(x), 6*ones(1,model.num_eff_params));

            else
                try
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*ll(x), param0, options);
                catch
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*ll(x), normrnd(0,sd0,[1,np]), options);
                end
            end
        end
    end
else

    for i = 1:nstart
        if i>1
            if i>ns_prior
                param0=normrnd(0,sd0,[1,np]);
            else
                param0=init+normrnd(0, sd, [1, np]);
            end

        else
            param0=init;
        end
        ll0=ll(param0);
        while(isinf(ll0) || isnan(ll0))
            param0=normrnd(0,sd0,[1,np]);
            ll0=ll(param0);
        end
        if gethessian == 1
            [fit(i, :), neg_lups(i), ~, ~, ~, hes{i}] = fminunc(@(x) -1*ll(x), param0, options);
        else
            if model.use_bads==1
                [fit(i, :), neg_lups(i)] = bads(@(x) -1*ll(x), param0, -6*ones(1,model.num_eff_params), 6*ones(1,model.num_eff_params));

            else
                try
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*ll(x), param0, options);
                catch
                    [fit(i, :), neg_lups(i)] = fminunc(@(x) -1*ll(x), normrnd(0,sd0,[1,np]), options);
                end
            end
        end
    end
end

model.params_phi_mle = fit(find(neg_lups == min(neg_lups), 1), :);
model.mle_allparams=fit;
model.mle_neg_ll=neg_lups;
if gethessian == 1
    model.params_phi_hessian = hes{find(neg_lups == min(neg_lups), 1)};

end
end

function lp_theta = log_prior_theta(theta, model)
lp_theta = 0;
theta = (theta - repmat(model.params_additive_offset_eff,size(theta,1),1)) ./ repmat(model.params_multiplicative_offset_eff,size(theta,1),1);

if sum(model.params_family_eff == 1)>0
    lp_theta = lp_theta + sum(log(betapdf(theta(:,model.params_family_eff == 1), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 1),size(theta,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 1),size(theta,1),1))),2);

end
if sum(model.params_family_eff == 2)>0
    lp_theta = lp_theta + sum(log(gampdf(theta(:,model.params_family_eff == 2), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 2),size(theta,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 2),size(theta,1),1))),2);

end
if sum(model.params_family_eff == 3)>0
    lp_theta = lp_theta + sum(lognormpdf(theta(:,model.params_family_eff == 3), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 3),size(theta,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 3),size(theta,1),1)),2);

end

if sum(model.params_family_eff == 4)>0
    lp_theta = lp_theta + sum(log(lognpdf(theta(:,model.params_family_eff == 4), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 4),size(theta,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 4),size(theta,1),1))),2);


end

if sum(model.params_family_eff == 5)>0
    lp_theta = lp_theta + sum(logbetaprpdf(theta(:,model.params_family_eff == 5), ...
        repmat(model.params_hyperprior_params_eff{1}(model.params_family_eff == 5),size(theta,1),1), ...
        repmat(model.params_hyperprior_params_eff{2}(model.params_family_eff == 5),size(theta,1),1)),2);

end


if any(isinf(lp_theta) | isnan(lp_theta))
    warning('inf or nan log prior');
    lp_theta=-1e4;
    %keyboard
end
lp_theta= lp_theta - sum(log(repmat(model.params_multiplicative_offset_eff,size(theta,1),1)),2);

end

function lp_phi = log_prior_phi(phi, model)


lp_phi=sum(lognormpdf(phi,0,model.normprior_std),2);


end

function ll = log_likelihood(params_phi, model)
% try
params_theta=model.phi_theta(params_phi,model);

resp_struct1=model.simulate_prob_resp(params_theta,model);

params_theta=get_full_params(params_theta,model);


motor_noise=params_theta(40);

% for i1=1:numel(x11)
%     y11(i1,:)=logsumexp(logsumexp(log(resp_struct1{cond}.wts)+logcirc_vmpdf(deg2rad(x11(i1)*ones(size(resp_struct1{cond}.mu))),resp_struct1{cond}.mu,(resp_struct1{cond}.kap)),1),3);
% end
ll=0;
% lb1=log(2*pi)+logbesseli0_app(motor_noise);

for jj=1:numel(model.design_matrix)
    for kk=1:numel(model.data{jj}.resps)


        if model.decision_strategy==2
            wp1=reshape(resp_struct1{jj}.wts(:,kk,:),size(resp_struct1{jj}.wts,1),size(resp_struct1{jj}.wts,3));
            mu1=reshape(resp_struct1{jj}.mu(:,kk,:),size(resp_struct1{jj}.wts,1),size(resp_struct1{jj}.wts,3));
            wq1=resp_struct1{jj}.wts_quad;
            pred_resp_mu=repmat(sum(wp1.*mu1,2),1,numel(model.data{jj}.resps{kk}));
            resp1=repmat(deg2rad(model.data{jj}.resps{kk}(:)'),size(pred_resp_mu,1),1);
            ll=ll+sum(logsumexp(log(wq1)+logcirc_vmpdf(resp1,pred_resp_mu,motor_noise),1),2);
        elseif model.decision_strategy==3
            wp1=reshape(resp_struct1{jj}.wts(:,kk,:),size(resp_struct1{jj}.wts,1),size(resp_struct1{jj}.wts,3));
            mu1=reshape(resp_struct1{jj}.mu(:,kk,:),size(resp_struct1{jj}.wts,1),size(resp_struct1{jj}.wts,3));
            wq1=resp_struct1{jj}.wts_quad;
            pred_resp_mu=repmat(mu1(find(wp1==max(wp1,[],2),1)),1,numel(model.data{jj}.resps{kk}));
            resp1=repmat(deg2rad(model.data{jj}.resps{kk}(:)'),size(pred_resp_mu,1),1);
            ll=ll+sum(logsumexp(log(wq1)+logcirc_vmpdf(resp1,pred_resp_mu,motor_noise),1),2);
        elseif model.decision_strategy==1

            pred_resp_wts=repmat(reshape(resp_struct1{jj}.wts(:,kk,:).*repmat(resp_struct1{jj}.wts_quad,[1,1,size(resp_struct1{jj}.wts,3)]),size(resp_struct1{jj}.wts,1),size(resp_struct1{jj}.wts,3)),[1,1,numel(model.data{jj}.resps{kk})]);
            pred_resp_mu=repmat(reshape(resp_struct1{jj}.mu(:,kk,:),size(resp_struct1{jj}.mu,1),size(resp_struct1{jj}.mu,3)),[1,1,numel(model.data{jj}.resps{kk})]);
            pred_resp_kap=repmat(reshape(resp_struct1{jj}.kap(:,kk,:),size(resp_struct1{jj}.kap,1),size(resp_struct1{jj}.kap,3)),[1,1,numel(model.data{jj}.resps{kk})]);
            resp1=repmat(reshape(deg2rad(model.data{jj}.resps{kk}(:)),[1,1,numel(model.data{jj}.resps{kk})]),[size(pred_resp_wts,1),size(pred_resp_wts,2),1]);

            log_kap_s=kap_eff_vmcomb(log(motor_noise),log(pred_resp_kap),cos(pred_resp_mu-resp1));
            tmp=logbesseli0_app(log_kap_s,1)-(log(2*pi)+logbesseli0_app(log(motor_noise),1)+logbesseli0_app(log(pred_resp_kap),1));


            %Changed to just logsumexp since weights should always be
            %positive. Verify if error
            % tmp1=logsumexp_signed(log(abs(pred_resp_wts))+tmp,[1,2],sign(pred_resp_wts));
            tmp1=logsumexp(log(pred_resp_wts)+tmp,[1,2]);
            ll=ll+sum(tmp1,3);

            %             if ll>0
            %                   keyboard;
            %             end



            %             kap_s=(motor_noise.*pred_resp_kap)./(pred_resp_kap+motor_noise);
            %             tmp=logcirc_vmpdf(resp1,pred_resp_mu,kap_s);
            %             tmp1=logsumexp_signed(log(abs(pred_resp_wts))+tmp,1,sign(pred_resp_wts));
            %             ll=ll+sum(logsumexp_signed(real(tmp1),2,sign(isreal_vec(tmp1)-0.5)),3);
        elseif model.decision_strategy==4
            pred_resp_wts=repmat(reshape(resp_struct1{jj}.wts(:,kk,:).*repmat(resp_struct1{jj}.wts_quad,[1,1,size(resp_struct1{jj}.wts,3)]),size(resp_struct1{jj}.wts,1),size(resp_struct1{jj}.wts,3)),[1,1,numel(model.data{jj}.resps{kk})]);
            pred_resp_mu=repmat(reshape(resp_struct1{jj}.mu(:,kk,:),size(resp_struct1{jj}.mu,1),size(resp_struct1{jj}.mu,3)),[1,1,numel(model.data{jj}.resps{kk})]);
            resp1=repmat(reshape(deg2rad(model.data{jj}.resps{kk}(:)),[1,1,numel(model.data{jj}.resps{kk})]),[size(pred_resp_wts,1),size(pred_resp_wts,2),1]);
            kap_s=motor_noise;
            ll=ll+sum(logsumexp(logsumexp(log(pred_resp_wts)+logcirc_vmpdf(resp1,pred_resp_mu,kap_s),1),2),3);
            %             kap_s=sqrt(motor_noise.^2+pred_resp_kap.^2+2*motor_noise*pred_resp_kap.*cos(pred_resp_mu-deg2rad(resp1)));
            %             ll=ll+sum(logsumexp(logsumexp(log(pred_resp_wts)+log(besseli(0,kap_s))-lb1-log(besseli(0,max(eps,pred_resp_kap))),1),2),3);
        else
            pred_resp_wts=repmat(reshape(resp_struct1{jj}.wts(:,kk,:).*repmat(resp_struct1{jj}.wts_quad,[1,1,size(resp_struct1{jj}.wts,3)]),size(resp_struct1{jj}.wts,1),size(resp_struct1{jj}.wts,3)),[1,1,numel(model.data{jj}.resps{kk})]);
            pred_resp_mu=repmat(reshape(resp_struct1{jj}.mu(:,kk,:),size(resp_struct1{jj}.mu,1),size(resp_struct1{jj}.mu,3)),[1,1,numel(model.data{jj}.resps{kk})]);
            pred_resp_kap=repmat(reshape(resp_struct1{jj}.kap(:,kk,:),size(resp_struct1{jj}.kap,1),size(resp_struct1{jj}.kap,3)),[1,1,numel(model.data{jj}.resps{kk})]);
            resp1=repmat(reshape(model.data{jj}.resps{kk}(:),[1,1,numel(model.data{jj}.resps{kk})]),[size(pred_resp_wts,1),size(pred_resp_wts,2),1]);
            kap_s=(motor_noise.*pred_resp_kap*nsamp)./(pred_resp_kap*nsamp+motor_noise);
            ll=ll+sum(logsumexp(logsumexp(log(pred_resp_wts)+logcirc_vmpdf(deg2rad(resp1),pred_resp_mu,kap_s),1),2),3);
        end
    end
end

% catch er
%     keyboard
% end
end
function lup = log_unnorm_post(params_phi, model)
lup = model.log_likelihood(params_phi, model) + model.log_prior_phi(params_phi,model);
end



function theta = get_full_params(theta0, model)

theta = zeros(1, model.num_params);

theta(model.set_default) = model.default_values;
theta(setdiff([1:model.num_params], model.set_default)) = theta0;

end

function resp_struct = simulate_prob_resp(params, model)




params=get_full_params(params,model);
num_inputs=numel(model.design_matrix{1}.eps_green(:,1));
sig_pg_2=(params(9)).^2;
sig_g_2=sig_pg_2./params(1);
sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];

inds=cartprod([1:model.npts_quad],[1:model.npts_quad],[1:model.npts_quad],[1:model.npts_quad]);
wts=(0.5.^4).*prod([model.wts_leg(inds(:,1)),model.wts_leg(inds(:,2)),model.wts_leg(inds(:,3)),model.wts_leg(inds(:,4))],2);
npts_quad_eff=size(inds,1);



for jj=1:numel(model.design_matrix)



    id1=sig_id(2,find(sig_id(1,:)==model.design_matrix{jj}.num_groups,1));
    if sig_id(1,id1)==0

        sig_pr_2_4=exp(log(sig_pg_2)+2*((params(10))+params(13)));
        sig_r_2_4=sig_pr_2_4./params(5);
        sig_r_2=exp(log(sig_r_2_4)+2*params(7));
    else
        sig_pr_2=exp(log(sig_pg_2)+2*((params(10))+((id1~=1)*params(10-1+id1))));
        sig_r_2=sig_pr_2./params(1+id1);
    end


    o_bar_green_x=norminv(repmat(0.5*model.pts_leg(inds(:,1))+0.5,1,num_inputs),repmat(model.design_matrix{jj}.eps_green(:,1)',npts_quad_eff,1),sqrt(sig_g_2));
    o_bar_green_y=norminv(repmat(0.5*model.pts_leg(inds(:,2))+0.5,1,num_inputs),repmat(model.design_matrix{jj}.eps_green(:,2)',npts_quad_eff,1),sqrt(sig_g_2));
    o_bar_red_x=norminv(repmat(0.5*model.pts_leg(inds(:,3))+0.5,1,num_inputs),repmat(model.design_matrix{jj}.eps_red(:,1)',npts_quad_eff,1),sqrt(sig_r_2));
    o_bar_red_y=norminv(repmat(0.5*model.pts_leg(inds(:,4))+0.5,1,num_inputs),repmat(model.design_matrix{jj}.eps_red(:,2)',npts_quad_eff,1),sqrt(sig_r_2));

    resp_struct{jj}=p_ch_o(params,o_bar_green_x,o_bar_green_y,o_bar_red_x,o_bar_red_y,model.stds,model.kaps,model.beta_stds_greater_than_2,model.beta_stds_less_than_0p5,model.design_matrix{jj}.num_groups,model.tie,model.add_noise_01);
    %         resp_struct{jj}.wts=(resp_struct{jj}.wts).*(repmat(wp,[1,size(resp_struct{jj}.wts,2),size(resp_struct{jj}.wts,3)]));
    resp_struct{jj}.wts_quad=wts;

end
end
function resp_struct = simulate_prob_resp_pred(params, model,cond_num)

params=get_full_params(params,model);
num_inputs=numel(model.design_matrix_pred{1}.eps_green(:,1));




sig_pg_2=(params(9)).^2;
sig_g_2=sig_pg_2./params(1);
sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];




jj=cond_num;


inds=cartprod([1:model.npts_quad],[1:model.npts_quad],[1:model.npts_quad],[1:model.npts_quad]);
wts=(0.5.^4).*prod([model.wts_leg(inds(:,1)),model.wts_leg(inds(:,2)),model.wts_leg(inds(:,3)),model.wts_leg(inds(:,4))],2);
npts_quad_eff=size(inds,1);





id1=sig_id(2,find(sig_id(1,:)==model.design_matrix_pred{jj}.num_groups,1));
if sig_id(1,id1)==0

    sig_pr_2_4=exp(log(sig_pg_2)+2*((params(10))+params(13)));
    sig_r_2_4=sig_pr_2_4./params(5);
    sig_r_2=exp(log(sig_r_2_4)+2*params(7));
else
    sig_pr_2=exp(log(sig_pg_2)+2*((params(10))+((id1~=1)*params(10-1+id1))));
    sig_r_2=sig_pr_2./params(1+id1);
end





o_bar_green_x=norminv(repmat(0.5*model.pts_leg(inds(:,1))+0.5,1,num_inputs),repmat(model.design_matrix_pred{jj}.eps_green(:,1)',npts_quad_eff,1),sqrt(sig_g_2));
o_bar_green_y=norminv(repmat(0.5*model.pts_leg(inds(:,2))+0.5,1,num_inputs),repmat(model.design_matrix_pred{jj}.eps_green(:,2)',npts_quad_eff,1),sqrt(sig_g_2));
o_bar_red_x=norminv(repmat(0.5*model.pts_leg(inds(:,3))+0.5,1,num_inputs),repmat(model.design_matrix_pred{jj}.eps_red(:,1)',npts_quad_eff,1),sqrt(sig_r_2));
o_bar_red_y=norminv(repmat(0.5*model.pts_leg(inds(:,4))+0.5,1,num_inputs),repmat(model.design_matrix_pred{jj}.eps_red(:,2)',npts_quad_eff,1),sqrt(sig_r_2));

resp_struct=p_ch_o(params,o_bar_green_x,o_bar_green_y,o_bar_red_x,o_bar_red_y,model.stds,model.kaps,model.beta_stds_greater_than_2,model.beta_stds_less_than_0p5,model.design_matrix_pred{jj}.num_groups,model.tie,model.add_noise_01);
% resp_struct.wts=(resp_struct.wts).*(repmat(wp,[1,size(resp_struct.wts,2),size(resp_struct.wts,3)]));
resp_struct.wts_quad=wts;
% end
end

function resp_struct = p_ch_o(params,o_bar_green_x,o_bar_green_y,o_bar_red_x,o_bar_red_y,stds,kaps,beta_stds_greater_than_2,beta_stds_less_than_0p5,ngroup2,tie,add_noise_01)

sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];

id1=sig_id(2,find(sig_id(1,:)==ngroup2,1));
sig_pg_2=(params(9)).^2;


if sig_id(1,id1)==0
    sig_pr_2=exp(log(sig_pg_2)+2*((params(10))+(params(13))+((id1~=1)*params(10-1+id1))));
    sig_pgr_2=exp(log(sig_pg_2)+2*((params(10+6))+(params(19))+((id1~=1)*params(10-1+6+id1))));
    sig_pr_2_4=exp(log(sig_pg_2)+2*((params(10))+params(13)));
    sig_r_2_4=sig_pr_2_4./params(5);
    sig_r_2=exp(log(sig_r_2_4)+2*params(7));
else
    sig_pr_2=exp(log(sig_pg_2)+2*((params(10))+((id1~=1)*params(10-1+id1))));
    sig_pgr_2=exp(log(sig_pg_2)+2*((params(10+6))+((id1~=1)*params(10-1+6+id1))));
    sig_r_2=sig_pr_2./params(1+id1);
end


sig_g_2=sig_pg_2./params(1);

alp_g=params(22);


if id1==1
    alp_r=wrap_to_01_noise(alp_g+params(23),alp_g,add_noise_01);
    alp_gr=wrap_to_01_noise(alp_g+params(23+6),alp_g,add_noise_01);
    wrap_noise1=@(x) x;
    wrap_noise2=@(x) x;
elseif sig_id(1,id1)==0
    alp_r=wrap_to_01_noise(alp_g+params(23),alp_g,add_noise_01);
    alp_gr=wrap_to_01_noise(alp_g+params(23+6),alp_g,add_noise_01);
    wrap_noise1=@(x) wrap_to_01_noise(x,alp_r,add_noise_01);
    wrap_noise2=@(x) wrap_to_01_noise(x,alp_gr,add_noise_01);
    alp_r=wrap_noise1(alp_r+params(26));
    alp_gr=wrap_noise2(alp_gr+params(32));
    wrap_noise1=@(x) wrap_to_01_noise(x,alp_r,add_noise_01);
    wrap_noise2=@(x) wrap_to_01_noise(x,alp_gr,add_noise_01);

else
    alp_r=wrap_to_01_noise(alp_g+params(23),alp_g,add_noise_01);
    alp_gr=wrap_to_01_noise(alp_g+params(23+6),alp_g,add_noise_01);
    wrap_noise1=@(x) wrap_to_01_noise(x,alp_r,add_noise_01);
    wrap_noise2=@(x) wrap_to_01_noise(x,alp_gr,add_noise_01);
end





alp=[alp_g,wrap_noise1(alp_r+(id1~=1)*params(22+id1)),wrap_noise2(alp_gr+(id1~=1)*params(28+id1))];



sig_e_2=params(8).^2;

beta_gr=params(35);
lapse_rate=params(36);
lapse_mu=params(37);
lapse_kap=params(38);
bias=params(39);



model_params=[sig_g_2,sig_r_2,sig_e_2,sig_pg_2,sig_pr_2,sig_pgr_2,alp,beta_gr];


gx=o_bar_green_x;
gy=o_bar_green_y;
rx=o_bar_red_x;
ry=o_bar_red_y;
sz=size(gx);
gx=gx(:);
gy=gy(:);
rx=rx(:);
ry=ry(:);

[prs,sts]=p_struct_expand(model_params,[gx,gy],[rx,ry]);



% prs=prs./repmat(sum(prs,2),1,size(prs,2));
resp_struct.wts(:,:,1)=lapse_rate*ones(sz);
resp_struct.mu(:,:,1)=lapse_mu*ones(sz);
resp_struct.kap(:,:,1)=lapse_kap*ones(sz);

id_comp1=find(sts(:,1)==1);

for i=1:numel(id_comp1)
    resp_struct.wts(:,:,1+i)=(1-lapse_rate)*reshape(prs(:,id_comp1(i)),sz);
    [mu,sig_2]=p_vgr_o_expand(model_params,[gx,gy],[rx,ry],sts(id_comp1(i),1),sts(id_comp1(i),2),sts(id_comp1(i),3),sts(id_comp1(i),4));
    [thets1,kaps1]=map_gaussvel_kapdir_paraminc(mu,sqrt(sig_2),stds,kaps,beta_stds_greater_than_2,beta_stds_less_than_0p5);
    resp_struct.mu(:,:,1+i)=reshape(wrapToPi(bias+thets1),sz);
    resp_struct.kap(:,:,1+i)=reshape(kaps1,sz);
end

id_comp2=find(sts(:,1)==0 & sts(:,3)==1 & sts(:,4)==1);

for i=1:numel(id_comp2)
    resp_struct.wts(:,:,1+numel(id_comp1)+i)=(1-lapse_rate)*reshape(prs(:,id_comp2(i)),sz);
    [mu,sig_2]=p_vrgr_o_expand(model_params,[gx,gy],[rx,ry],sts(id_comp2(i),1),sts(id_comp2(i),2),sts(id_comp2(i),3),sts(id_comp2(i),4));
    [thets1,kaps1]=map_gaussvel_kapdir_paraminc(mu,sqrt(sig_2),stds,kaps,beta_stds_greater_than_2,beta_stds_less_than_0p5);
    resp_struct.mu(:,:,1+numel(id_comp1)+i)=reshape(wrapToPi(bias+thets1),sz);
    resp_struct.kap(:,:,1+numel(id_comp1)+i)=reshape(kaps1,sz);
end

id_comp3=find(~((sts(:,1)==0 & sts(:,3)==1 & sts(:,4)==1) | (sts(:,1)==1)));


resp_struct.wts(:,:,1+numel(id_comp1)+numel(id_comp2)+1)=zeros(size(resp_struct.wts,1),size(resp_struct.wts,2),1);

for i=1:numel(id_comp3)
    resp_struct.wts(:,:,1+numel(id_comp1)+numel(id_comp2)+1)=resp_struct.wts(:,:,1+numel(id_comp1)+numel(id_comp2)+1)+((1-lapse_rate)*reshape(prs(:,id_comp3(i)),sz));
end

resp_struct.mu(:,:,1+numel(id_comp1)+numel(id_comp2)+1)=0*ones(sz);
resp_struct.kap(:,:,1+numel(id_comp1)+numel(id_comp2)+1)=0*ones(sz);


end



function s=get_params_struct(params,model)




params=model.phi_theta(params,model);
params=get_full_params(params,model);


sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];




s.sig_pg_2=params(9).^2;


s.sig_g_2=s.sig_pg_2./params(1);
[~,s.angstd_g]=map_gaussvel_kapdir([1,0],sqrt(s.sig_g_2));
s.angstd_g=rad2deg(sqrt(1./s.angstd_g));






for nn=1:size(sig_id,2)

    id1=sig_id(2,nn);


    if sig_id(1,nn)==0
        s.sig_pr_2(nn)=exp(log(s.sig_pg_2)+2*((params(10))+(params(13))+((id1~=1)*params(10-1+id1))));
        s.sig_pgr_2(nn)=exp(log(s.sig_pg_2)+2*((params(10+6))+(params(19))+((id1~=1)*params(10-1+6+id1))));
        s.sig_r_2(nn)=exp(log(s.sig_r_2(4))+2*params(7));
    else
        s.sig_pr_2(nn)=exp(log(s.sig_pg_2)+2*((params(10))+((id1~=1)*params(10-1+id1))));
        s.sig_pgr_2(nn)=exp(log(s.sig_pg_2)+2*((params(10+6))+((id1~=1)*params(10-1+6+id1))));
        s.sig_r_2(nn)=s.sig_pr_2(nn)./params(1+id1);
    end

    [~,s.angstd_r(nn)]=map_gaussvel_kapdir([1,0],sqrt(s.sig_r_2(nn)));
    s.angstd_r(nn)=rad2deg(sqrt(1./s.angstd_r(nn)));

    alp_g=params(22);



    if id1==1
        alp_r=wrap_to_01_noise(alp_g+params(23),alp_g,model.add_noise_01);
        alp_gr=wrap_to_01_noise(alp_g+params(23+6),alp_g,model.add_noise_01);
        wrap_noise1=@(x) x;
        wrap_noise2=@(x) x;
    elseif sig_id(1,id1)==0
        alp_r=wrap_to_01_noise(alp_g+params(23),alp_g,model.add_noise_01);
        alp_gr=wrap_to_01_noise(alp_g+params(23+6),alp_g,model.add_noise_01);
        wrap_noise1=@(x) wrap_to_01_noise(x,alp_r,model.add_noise_01);
        wrap_noise2=@(x) wrap_to_01_noise(x,alp_gr,model.add_noise_01);
        alp_r=wrap_noise1(alp_r+params(26));
        alp_gr=wrap_noise2(alp_gr+params(32));
        wrap_noise1=@(x) wrap_to_01_noise(x,alp_r,model.add_noise_01);
        wrap_noise2=@(x) wrap_to_01_noise(x,alp_gr,model.add_noise_01);
    else
        alp_r=wrap_to_01_noise(alp_g+params(23),alp_g,model.add_noise_01);
        alp_gr=wrap_to_01_noise(alp_g+params(23+6),alp_g,model.add_noise_01);
        wrap_noise1=@(x) wrap_to_01_noise(x,alp_r,model.add_noise_01);
        wrap_noise2=@(x) wrap_to_01_noise(x,alp_gr,model.add_noise_01);
    end


    s.alp(nn,:)=[alp_g,wrap_noise1(alp_r+(id1~=1)*params(22+id1)),wrap_noise2(alp_gr+(id1~=1)*params(28+id1))];

end



s.sig_e_2=params(8).^2;

s.beta_gr=params(35);
s.lapse_rate=params(36);
s.lapse_mu_deg=wrapTo180(rad2deg(params(37)));
s.lapse_kap=params(38);
s.bias_deg=wrapTo180(rad2deg(params(39)));
s.motor_noise=params(40);

s.motornoise_ang=rad2deg(sqrt(1./s.motor_noise));





end