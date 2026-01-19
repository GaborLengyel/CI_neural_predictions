function [struct_probs] = CI_model_relative_post_struct( dir_c, dir_s,speed_c,speed_s,n_trials,subid,ndots,model_params)

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

[struct_probs]=p_v_patch_percept_eps_y(eps_target,eps_surround,model_params,n_trials);

