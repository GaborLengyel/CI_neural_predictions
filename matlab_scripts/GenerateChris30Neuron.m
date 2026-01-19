%clear all
%%%%%%%%%%%%%% setting params for the model %%%%%%%%%%%%%
%load('30neuron_params.mat')
%load('30neuron.mat')

dir_vec = [-135 -90 -45 0 45 90 135 180];

s_dir = dir_vec;
c_dir = dir_vec;

len_c = length(c_dir);
len_s = length(s_dir);
%%%%%%%%%% setting model params
varType = 1;
causalStruct = [0,2,4,5]; % 0 means mixture based on parameters, 1-5 are the 4 main different structures and 5 is the full independent percept which equals the 3rd stucture
lenCaus = length(causalStruct);
% new parameters to account for behavioral data
num_trials=1000;
ndots_all=10;   % Can be 1,2,3,5,10
subid_all=[1,2,3,4,5];    % Can be 1,2,3,4,5
lenSub = length(subid_all);
load('models10_all.mat');
noise = [1,20];
lenNoise = length(noise);
%%%%%%%%%%%%%%%%%%%%%%%% fitting tuning curves %%%%%%%%%%%%
tuneType=3;
%%%%%%%%%%%%%%%%%%%%%%%% model computes inference %%%%%%%%%%%
N = size(AllNeurons.centDirTuns,1);
meanfire = zeros(N,lenSub,lenCaus,lenNoise,len_s,len_c);
varfire = zeros(N,lenSub,lenCaus,lenNoise,len_s,len_c);
xs = squeeze(AllNeurons.centSpdTuns(1,:,1,1))';
for varType=[1,3]
for tuneType=[3,4]
for t=1:N
    t
    c_speed=AllParams.centSurrDirTun{1, t}.CSpd; s_speed=AllParams.centSurrDirTun{1, t}.SSpd;
    if tuneType==1
        load("ChrisDirTun.mat")
        load("ChrisSpdTun.mat")
        dirtun = fits_dir(t,:);
        speedtun = fits_spd(t,:);
        LT = "parametricTun";
    elseif tuneType==2
        ys1 = squeeze(AllNeurons.centDirTuns(t,:,1:5,2));
        ys1 = mean(ys1,2)';
        ys2 = squeeze(AllNeurons.centDirTuns2(t,:,2,1:5,3));
        ys2 = mean(ys2,2)';
        dirtun = {ys1, ys2};
        dirtun = [mean([dirtun{1}(5),dirtun{2}(5)]), mean([dirtun{1}(6),dirtun{2}(6)]), mean([dirtun{1}(7),dirtun{2}(7)]), mean([dirtun{1}(8),dirtun{2}(8)]), mean([dirtun{1}(1),dirtun{2}(1)]), mean([dirtun{1}(2),dirtun{2}(2)]), mean([dirtun{1}(3),dirtun{2}(3)]), mean([dirtun{1}(4),dirtun{2}(4)]), mean([dirtun{1}(5),dirtun{2}(5)])];
        ys = squeeze(AllNeurons.centSpdTuns(t,:,1:5,2));
        if sum(sum(isnan(ys)))~=0
        [rn,cn] = ind2sub(size(ys),find(isnan(ys)));
        ci = ones(1,size(ys,2));
        ci(cn)=0;
        ys(rn,cn) = mean(ys(rn,logical(ci)));
        end
        ys = mean(ys,2);
        speedtun = [xs,ys];
        LT = "nonparametricTun";
    elseif tuneType==3
        load("ChrisDirTunCS.mat")
        load("ChrisSpdTun.mat")
        dirtun = fits_dir(t,:);
        speedtun = fits_spd(t,:);
        LT = "parametricTunCS";
    elseif tuneType==4
        YT = squeeze(AllNeurons.centSurrDirTun(t,:,2,:,1,1:5,5));
                    YT = nanmean(YT,3);
                    YT = flip(YT',2);
                    YT = [YT(4,6) YT(4,7) YT(4,8) YT(4,1) YT(4,2) YT(4,3) YT(4,4) YT(4,5);...
                    YT(5,6) YT(5,7) YT(5,8) YT(5,1) YT(5,2) YT(5,3) YT(5,4) YT(5,5);...
                    YT(6,6) YT(6,7) YT(6,8) YT(6,1) YT(6,2) YT(6,3) YT(6,4) YT(6,5);...
                    YT(7,6) YT(7,7) YT(7,8) YT(7,1) YT(7,2) YT(7,3) YT(7,4) YT(7,5);...
                    YT(8,6) YT(8,7) YT(8,8) YT(8,1) YT(8,2) YT(8,3) YT(8,4) YT(8,5);...
                    YT(1,6) YT(1,7) YT(1,8) YT(1,1) YT(1,2) YT(1,3) YT(1,4) YT(1,5);...
                    YT(2,6) YT(2,7) YT(2,8) YT(2,1) YT(2,2) YT(2,3) YT(2,4) YT(2,5);...
                    YT(3,6) YT(3,7) YT(3,8) YT(3,1) YT(3,2) YT(3,3) YT(3,4) YT(3,5)];
        yd = mean(YT,1);
        dirtun = [yd(end),yd(1),yd(2),yd(3),yd(4),yd(5),yd(6),yd(7),yd(8)];
        ys = squeeze(AllNeurons.centSpdTuns(t,:,1:5,2));
        if sum(sum(isnan(ys)))~=0
        [rn,cn] = ind2sub(size(ys),find(isnan(ys)));
        ci = ones(1,size(ys,2));
        ci(cn)=0;
        ys(rn,cn) = mean(ys(rn,logical(ci)));
        end
        ys = mean(ys,2);
        speedtun = [xs,ys];
        LT = "nonparametricTunCS";
    end
    for n=1:lenSub % loop over subject
        for c=1:lenCaus
            for ns=1:lenNoise
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
                    
                for k = 1:len_s % surround direction
                    for l = 1:len_c % center direction
    
                        if varType==1
                            [fr,~]=CI_model_percept_Chris(c_dir(l), s_dir(k), c_speed, s_speed,num_trials,subid,ndots,model_params,causalStruct(c),dirtun,speedtun,tuneType);
                            LL = "percept";
                        elseif varType==2
                            [fr,~]=CI_model_retinal_Chris(c_dir(l), s_dir(k),c_speed, s_speed,num_trials,subid,ndots,model_params,causalStruct(c),dirtun,speedtun,tuneType);
                            LL = "combined";
                        elseif varType==3
                            [fr,~]=CI_model_relative_Chris(c_dir(l), s_dir(k),c_speed, s_speed,num_trials,subid,ndots,model_params,causalStruct(c),dirtun,speedtun,tuneType);
                            LL = "relative";
                        end
                        meanfire(t,n,c,ns,k,l) = mean(fr);
                        varfire(t,n,c,ns,k,l) = var(fr,0,"all");
                    end
                end
            end
        end
    end
end
save("pred_Chris_"+LL+"_"+LT+".mat",'meanfire')
end
end
%save('fire_all_perceptVar_Chris30N_nonparam.mat',"-v7.3")

%save('pred_Chris_param_percept.mat','meanfire')