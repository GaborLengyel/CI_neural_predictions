clear all
%%%%%%%%%%%%%% setting params for the model %%%%%%%%%%%%%
point = linspace(-180,180,361);
gap = 4;

dir_vec = point( 1: gap: end);
speed_vec = [1, 2, 4, 8, 16];% for Sabya's exp:[0.5, 1, 1.5]; for exploration: [0.1,1,2,7,17]% logspace(-0.5, 1.4, 5); % preferred is at 7
s_dir = dir_vec;
c_dir = dir_vec;
s_speed = speed_vec;
c_speed = speed_vec;

len_c = length(c_dir);
len_s = length(s_dir);
len_c_speed = length(c_speed);
len_s_speed = length(s_speed);
len_c_speed = size(c_speed,2);
len_s_speed = size(s_speed,2);


varType = 4;
causalStruct = [0,1,2,3,4,5]; % 0 means mixture based on parameters, 1-5 are the 4 main different structures and 5 is the full independent percept which equals the 3rd stucture
lenCaus = length(causalStruct);
% new parameters to account for behavioral data
num_trials=1000;
ndots_all=10;   % Can be 1,2,3,5,10
subid_all=[1,2,3,4,5];    % Can be 1,2,3,4,5

load('models10_all.mat');
noise = [1,20];

%%%%%%%%%%%%%%%%%%%%%%%% model computes inference %%%%%%%%%%%
% vel_post = zeros(lenCaus,2,len_s_speed,len_c_speed,len_s,len_c,num_trials, 2);
% dir_post = zeros(lenCaus,2,len_s_speed,len_c_speed,len_s,len_c,num_trials);
% spe_post = zeros(lenCaus,2,len_s_speed,len_c_speed,len_s,len_c,num_trials);
vel_post = zeros(len_s_speed,len_c_speed,len_s,len_c,num_trials, 2);
struct_post = zeros(len_s_speed,len_c_speed,len_s,len_c,num_trials);
dir_post = zeros(len_s_speed,len_c_speed,len_s,len_c,num_trials);
spe_post = zeros(len_s_speed,len_c_speed,len_s,len_c,num_trials);
%choosing subjects
n=2;
c=6; ns=1;%memory limit for all
%parfor c=1:4 % loop over causes
    %for ns=1:2
        ndots=ndots_all;
        subid=subid_all(n);
        model_type=9;
        model=models_all{subid,model_type};
        s=model.get_params_struct(model.params_phi_mle,model);
        sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];
        
        id1=sig_id(2,find(sig_id(1,:)==ndots,1));
        
        model_params=[s.sig_g_2*noise(ns),...
        s.sig_r_2(id1)*noise(ns),...
        s.sig_e_2,...
        s.sig_pg_2,...
        s.sig_pr_2(id1),...
        s.sig_pgr_2(id1),...
        s.alp(id1,:),...
        s.beta_gr];
        parfor i=1:len_s_speed % speed center
            for j=1:len_c_speed % speed surround
                disp([i, j])
                
                for k = 1:len_s % surround direction
                    for l = 1:len_c % center direction
    
                        % if varType==1
                        %     [vel_post(c,ns,i,j,k,l,:,:), dir_post(c,ns,i,j,k,l,:),spe_post(c,ns,i,j,k,l,:)]=CI_model_percept_post(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params,causalStruct(c));
                        % elseif varType==2
                        %     [vel_post(c,ns,i,j,k,l,:,:),dir_post(c,ns,i,j,k,l,:),spe_post(c,ns,i,j,k,l,:)]=CI_model_retinal_post(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params,causalStruct(c));
                        % elseif varType==3
                        %     [vel_post(c,ns,i,j,k,l,:,:),dir_post(c,ns,i,j,k,l,:),spe_post(c,ns,i,j,k,l,:)]=CI_model_relative_post(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params,causalStruct(c));
                        % end
                        if varType==1
                            [vel_post(i,j,k,l,:,:), dir_post(i,j,k,l,:),spe_post(i,j,k,l,:)]=CI_model_percept_post(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params,causalStruct(c));
                        elseif varType==2
                            [vel_post(i,j,k,l,:,:),dir_post(i,j,k,l,:),spe_post(i,j,k,l,:)]=CI_model_retinal_post(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params,causalStruct(c));
                        elseif varType==3
                            [vel_post(i,j,k,l,:,:), dir_post(i,j,k,l,:), spe_post(i,j,k,l,:)]=CI_model_relative_post(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params,causalStruct(c));
                            [struct_post(i,j,k,l,:)]=CI_model_relative_post_struct(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params);
                        elseif varType==4
                            [vel_post(i,j,k,l,:,:), dir_post(i,j,k,l,:), spe_post(i,j,k,l,:)]=CI_model_group_post(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params,causalStruct(c));
                            %[struct_post(i,j,k,l,:)]=CI_model_group_post_struct(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params);
                        end
    
                    end
                end
            end
        end
    %end
%end

save('post_vel_grpVar_subj2_struct5.mat', "vel_post", "dir_post", "spe_post", "-v7.3")

%save('post_struct_relVar_subj2.mat',"struct_post","-v7.3")