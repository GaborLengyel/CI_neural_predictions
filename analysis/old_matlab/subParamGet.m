clear all
%%%%%%%%%%%%%% setting params for the model %%%%%%%%%%%%%

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

for n=1:lenS
    subid=subid_all(n);
    model_type=9;
    model=models_all{subid,model_type};
    s=model.get_params_struct(model.params_phi_mle,model);
    sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];
    id1=sig_id(2,find(sig_id(1,:)==ndots,1));
    M(n,:) = [s.sig_g_2,...
        s.sig_r_2(id1),...
        s.sig_e_2,...
        s.sig_pg_2,...
        s.sig_pr_2(id1),...
        s.sig_pgr_2(id1),...
        s.alp(id1,:),...
        s.beta_gr];
end

load('model_params_5subj.mat')
for i=1:3
model_params(:,i,:) = M;
end
model_params(:,2,2) = model_params(:,2,2)*10;
model_params(:,3,2) = model_params(:,2,2)*100;
save('model_params_5subj_surr.mat','model_params',"-v7.3")