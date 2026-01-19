
point = linspace(-180,180,361);
gap = 8; %8

dir_vec = point( 1: gap: end);

speed_vec = [1];%[1.75 3.5 7 14 28]; %
s_dir = dir_vec;
c_dir = dir_vec;
s_speed = speed_vec(1);
c_speed = speed_vec(1);



len_c = length(c_dir);
len_s = length(s_dir);
len_c_speed = length(c_speed);
len_s_speed = length(s_speed);

% new parameters to account for behavioral data
num_trials=1e3;
ndots_all=10;   % Can be 1,2,3,5,10
subid_all=1;    % Cab be 1,2,3,4,5



load('models10_all.mat');


for i1=1:numel(subid_all) % loop over subject
    for j1=1:numel(ndots_all) % loops over # of dots
        ndots=ndots_all(j1);
        subid=subid_all(i1);
        model_type=9;
        model=models_all{subid,model_type};


        s=model.get_params_struct(model.params_phi_mle,model);
        % params=model.phi_theta(model.params_phi_mle,model);
        % params=get_full_params(params,model);
        sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];

        id1=sig_id(2,find(sig_id(1,:)==ndots,1));

        model_params=[s.sig_g_2,s.sig_r_2(id1),s.sig_e_2,s.sig_pg_2,s.sig_pr_2(id1),s.sig_pgr_2(id1),s.alp(id1,:),s.beta_gr];
        for k=1:len_c_speed % speed center
            for l=1:len_s_speed % speed surround
                for j = 1:len_s % surround direction
                    j
                    for i = 1:len_c % center direction

                        [neural_pred{i1,j1}(i,j,k,l,:),behavioral_pred{i1,j1}(i,j,k,l,:)]=CI_model_relative_v2(c_dir(i), s_dir(j), c_speed(k), s_speed(l),num_trials,subid,ndots,model_params);

                        neural_pred_mu{i1,j1}(i,j,k,l)=mean(neural_pred{i1,j1}(i,j,k,l,:),5);
                        (len_c * (j-1)+ i)/ (len_c * len_s) * 100;
                    end
                end
            end
        end
    end
end


%%
