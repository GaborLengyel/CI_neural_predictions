clear all
%%%%%%%%%%%%%% setting params for the model %%%%%%%%%%%%%
point = linspace(-180,180,361);
gap = 6;

dir_vec = point( 1: gap: end);

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
c_dir = [0,90,180];
s_dir = dir_vec;
s_speed = [0 n1_m;...
            0, n1_m;...
            0, n1_m;...
            0, n2_m;...
            0, n2_m;...
            0, n2_m;...
            0, n3_m;...
            0, n3_m;...
            0, n3_m];
%c_speed = speed_vec;
c_speed = [n1_m;...
            n1_m;...
             n1_m;...
            n2_m;...
             n2_m;...
             n2_m;...
             n3_m;...
             n3_m;...
             n3_m];
len_c = length(c_dir);
len_s = length(s_dir);
%len_c_speed = length(c_speed);
%len_s_speed = length(s_speed);
len_c_speed = size(c_speed,2);
len_s_speed = size(s_speed,2);

%%%%%%%%% neuron params%%%%%%%%%
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
%%%%%%%%%% Model params %%%%
varType = 3;
causalStruct = [0,2,4,5]; % 0 means mixture based on parameters, 1-5 are the 4 main different structures and 5 is the full independent percept which equals the 3rd stucture
lenCaus = length(causalStruct);
% new parameters to account for behavioral data
num_trials=100;
ndots_all=10;   % Can be 1,2,3,5,10
subid_all=[1,2,3,4,5];    % Can be 1,2,3,4,5
load('models10_all.mat');
noise = [1,10,100,1000];
lenV = 20;
lenS = 5;
lenP = 10;
betavar = 0.05;
lenNS = length(noise);
ndots=ndots_all;
model_params = zeros([lenS, lenV, lenNS, lenP]);
for n=1:lenS
    subid=subid_all(n);
    model_type=9;
    model=models_all{subid,model_type};
    s=model.get_params_struct(model.params_phi_mle,model);
    sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];
    id1=sig_id(2,find(sig_id(1,:)==ndots,1));
    M = [s.sig_e_2,...
        s.sig_pg_2,...
        s.sig_pr_2(id1),...
        s.sig_pgr_2(id1),...
        s.alp(id1,:),...
        s.beta_gr];
    for ns=1:lenNS
        model_params(n,:,ns,1:2)= repmat([s.sig_g_2*noise(ns),s.sig_r_2(id1)*noise(ns)],[lenV,1]);
        for i=1:lenP-2
            mu = M(i);
            if mu > 0.9
                alpha = 8;
                beta = 0.5;
            elseif mu < 0.1
                alpha = 0.5;
                beta = 8;
            else
                alpha = mu * ((mu * (1 - mu) / betavar) - 1);
                beta = (1 - mu) * ((mu * (1 - mu) / betavar) - 1);
            end
            model_params(n,:,ns,i+2) =  betarnd(alpha, beta, [lenV, 1]);
        end
    
    end
end
model_params = reshape(model_params,[lenS* lenV, lenNS, lenP]);
figure;
plot(squeeze(model_params(:,1,:))')
randfrom2000 = randperm(size(model_params,1));
%%%%%%%%%%%%%%%%%%%%%%%% model computes inference %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
startS = 1; endS=100;
meanfire = zeros(length(neuronTypes),endS-startS+1,lenNS,len_s_speed,len_s,len_c);
%varfire = zeros(length(neuronTypes),endS-startS+1,lenNS,len_s_speed,len_c_speed,len_c);
parfor t=1:length(neuronTypes)
    neuronType = neuronTypes{t};
    for nshuf=startS:endS % loop over paramsp
        for nois=1:lenNS
            mdp = model_params(randfrom2000(nshuf),nois,:);
            for i=1:len_s_speed % speed center
                disp([t, nshuf, i])
                for k = 1:len_s % surround direction
                    for l = 1:len_c % center direction
                        if varType==1
                            [fr,~]=CI_model_percept_v2(c_dir(l), s_dir(k), c_speed(t), s_speed(t,i),num_trials,subid,ndots,mdp,neuronType,causalStruct(1));
                        elseif varType==2
                            [fr,~]=CI_model_retinal_v2(c_dir(l), s_dir(k), c_speed(t), s_speed(t,i),num_trials,subid,ndots,mdp,neuronType,causalStruct(1));
                        elseif varType==3
                            [fr,~]=CI_model_relative_v2(c_dir(l), s_dir(k), c_speed(t), s_speed(t,i),num_trials,subid,ndots,mdp,neuronType,causalStruct(1));
                        end
                        meanfire(t,nshuf,nois,i,k,l) = mean(fr);
                    end
                end
            end
        end
    end
end

save('MF_base.mat','meanfire',"-v7.3")

%save('model_params_MF_base.mat','model_params',"-v7.3")
