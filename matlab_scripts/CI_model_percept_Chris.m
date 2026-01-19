function [neuron_resps_group,resps_group] = CI_model_percept_Chris( dir_c, dir_s,speed_c,speed_s,n_trials,subid,ndots,model_params,causalStruct,dirtun,speedtun,tunType)
    
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
speed_resps_group=sqrt(v_target(:,2).^2+v_target(:,1).^2);
wrongValsIx = (v_target(:,2)==0) & (v_target(:,1)==0);
resps_group(wrongValsIx) = -180 + 360.*rand(sum(wrongValsIx),1);

if (tunType==1) || (tunType==3)
    fr_joint = @(theta1,nu) wrapped_gauss_func_uni(dirtun,theta1) .* abs(gammafunc(speedtun,nu));
    neuron_resps_group=(fr_joint(resps_group,speed_resps_group));
else
    xd = [-180,-135,-90,-45,0,45,90,135,180];
    yd = dirtun;
    xd_fine = linspace(-180, 180, 1000);
    yd_pchip = pchip(xd, yd, xd_fine);
    xs = speedtun(:,1);
    ys = speedtun(:,2);
    xs_fine = linspace(0, max(xs), 1000);
    ys_pchip = pchip(xs, ys, xs_fine);
    YIS = sum(xs_fine<speed_resps_group,2);
    YIS(YIS==0) = 1;
    rS = ys_pchip(YIS);
    
    YID = sum(xd_fine<resps_group,2);
    YID(YID==0) = 1;
    rD = yd_pchip(YID);
    neuron_resps_group=(rD.*rS);
end


end
