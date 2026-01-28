clear all
%%%%%%%%%%%%%% setting params for the model %%%%%%%%%%%%%
point = linspace(-180,180,361);
gap = 4;

dir_vec = point( 1: gap: end);

%%% Chris dir
load('30neuron_params.mat')
dir_vec = AllParams.centDirTuns{1, 1}.CDir';


n1_sd =  1.2612;
n1_m = 0.5806;
n2_sd =  3.8363;
n2_m = 1.9620;
n3_sd =  5.2716;
n3_m = 5.9059;
speed_vec = [n1_m-(n1_sd/2.2), n1_m-(n1_sd/4), n1_m, n1_m+n1_sd, n1_m+(2*n1_sd);...
            n1_m-(n1_sd/2.2), n1_m-(n1_sd/4), n1_m, n1_m+n1_sd, n1_m+(2*n1_sd);...
            n1_m-(n1_sd/2.2), n1_m-(n1_sd/4), n1_m, n1_m+n1_sd, n1_m+(2*n1_sd);...
            n2_m-(n2_sd/2), n2_m-(n2_sd/4), n2_m, n2_m+n2_sd, n2_m+(2*n2_sd);...
            n2_m-(n2_sd/2), n2_m-(n2_sd/4), n2_m, n2_m+n2_sd, n2_m+(2*n2_sd);...
            n2_m-(n2_sd/2), n2_m-(n2_sd/4), n2_m, n2_m+n2_sd, n2_m+(2*n2_sd);...
            n3_m-(n3_sd/2), n3_m-(n3_sd/4), n3_m, n3_m+n3_sd, n3_m+(2*n3_sd);...
            n3_m-(n3_sd/2), n3_m-(n3_sd/4), n3_m, n3_m+n3_sd, n3_m+(2*n3_sd);...
            n3_m-(n3_sd/2), n3_m-(n3_sd/4), n3_m, n3_m+n3_sd, n3_m+(2*n3_sd)];  %[1, 2, 4, 8, 16];% for Sabya's exp:[0.5, 1, 1.5]; for exploration: [0.1,1,2,7,17]% logspace(-0.5, 1.4, 5); % preferred is at 7
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


varType = 2;
causalStruct = [0,2,4,5]; % 0 means mixture based on parameters, 1-5 are the 4 main different structures and 5 is the full independent percept which equals the 3rd stucture
lenCaus = length(causalStruct);
% new parameters to account for behavioral data
num_trials=1000;
ndots_all=10;   % Can be 1,2,3,5,10
subid_all=[1,2,3,4,5];    % Can be 1,2,3,4,5

load('models10_all.mat');
noise = [1,20];

% neuron params
% neuronTypes = {{3, 0, 0.4, 0.1, 0.5913},...
%                 {3, 0, 0.4, 1, 0.5913},...
%                 {3, 0, 0.4, 0.3, 0.5913},...
%                 {3, 0, 0.4, 0.06, 1},...
%                {3, 0, 0.4, 0.07, 0.1},...
%                {3, 0, 8, 0.1, 0.5913},...
%                 {3, 0, 8, 1, 0.5913},...
%                 {3, 0, 8, 0.3, 0.5913},...
%                 {3, 0, 8, 0.06, 1},...
%                {3, 0, 8, 0.07, 0.1}};
neuronTypes = {{3, 0, 0.5, 1, 0.5913},...
                {3, 0, 2, 1, 0.5913},...
                {3, 0, 8, 1, 0.5913},...
                {3, 0, 0.5, 0.3, 0.5913},...
                {3, 0, 2, 0.3, 0.5913},...
                {3, 0, 8, 0.3, 0.5913},...
                {3, 0, 0.5, 0.1,0.5913},...
                {3, 0, 2, 0.1, 0.5913},...
                {3, 0, 8, 0.1, 0.5913}};
%%%%%%%%%%%%%%%%%%%%%%%% model computes inference %%%%%%%%%%%
meanfire = zeros(length(neuronTypes),5,2,len_s_speed,len_c_speed,len_s,len_c);
varfire = zeros(length(neuronTypes),5,2,len_s_speed,len_c_speed,len_s,len_c);
parfor t=1:length(neuronTypes)
    neuronType = neuronTypes{t};
    for n=1:5 % loop over subject
        for ns=1:2
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
            for i=1:len_s_speed % speed center
                for j=1:len_c_speed % speed surround
                    disp([n, i, j])
                    
                    for k = 1:len_s % surround direction
                        for l = 1:len_c % center direction
        
                            if varType==1
                                [fr,~]=CI_model_percept_v2(c_dir(l), s_dir(k), c_speed(t,j), s_speed(t,i),num_trials,subid,ndots,model_params,neuronType,causalStruct(1));
                            elseif varType==2
                                [fr,~]=CI_model_retinal_v2(c_dir(l), s_dir(k), c_speed(t,j), s_speed(t,i),num_trials,subid,ndots,model_params,neuronType,causalStruct(1));
                            elseif varType==3
                                [fr,~]=CI_model_relative_v2(c_dir(l), s_dir(k), c_speed(t,j), s_speed(t,i),num_trials,subid,ndots,model_params,neuronType,causalStruct(1));
                            end
                            meanfire(t,n,ns,i,j,k,l) = mean(fr);
                            varfire(t,n,ns,i,j,k,l) = var(fr,0,"all");
                        end
                    end
                end
            end
        end
    end
end

save('Chris_fire_All_relVar_v0.mat',"-v7.3")

