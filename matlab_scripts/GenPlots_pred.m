clear all
close all
%%%%%%%%%%%%%% setting params for the model %%%%%%%%%%%%%
point = linspace(-180,180,361);
gap = 4;

dir_vec = point( 1: gap: end);

speed_vec = [0.1, 1, 2, 7, 17];%logspace(-0.5, 1.4, 5);
s_dir = dir_vec;
c_dir = dir_vec;
s_speed = speed_vec;
c_speed = speed_vec;

len_c = length(c_dir);
len_s = length(s_dir);
len_c_speed = length(c_speed);
len_s_speed = length(s_speed);

%neuronType = {4, 90, -0.05, 0.1};
neuronType = {2, 0, -0.5, 0.1};
varType = 3;
noiseLevel = [0.0001, 1, 10000];

% new parameters to account for behavioral data
num_trials=100;
ndots_all=10;   % Can be 1,2,3,5,10
subid_all=1;    % Can be 1,2,3,4,5

load('models10_all.mat');
%% 

%%%%%%%%%%%%%%%%%%%%%%%% model computes inference %%%%%%%%%%%

ndots=ndots_all;
subid=subid_all;
model_type=9;
model=models_all{subid,model_type};
s=model.get_params_struct(model.params_phi_mle,model);
sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];

id1=sig_id(2,find(sig_id(1,:)==ndots,1));

% sig_g_2 is the center uncertainty (g for green dots) = 4.9e-06 
% sig_r_2 is the surround uncertainty (the argument is the different values
% for different number of surround patches) = 7.57e-07
% sig_e_2 is the computational noise = 1.12e-05
% sig_pg_2 is the prior width for green dots = 0.3038 pr is for red dots
% =0.0025 and pgr for the group = 0.0288
% alp is the weight on delta = 
% beta is prior probability over causal structures
neural_pred = zeros(4,length(noiseLevel),length(noiseLevel),len_s_speed,len_c_speed,len_s,len_c,num_trials);
neural_pred_mu = zeros(4,length(noiseLevel),length(noiseLevel),len_s_speed,len_c_speed,len_s,len_c);

parfor CS=1:4
    for nlS=1:3%length(noiseLevel)
        uncertS = s.sig_r_2(id1)*noiseLevel(nlS); 
        for nlC=1:3%length(noiseLevel)
            uncertC = s.sig_g_2*noiseLevel(nlC);
            model_params=[uncertC,uncertS,...
                        s.sig_r_2(id1),...
                        s.sig_e_2,...
                        s.sig_pg_2,...
                        s.sig_pr_2(id1),...
                        s.sig_pgr_2(id1),...
                        s.alp(id1,:),...
                        s.beta_gr];

            for i=1:len_s_speed % speed center
                for j=1:len_c_speed % speed surround
                    disp([CS, nlS, nlC, i, j])
                    for k = 1:len_s % surround direction
                        for l = 1:len_c % center direction
                            % Neural and behavioral predicts across trials
                            if varType==1
                                [neural_pred(CS,nlS,nlC,i,j,k,l,:),~]=CI_model_percept_v2(c_dir(l),...
                                                                                s_dir(k),...
                                                                                c_speed(j),...
                                                                                s_speed(i),...
                                                                                num_trials,...
                                                                                subid,...
                                                                                ndots,...
                                                                                model_params,...
                                                                                neuronType,...
                                                                                CS);
                                neural_pred_mu(CS,nlS,nlC,i,j,k,l)=mean(neural_pred(CS,nlS,nlC,i,j,k,l,:),8);
                            elseif varType==2
                                [neural_pred(CS,nlS,nlC,i,j,k,l,:),~]=CI_model_retinal_v2(c_dir(l),...
                                                                                s_dir(k),...
                                                                                c_speed(j),...
                                                                                s_speed(i),...
                                                                                num_trials,...
                                                                                subid,...
                                                                                ndots,...
                                                                                model_params,...
                                                                                neuronType,...
                                                                                CS);
                                neural_pred_mu(CS,nlS,nlC,i,j,k,l)=mean(neural_pred(CS,nlS,nlC,i,j,k,l,:),8);
                            elseif varType==3
                                [neural_pred(CS,nlS,nlC,i,j,k,l,:),~]=CI_model_relative_v2(c_dir(l),...
                                                                                s_dir(k),...
                                                                                c_speed(j),...
                                                                                s_speed(i),...
                                                                                num_trials,...
                                                                                subid,...
                                                                                ndots,...
                                                                                model_params,...
                                                                                neuronType,...
                                                                                CS);
                                neural_pred_mu(CS,nlS,nlC,i,j,k,l)=mean(neural_pred(CS,nlS,nlC,i,j,k,l,:),8);
                            end
                            %(len_c * (j-1)+ i)/ (len_c * len_s) * 100
                        end
                    end
                end
            end
        end
    end
end
%save('neural_pred_median_neuron_2.mat',"-v7.3")
