function [neuron_resps_group,resps_group] = CI_model_retinal_v2( dir_c, dir_s,speed_c,speed_s,n_trials,subid,ndots,model_params,neuronType,causalStruct)

if ~exist('fr_joint','var')

    linear = neuronType{1};
    if linear == 1
        dir_kappa = 1;
        speed_slope=1;
        dir_pref=0;
        Von_Tuning = @(x,theta0,kappa) exp( kappa * (cos( (x-theta0)/180*pi ) -1 ) );
        fr_joint = @(theta1,nu) Von_Tuning( theta1, dir_pref, dir_kappa ).* speed_slope .* nu;
    elseif linear == 2

        % Median neuron
        R0= 3.4754 ; A=67.8693; alpha=0.0834; tau=-0.0040; n=0.5913*1; % new fit to neural data
        R0_dir=-0.4730;  A_dir=71.7927;  mu=14.4978;  kappa=1.4025*1; % For Cosyne poster we used mu=0.4978;
        fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu, kappa) .* abs(neuron_speed_tuning(nu, R0, A, alpha, tau, n));
    
    else
        mu_ = neuronType{2};
        kappa_ = neuronType{3};
        alpha_ = neuronType{4};
        n_ = neuronType{5};
        R0= 3.4754 ; A=67.8693;  tau=-0.0040; % new fit to neural data
        R0_dir=-0.4730;  A_dir=71.7927; % For Cosyne poster we used mu=0.4978;
        fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu_, kappa_) .* abs(neuron_speed_tuning(nu, R0, A, alpha_, tau, n_));
    end

end

v_mag_target=speed_c;
v_mag_surround=speed_s;
eps_surround=v_mag_surround.*[cosd(dir_s),sind(dir_s)];
eps_target=v_mag_target.*[cosd(dir_c),sind(dir_c)];



if ~exist('model_params','var')
    load('models10_all.mat');


    model_type=9;



    model=models_all{subid,model_type};
    params=model.params_phi_mle;
    s=model.get_params_struct(params,model);
    sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];

id1=sig_id(2,find(sig_id(1,:)==ndots,1));

model_params=[s.sig_g_2,s.sig_r_2(id1),s.sig_e_2,s.sig_pg_2,s.sig_pr_2(id1),s.sig_pgr_2(id1),s.alp(id1,:),s.beta_gr];
end




NoiseScale = 1;
model_params(1) = NoiseScale*(speed_c.^2)*model_params(1); % center
model_params(2) = NoiseScale*(speed_s.^2)*model_params(2); % surround
model_params(3) = NoiseScale*0.5*(speed_c.^2+speed_s.^2)*model_params(3); % surround
model_params(4) = NoiseScale*(speed_c.^2)*model_params(4); % center
model_params(5) = NoiseScale*(speed_s.^2)*model_params(5); % surround
model_params(6) = NoiseScale*0.5*(speed_c.^2+speed_s.^2)*model_params(6); % surround

if causalStruct==0
    v_target=p_v_patch_percept_eps(eps_target,eps_surround,model_params,n_trials);
else
    v_target=p_v_patch_percept_eps_x(eps_target,eps_surround,model_params,n_trials,causalStruct);
end

resps_group=atan2d(v_target(:,2),v_target(:,1));
speed_resps_group=sqrt(v_target(:,2).^2+v_target(:,1).^2);
wrongValsIx = (v_target(:,2)==0) & (v_target(:,1)==0);
resps_group(wrongValsIx) = -180 + 360.*rand(sum(wrongValsIx),1);
neuron_resps_group=(fr_joint(resps_group,speed_resps_group));


end
