function [v_target,resps_group,speed_resps_group] = CI_model_percept_post( dir_c, dir_s,speed_c,speed_s,n_trials,subid,ndots,model_params,causalStruct)

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
    [~,~,~,v_target]=p_v_patch_percept_eps(eps_target,eps_surround,model_params,n_trials);
else
    [~,~,~,v_target]=p_v_patch_percept_eps_x(eps_target,eps_surround,model_params,n_trials,causalStruct);
end


resps_group=atan2d(v_target(:,2),v_target(:,1));
resps_group((v_target(:,2)==0) & (v_target(:,1)==0)) = NaN(1);

speed_resps_group=sqrt(v_target(:,2).^2+v_target(:,1).^2);

end
