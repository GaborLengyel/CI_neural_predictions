clear all
%%%%%%%%%%%%%% setting params for the model %%%%%%%%%%%%%
point = linspace(-180,180,361);
gap = 4;

dir_vec = point( 1: gap: end);

speed_vec = [0.9157, 3.65, 7.0859, 10, 17];% for Sabya's exp:[0.5, 1, 1.5]; for exploration: [0.1,1,2,7,17]% logspace(-0.5, 1.4, 5); % preferred is at 7
s_dir = dir_vec;
c_dir = dir_vec;
s_speed = speed_vec;
c_speed = speed_vec;

len_c = length(c_dir);
len_s = length(s_dir);
len_c_speed = length(c_speed);
len_s_speed = length(s_speed);

neuronType = {2, 0, -0.5, 0.1};
varType = 3;
causalStruct = [2,4];

% new parameters to account for behavioral data
num_trials=1e3;
ndots_all=10;   % Can be 1,2,3,5,10
subid_all=[1,2,3,4,5];    % Can be 1,2,3,4,5

load('models10_all.mat');
%%
% Brian's experiment
% s_speed = [1.54508497187474
%         2.93892626146237
%         4.04508497187474
%         4.75528258147577
%         5];
% c_speed = [5];
% len_c_speed = length(c_speed);
% len_s_speed = length(s_speed);
%%
% Sabya's experiment
% c_speed = sqrt(1+(tan(deg2rad([0,2.5,5,10,20,45])).^2));
% s_speed = [1];
% len_c_speed = length(c_speed);
% len_s_speed = length(s_speed);
%% 

%%%%%%%%%%%%%%%%%%%%%%%% model computes inference %%%%%%%%%%%
neural_pred = zeros(5,4,len_s_speed,len_c_speed,len_s,len_c,num_trials);
neural_pred_mu = zeros(5,4,len_s_speed,len_c_speed,len_s,len_c);
%c=1;
parfor n=1:5 % loop over subject
    for c=1:2
    ndots=ndots_all;
    subid=subid_all(n);
    model_type=9;
    model=models_all{subid,model_type};
    s=model.get_params_struct(model.params_phi_mle,model);
    sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];

    id1=sig_id(2,find(sig_id(1,:)==ndots,1));

    model_params=[s.sig_g_2,...
        s.sig_r_2(id1),...
        s.sig_e_2,...
        s.sig_pg_2,...
        s.sig_pr_2(id1),...
        s.sig_pgr_2(id1),...
        s.alp(id1,:),...
        s.beta_gr];
    
    for i=1:len_s_speed % speed center
        for j=1:len_c_speed % speed surround
            disp([n, c, i, j])
            
            for k = 1:len_s % surround direction
                for l = 1:len_c % center direction

                    if varType==1
                        [neural_pred(n,c,i,j,k,l,:),~]=CI_model_percept_v2(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params,neuronType,causalStruct(c));
                        neural_pred_mu(n,c,i,j,k,l)=mean(neural_pred(n,c,i,j,k,l,:),7);
                    elseif varType==2
                        [neural_pred(n,c,i,j,k,l,:),~]=CI_model_retinal_v2(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params,neuronType,causalStruct(c));
                        neural_pred_mu(n,c,i,j,k,l)=mean(neural_pred(n,c,i,j,k,l,:),7);
                    elseif varType==3
                        [neural_pred(n,c,i,j,k,l,:),~]=CI_model_relative_v2(c_dir(l), s_dir(k), c_speed(j), s_speed(i),num_trials,subid,ndots,model_params,neuronType,causalStruct(c));
                        neural_pred_mu(n,c,i,j,k,l)=mean(neural_pred(n,c,i,j,k,l,:),7);
                    end
                    %(len_c * (j-1)+ i)/ (len_c * len_s) * 100;

                end
            end
        end
    end
end
end
save('neural_pred_subj_opposite_neuron_CS_stim1_relVar.mat',"-v7.3")
% %%
% C = ones(len_c,len_c);
% %B = zeros(len_c,len_c);
% %[C,S] = meshgrid(xr,xr);
% BC = zeros(len_c*len_s,len_c);
% BS = zeros(len_c*len_s,len_s);
% for i=1:len_c
%     i1=(i-1)*len_c+1;
%     i2 = (i1-1)+len_c;
%     BC(i1:i2,i) = C(:,i);
%     B = zeros(len_c,1);
%     B(i)=1;
%     BS(:,i) = repmat(B,len_c,1);
% end
% X = [BC, BS];
% neural_pred_mu_fit = zeros(5,len_s_speed,len_c_speed,len_c+len_s);
% for n=1:5 % loop over subject
%     for i=1:len_s_speed % speed center
%         for j=1:len_c_speed % speed surround
%             neural_pred_mu_fit(n,i,j,:)=X\reshape(neural_pred_mu(n,i,j,:,:),[len_c*len_s,1]);
%         end
%     end
% end