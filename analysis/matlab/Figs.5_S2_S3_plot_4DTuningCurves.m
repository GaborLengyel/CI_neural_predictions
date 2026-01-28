%%%%%%%%%%%%%%%%%%%%%%%%%%%% plotting the results %%%%%%%%%%%%%
%load('neural_pred_median_neuron_1.mat') 
close all

variable = {'Perceive', 'Retinal', 'Relative'};
%stat = {'mean', 'variance'};
saving = 1;
saveformat = '-dpdf';
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];
meanfire2 = meanfire(4,:,1,:,:,:,:);
neural_pred_mu = reshape(meanfire2, [5 1 5 5 91 91]);
l = size(neural_pred_mu,length(size(neural_pred_mu)));
xtck = round([1, l/4, l/2, (l*3)/4, l]);
fontsize1 = 24;
tcki = [1,6,11,16];
tckj = [22,23,24,25];
tckij = [21];
for s=1:5 % loop over subject
for c=1%:2
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
for i = size(neural_pred_mu,3):-1:1
    for j = 1:size(neural_pred_mu,4)

        subplot(size(neural_pred_mu,4), size(neural_pred_mu,3), p)
        imagesc(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1))
        %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca, 'CLim', [0 1]);
        if ismember(p,tckj) 
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        elseif ismember(p,tcki)
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick', xtck)
            set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        elseif ismember(p,tckij)
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
            set(gca,'YTick', xtck)
            set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        else
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        end
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p = p+1;

    end
end

print(fig{1}, "RetinaPredMean2d_oppNeur_stim1_tck"+"_var"+variable{2}+"_"+"subj"+string(s)+"_"+"CS"+string(c), saveformat);
end
end
%%

variable = {'Perceive', 'Retinal', 'Relative'};
%stat = {'mean', 'variance'};
saving = 1;
saveformat = '-dpdf';
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];
varfire2 = varfire(4,:,1,:,:,:,:);
neural_pred_mu = reshape(varfire2, [5 1 5 5 91 91]);
l = size(neural_pred_mu,length(size(neural_pred_mu)));
xtck = round([1, l/4, l/2, (l*3)/4, l]);
fontsize1 = 24;
tcki = [1,6,11,16];
tckj = [22,23,24,25];
tckij = [21];
for s=1:5 % loop over subject
for c=1
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
for i = size(neural_pred_mu,3):-1:1
    for j = 1:size(neural_pred_mu,4)

        subplot(size(neural_pred_mu,4), size(neural_pred_mu,3), p)
        %imagesc(flip(squeeze(var(squeeze(neural_pred(s,c,i,j,:,:,:)),0,3)), 1))
        image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        %set(gca, 'CLim', [0 0.001]);
        if ismember(p,tckj) 
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        elseif ismember(p,tcki)
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick', xtck)
            set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        elseif ismember(p,tckij)
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
            set(gca,'YTick', xtck)
            set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        else
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        end
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p = p+1;

    end
end

print(fig{1}, "RetinaPredVar2d_stim1_tck_bar"+"_var"+variable{2}+"_"+"subj"+string(s)+"_"+"AllCS", saveformat);
end
end
%%
close all
p = 1;
s = 5;
n = 5;
%meanfire2 = squeeze(meanfire(n,s,1,2:6,:,:,:));
%neural_pred_mu = squeeze(varfire(n,s,1,:,:,:,:));
meanfire2 = squeeze(meanfire(n,s,2:6,:,:,:));
neural_pred_mu = squeeze(varfire(n,s,2:6,:,:,:));
variable = {'Perceive', 'Retinal', 'Relative'};
%stat = {'mean', 'variance'};
saving = 1;
saveformat = '-dpdf';
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];
l = size(neural_pred_mu,length(size(neural_pred_mu)));
xtck = round([1, l/4, l/2, (l*3)/4, l]);
fontsize1 = 24;
tcki = [1,6,11,16];
tckj = [22,23,24,25];
tckij = [21];
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');

