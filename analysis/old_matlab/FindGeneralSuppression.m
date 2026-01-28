clear all
close all
%%%%%%%%%%%%%% setting params for the model %%%%%%%%%%%%%
point = linspace(-180,180,361);
gap = 4;

dir_vec = point( 1: gap: end);

s_dir = dir_vec;
c_dir = dir_vec;

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
%logSpd = [0, 0.01, 0.05, 0.1, 0.3, 0.6,logspace(0, 1.46, 20)];
% speed_vec = [logSpd;...
%             logSpd;...
%             logSpd;...
%             logSpd;...
%             logSpd;...
%             logSpd;...
%             logSpd;...
%             logSpd;...
%             logSpd];
c_speed = speed_vec;
%recent% s_speed = [0,n1_m-(n1_sd/2.2), n1_m-(n1_sd/4), n1_m, n1_m+n1_sd, n1_m+(2*n1_sd);...
%             0,n1_m-(n1_sd/2.2), n1_m-(n1_sd/4), n1_m, n1_m+n1_sd, n1_m+(2*n1_sd);...
%             0,n1_m-(n1_sd/2.2), n1_m-(n1_sd/4), n1_m, n1_m+n1_sd, n1_m+(2*n1_sd);...
%             0,n2_m-(n2_sd/2), n2_m-(n2_sd/4), n2_m, n2_m+n2_sd, n2_m+(2*n2_sd);...
%             0,n2_m-(n2_sd/2), n2_m-(n2_sd/4), n2_m, n2_m+n2_sd, n2_m+(2*n2_sd);...
%             0,n2_m-(n2_sd/2), n2_m-(n2_sd/4), n2_m, n2_m+n2_sd, n2_m+(2*n2_sd);...
%             0,n3_m-(n3_sd/2), n3_m-(n3_sd/4), n3_m, n3_m+n3_sd, n3_m+(2*n3_sd);...
%             0,n3_m-(n3_sd/2), n3_m-(n3_sd/4), n3_m, n3_m+n3_sd, n3_m+(2*n3_sd);...
%             0,n3_m-(n3_sd/2), n3_m-(n3_sd/4), n3_m, n3_m+n3_sd, n3_m+(2*n3_sd)];
s_speed = speed_vec;

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
noise = [1,10,100];
lenV = 100;
lenS = 5;
lenP = 10;
betavar = 0.05;
lenNS = length(noise);
ndots=ndots_all;
NM = (lenS);
% model_params = zeros([lenS, lenV, lenNS, lenP]);
% for n=1:lenS
%     subid=subid_all(n);
%     model_type=9;
%     model=models_all{subid,model_type};
%     s=model.get_params_struct(model.params_phi_mle,model);
%     sig_id=[1,2,3,5,10,0;1,2,3,4,5,6];
%     id1=sig_id(2,find(sig_id(1,:)==ndots,1));
%     M = [s.sig_e_2,...
%         s.sig_pg_2,...
%         s.sig_pr_2(id1),...
%         s.sig_pgr_2(id1),...
%         s.alp(id1,:),...
%         s.beta_gr];
%     for ns=1:lenNS
%         model_params(n,:,ns,1:2)= repmat([s.sig_g_2*noise(ns),s.sig_r_2(id1)*noise(ns)],[lenV,1]);
%         for i=1:lenP-2
%             mu = M(i);
%             if mu > 0.9
%                 alpha = 8;
%                 beta = 0.5;
%             elseif mu < 0.1
%                 alpha = 0.5;
%                 beta = 8;
%             else
%                 alpha = mu * ((mu * (1 - mu) / betavar) - 1);
%                 beta = (1 - mu) * ((mu * (1 - mu) / betavar) - 1);
%             end
%             model_params(n,:,ns,i+2) =  betarnd(alpha, beta, [lenV, 1]);
%         end
% 
%     end
% end
% model_params = reshape(model_params,[lenS* lenV, lenNS, lenP]);
% figure;
% plot(squeeze(model_params(:,1,:))')
%randfrom2000 = randperm(size(model_params,1));
load('model_params_5subj.mat')
%%%%%%%%%%%%%%%%%%%%%%%% model computes inference %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%startS = 101; endS=200;
%meanfire = zeros(length(neuronTypes),endS-startS+1,len_s_speed,len_c_speed,len_s,len_c);
%varfire = zeros(length(neuronTypes),lenS,lenNS,len_s_speed,len_c_speed,len_s,len_c);
fire = zeros(len_s,len_c);fireM = zeros(len_s,len_c);fireS = zeros(len_s,len_c);struc = zeros(len_s,len_c,num_trials);
%recent%meanfire = zeros(length(neuronTypes),lenS*lenV,lenNS,len_s_speed,len_c_speed,len_s,len_c);
%meanfire = zeros(length(neuronTypes),lenS*lenV,lenNS,len_s_speed,len_c_speed);
%k=1;l=31;
% parfor NT=1:length(neuronTypes)
%     neuronType = neuronTypes{NT};
%     for MP=1:NM % loop over subject parameters
%         for NL=1:lenNS
            NT = 5;
            neuronType = neuronTypes{NT};
            mdp = model_params(3,1,:);
            mdp(1) = 0.008; mdp(2) = 0.19;
            %mdp(1) = 0.0001; mdp(2) = 0.009;
            %mdp(3) = 0.0051;
            %mdp(4) = 0.059;
            %mdp(5) = 0.001;
            mdp(6) = 0.3;
            %mdp(7) = 0.9;
            %mdp(8) = 0.9;
            %mdp(9) = 0.9;
            squeeze(mdp)
            parfor k = 1:len_s % surround direction
                for l = 1:len_c % center direction

                    [frS,~]=CI_model_relative_v2(c_dir(l), s_dir(k), c_speed(NT,3), 0, num_trials,1,ndots,mdp,neuronType,causalStruct(1));
                    [frM,~]=CI_model_relative_v2(c_dir(l), s_dir(k), c_speed(NT,3), s_speed(NT,3),num_trials,1,ndots,mdp,neuronType,causalStruct(1));
                    [s]=CI_model_relative_post_struct(c_dir(l), s_dir(k), c_speed(NT,3), s_speed(NT,3),num_trials,1,ndots,mdp);
                    frS = mean(frS);
                    frM = mean(frM);
                    %meanfire(NT,MP,NL,i,j) = mean(fr);
                    %meanfire(NT,MP,NL,i,j,k,l) = mean(fr);
                    %varfire(NT,MP,NL,i,j,k,l) = var(fr);
                    fire(k,l) = frM - frS;
                    fireM(k,l) = frM;
                    fireS(k,l) = frS;
                    struc(k,l,:) = s;
                end
            end

%         end
%     end
% end

%save('VF_full_subj2_rel.mat','varfire',"-v7.3")
%save('model_params_MF_all.mat','model_params',"-v7.3")

figure;

subplot(1, 3, 1)
image(flip(fire, 1), 'CDataMapping','scaled')
%colorbar
%ylabel(' ', 'FontSize', fonsize1);
%xlabel(' ', 'FontSize', fonsize1);
set(gca,'XTick', [])
set(gca,'XTickLabel', [])
set(gca,'YTick',[])
set(gca,'YTickLabel', [])
colorbar
%title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
subplot(1, 3, 2)
image(flip(fireS, 1), 'CDataMapping','scaled')
%colorbar
%ylabel(' ', 'FontSize', fonsize1);
%xlabel(' ', 'FontSize', fonsize1);
set(gca,'XTick', [])
set(gca,'XTickLabel', [])
set(gca,'YTick',[])
set(gca,'YTickLabel', [])
colorbar
subplot(1, 3, 3)
image(flip(fireM, 1), 'CDataMapping','scaled')
%colorbar
%ylabel(' ', 'FontSize', fonsize1);
%xlabel(' ', 'FontSize', fonsize1);
set(gca,'XTick', [])
set(gca,'XTickLabel', [])
set(gca,'YTick',[])
set(gca,'YTickLabel', [])
colorbar