for i = size(neural_pred_mu,1):-1:1
    for j = 1:size(neural_pred_mu,2)
        v = squeeze(neural_pred_mu(i,j,:,:));
        m = squeeze(meanfire2(i,j,:,:));
        m = imresize(m, [size(neural_pred_mu,3),size(neural_pred_mu,4)]);
        subplot(size(neural_pred_mu,2), size(neural_pred_mu,1), p)
        %imagesc(flip(squeeze(var(squeeze(neural_pred(s,c,i,j,:,:,:)),0,3)), 1))
        image(flip(m, 1), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        %set(gca, 'CLim', [0 0.5]);
        if ismember(p,tckj) 
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        elseif ismember(p,tcki)
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick', xtck)
            set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        elseif ismember(p,tckij)
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
            set(gca,'YTick', xtck)
            set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        else
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        end
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p = p+1;

    end
end
print(fig{1}, "RELPredMEAN2d_stim1_tck_bar"+"_var_"+"subj"+num2str(s), saveformat);

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
for i = size(neural_pred_mu,1):-1:1
    for j = 1:size(neural_pred_mu,2)
        v = squeeze(neural_pred_mu(i,j,:,:));
        subplot(size(neural_pred_mu,2), size(neural_pred_mu,1), p)
        %imagesc(flip(squeeze(var(squeeze(neural_pred(s,c,i,j,:,:,:)),0,3)), 1))
        image(flip(v, 1), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca, 'CLim', [0 0.01]);
        if ismember(p,tckj) 
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        elseif ismember(p,tcki)
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick', xtck)
            set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        elseif ismember(p,tckij)
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
            set(gca,'YTick', xtck)
            set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        else
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        end
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p = p+1;

    end
end
print(fig{1}, "RETTPredVarExcess_2d_stim1_tck_bar"+"_var_"+"subj"+num2str(s), saveformat);

% fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
% p = 1;
% baseline_rate = 15.0; 
% max_rate = 80.0;
% scaling_factor = max_rate - baseline_rate;
% baseline_offset = baseline_rate;
% for i = size(neural_pred_mu,1):-1:1
%     for j = 1:size(neural_pred_mu,2)
%         v = squeeze(neural_pred_mu(i,j,:,:));
%         m = squeeze(meanfire2(i,j,:,:));
%         m = imresize(m, [size(neural_pred_mu,3),size(neural_pred_mu,4)]);
%         m_scaled = (m * scaling_factor) + baseline_offset;
%         v_scaled = v * (scaling_factor^2);
%         subplot(size(neural_pred_mu,2), size(neural_pred_mu,1), p)
%         %imagesc(flip(squeeze(var(squeeze(neural_pred(s,c,i,j,:,:,:)),0,3)), 1))
%         image(flip(v_scaled./m_scaled, 1), 'CDataMapping','scaled')
%         %colorbar
%         %ylabel(' ', 'FontSize', fonsize1);
%         %xlabel(' ', 'FontSize', fonsize1);
%         set(gca, 'CLim', [0 5]);
%         if ismember(p,tckj) 
%             set(gca,'XTick', xtck)
%             set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
%             set(gca,'YTick',[])
%             set(gca,'YTickLabel', [])
%         elseif ismember(p,tcki)
%             set(gca,'XTick', [])
%             set(gca,'XTickLabel', [])
%             set(gca,'YTick', xtck)
%             set(gca,'YTickLabel', {'180','90','0', '-90', '-180'},'FontSize', fontsize1)
%         elseif ismember(p,tckij)
%             set(gca,'XTick', xtck)
%             set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
%             set(gca,'YTick', xtck)
%             set(gca,'YTickLabel', {'180','90','0', '-90', '-180'},'FontSize', fontsize1)
%         else
%             set(gca,'XTick', [])
%             set(gca,'XTickLabel', [])
%             set(gca,'YTick',[])
%             set(gca,'YTickLabel', [])
%         end
%         %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
%         p = p+1;
% 
%         % cb = colorbar;
%         % 
%         % % Set the *positions* of the ticks
%         % cb.Ticks = [0, 3, 6]; 
%         % 
%         % % Set the *text* for those ticks
%         % cb.TickLabels = {'0', '0.3', '0.6'};
%         % 
%         % % You can also just change the font size
%         % cb.FontSize =fontsize1;
% 
%     end
% end
% 
% print(fig{1}, "RELPredVar2d_stim1_tck_bar"+"_var_"+"subj"+num2str(s), saveformat);
%%
% %%
% variable = {'Perceive', 'Retinal', 'Relative'};
% %stat = {'mean', 'variance'};
% saving = 1;
% saveformat = '-dpdf';
% fontsize1 = 30;
% R0= 3.4754 ; A=67.8693; alpha=0.0234; tau=-0.0040; n=0.5913*1; % new fit to neural data
% R0_dir=-0.4730; kappa=1.4025*1; A_dir=71.7927; mu=180;% mu=14.4978;% For Cosyne poster we used mu=0.4978;
% fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu, kappa) .* abs(neuron_speed_tuning(nu, R0, A, alpha, tau, n));
% n=361;
% d = linspace(-180,180,n);
% s = linspace(0,28,n);
% TunC = zeros(n,n);
% for i=1:n
%     for j=1:n
%         TunC(i,j) = fr_joint(d(j),s(i));
%     end
% end
% 
% paperPos = [0 0 5 5];
% paperSize = [6, 6];
% fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
% imagesc(flip(TunC,1))
% % c = colorbar;
% % c.Ticks = [0,0.5,1];
% % c.FontSize = 35;
% set(gca, 'CLim', [0 1]);
% %set(gca,'XLim', [-1,362])
% set(gca,'XTick', [1,90,180,270,360])
% set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
% set(gca,'YTick',[1,90,180,270,360])
% %set(gca,'YLim', [-1,362])
% set(gca,'YTickLabel', {'28','21','14', '7', '0'},'FontSize', fontsize1)
% print(fig{1}, "Tun_opposite_neuron_c", saveformat);
% 
% 
% figure
% plot(sum(TunC,2), 'k-', "LineWidth",8)
% box off;
% axis off;
% %%
% l = size(neural_pred_mu,length(size(neural_pred_mu)));
% paperPos = [0 0 5 5];
% paperSize = [6, 6];
% xtck = round([1, l/4, l/2, (l*3)/4, l]);
% fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
% imagesc(flip(squeeze(neural_pred_mu(2,1,2,2,:,:)), 1))
% % c = colorbar;
% % c.Ticks = [0,0.5,1];
% % c.FontSize = 35;
% set(gca, 'CLim', [0 1]);
% %set(gca,'XLim', [-1,362])
% set(gca,'XTick', xtck)
% set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
% set(gca,'YTick',xtck)
% %set(gca,'YLim', [-1,362])
% set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
% print(fig{1}, "one_median_neuron_c", saveformat);
% 
% 
% figure
% plot(squeeze(neural_pred_mu(2,1,2,2,:,round(l/2))), 'k-', "LineWidth",4)
% set(gca,'XTick', xtck)
% set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
% set(gca,'YTick', [0,0.5,1])
% set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
% box off;