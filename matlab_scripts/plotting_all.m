%%
saving = 1;
saveformat = '-dpdf';
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];
l = length(dir_vec);
xtck = round([1, l/4, l/2, (l*3)/4, l]);
fontsize1 = 24;
tcki = [1,6,11,16];
tckj = [22,23,24,25];
tckij = [21];
Tun = {{'0.5','2','8','0.5','2','8','0.5','2','8'},{'1','1','1','2','2','2','3','3','3'}};
for t=[5]
    for n=1:5
        for ns=1
            %for c=1:4

                % fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
                % p = 1;
                % for i = 5:-1:1
                %     for j = 1:5
                % 
                %         subplot(5, 5, p)
                %         %imagesc(flip(squeeze(meanfire(t,n,ns,c,i,j,:,:)), 1))
                %         imagesc(flip(squeeze(meanfire(t,n,ns,i,j,:,:)), 1))
                %         %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
                %         %colorbar
                %         %ylabel(' ', 'FontSize', fonsize1);
                %         %xlabel(' ', 'FontSize', fonsize1);
                %         set(gca, 'CLim', [0,1]);
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
                % 
                %         p = p+1;
                % 
                %     end
                % end
                % sgtitle("Neuron k:"+Tun{1}{t}+" SD:"+Tun{2}{t}+" Subj:"+string(n)+" Noise:"+string(ns), 'FontSize', fontsize1);
                % %print(fig, "CiPred_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns)+"CS"+string(c), saveformat);
                % print(fig, "CiPred_comb_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns), saveformat);

                % fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
                % p = 1;
                % for i = 5:-1:1
                %     for j = 1:5
                % 
                %         subplot(5, 5, p)
                %         %imagesc(flip(squeeze(predSep(t,n,ns,c,i,j,:,:)), 1))
                %         imagesc(flip(squeeze(predSep(t,n,ns,i,j,:,:)), 1))
                %         %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
                %         %colorbar
                %         %ylabel(' ', 'FontSize', fonsize1);
                %         %xlabel(' ', 'FontSize', fonsize1);
                %         set(gca, 'CLim', [0,1]);
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
                % 
                %         p = p+1;
                % 
                %     end
                % end
                % sgtitle("Neuron k:"+Tun{1}{t}+" SD:"+Tun{2}{t}+" Subj:"+string(n)+" Noise:"+string(ns), 'FontSize', fontsize1);
                % %print(fig, "SepPred_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns)+"CS"+string(c), saveformat);
                % print(fig, "SepPred_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns), saveformat);
                % 
                fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
                p = 1;
                for i = 5:-1:1
                    for j = 1:5

                        subplot(5, 5, p)
                        %imagesc(flip(squeeze(predRel(t,n,ns,c,i,j,:,:)), 1))
                        imagesc(flip(squeeze(predRel(t,n,ns,i,j,:,:)), 1))
                        %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
                        %colorbar
                        %ylabel(' ', 'FontSize', fonsize1);
                        %xlabel(' ', 'FontSize', fonsize1);
                        set(gca, 'CLim', [0,1]);
                        if ismember(p,tckj) 
                            set(gca,'XTick', xtck)
                            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
                            set(gca,'YTick',[])
                            set(gca,'YTickLabel', [])
                        elseif ismember(p,tcki)
                            set(gca,'XTick', [])
                            set(gca,'XTickLabel', [])
                            set(gca,'YTick', xtck)
                            set(gca,'YTickLabel', {'180','90','0', '-90', '-180'},'FontSize', fontsize1)
                        elseif ismember(p,tckij)
                            set(gca,'XTick', xtck)
                            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
                            set(gca,'YTick', xtck)
                            set(gca,'YTickLabel', {'180','90','0', '-90', '-180'},'FontSize', fontsize1)
                        else
                            set(gca,'XTick', [])
                            set(gca,'XTickLabel', [])
                            set(gca,'YTick',[])
                            set(gca,'YTickLabel', [])
                        end

                        p = p+1;

                    end
                end
                sgtitle("Neuron k:"+Tun{1}{t}+" SD:"+Tun{2}{t}+" Subj:"+string(n)+" Noise:"+string(ns), 'FontSize', fontsize1);
                %print(fig, "RelPred_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns)+"_CS"+string(c), saveformat);
                print(fig, "RelPred_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns), saveformat);

            %end
        end
    end
end
%%

saving = 1;
saveformat = '-dpdf';
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];
l = length(dir_vec);
xtck = round([1, l/4, l/2, (l*3)/4, l]);
fontsize1 = 24;
tcki = [1,6,11,16];
tckj = [22,23,24,25];
tckij = [21];
Tun = {{'0.5','2','8','0.5','2','8','0.5','2','8'},{'1','1','1','2','2','2','3','3','3'}};
for t=1:9
    for n=1:5
        for ns=1

                fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
                p = 1;
                for i = 5:-1:1
                    for j = 1:5
                
                        subplot(5, 5, p)
                        %imagesc(flip(squeeze(meanfire(t,n,ns,c,i,j,:,:)), 1))
                        data = flip(squeeze(varfire(t,n,ns,i,j,:,:)), 1);
                        imagesc(data)
                        %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
                        % cb = colorbar;
                        % cb.Ticks = [-12,-6,-3,-1.5,0];
                        % cb.TickLabels = {'0', '0.003', '0.05', '0.22', 1};
                        %ylabel(' ', 'FontSize', fonsize1);
                        %xlabel(' ', 'FontSize', fonsize1);
                        set(gca, 'CLim', [0,0.1]);
                        if ismember(p,tckj) 
                            set(gca,'XTick', xtck)
                            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
                            set(gca,'YTick',[])
                            set(gca,'YTickLabel', [])
                        elseif ismember(p,tcki)
                            set(gca,'XTick', [])
                            set(gca,'XTickLabel', [])
                            set(gca,'YTick', xtck)
                            set(gca,'YTickLabel', {'180','90','0', '-90', '-180'},'FontSize', fontsize1)
                        elseif ismember(p,tckij)
                            set(gca,'XTick', xtck)
                            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
                            set(gca,'YTick', xtck)
                            set(gca,'YTickLabel', {'180','90','0', '-90', '-180'},'FontSize', fontsize1)
                        else
                            set(gca,'XTick', [])
                            set(gca,'XTickLabel', [])
                            set(gca,'YTick',[])
                            set(gca,'YTickLabel', [])
                        end
                        
                        p = p+1;
                
                    end
                end
                sgtitle("Neuron k:"+Tun{1}{t}+" SD:"+Tun{2}{t}+" Subj:"+string(n)+" Noise:"+string(ns), 'FontSize', fontsize1);
                %print(fig, "CiPred_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns)+"CS"+string(c), saveformat);
                print(fig, "CiPredVar_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns), saveformat);

        end
    end
end
%%
%% 
saving = 1;
saveformat = '-dpdf';
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];
l = length(dir_vec);
xtck = round([1, l/4, l/2, (l*3)/4, l]);
fontsize1 = 80;
tcki = [1,6,11,16];
tckj = [22,23,24,25];
tckij = [21];
Tun = {{'0.5','2','8','0.5','2','8','0.5','2','8'},{'1','1','1','2','2','2','3','3','3'}};
for t=5
    for n=1:5
        for ns=1

                fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');

                imagesc(flip(squeeze(meanfire(t,n,ns,i,j,:,:)), 1))
                %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
                %colorbar
                %ylabel(' ', 'FontSize', fonsize1);
                %xlabel(' ', 'FontSize', fonsize1);
                set(gca, 'CLim', [0,1]);
                if n==2 
                    set(gca,'XTick', xtck)
                    set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
                    set(gca,'YTick', xtck)
                    set(gca,'YTickLabel', {'180','90','0', '-90', '-180'},'FontSize', fontsize1)
                else
                    set(gca,'XTick', xtck)
                    set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
                    set(gca,'YTick',[])
                    set(gca,'YTickLabel', [])
                end
                        
                     
                print(fig, "CiPred_prefSpeed"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns), saveformat);

        end
    end
end
%%

ytck = [0,0.5,1];
lw=10;
fontsize1 = 38;
ix=22;
for ix=45:50
fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
disp(ix)
for t=[3,5,7]
    for n=[2,1]
        subplot(3, 2, p);
        hold on
        Mci = squeeze(meanfire(t,n,1,3,3,:,:));
        Ms = squeeze(predSep(t,n,1,3,3,:,:));
        Mr = squeeze(predRel(t,n,1,3,3,:,:));
        plot(abs(Mci(:,ix)-Ms(:,ix)),'-', 'LineWidth',lw, 'Color', [1 0 0 0.6])
        plot(abs(Mci(:,ix)-Mr(:,ix)),'-', 'LineWidth',lw, 'Color', [0 0 1 0.6])
        %plot(abs(Mci(ix,:)-Ms(ix,:)),'-', 'LineWidth',lw, 'Color', [1 0 0 0.6])
        %plot(abs(Mci(ix,:)-Mr(ix,:)),'-', 'LineWidth',lw, 'Color', [0 0 1 0.6])
        if ismember(p,[6]) 
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        elseif ismember(p,[1,3])
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick', ytck)
            set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
        elseif ismember(p,[5])
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
            set(gca,'YTick', ytck)
            set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
        else
            set(gca,'XTick', [2,4])
            set(gca,'XTickLabel', [])
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        end
        set(gca,'XLim',[0,91])
        set(gca,'YLim', [0,1])
        p = p+1;
        % if p==3
        %     legend('Causal Inf.', 'Separable', 'Relative');
        % end
    end
end
                %sgtitle("Neuron k:"+Tun{1}{t}+" SD:"+Tun{2}{t}+" Subj:"+string(n)+" Noise:"+string(ns), 'FontSize', fontsize1);
                %print(fig, "RelPred_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns)+"_CS"+string(c), saveformat);
print(fig, "CompModel_crossC_"+string(ix)+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns), saveformat);
end
%%
ytck = [0,0.5,1];
%ix = 23;
lw=15;
fontsize1 = 50;
xtck = [l/4, l/2, (l*3)/4];
for n=1:5
fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;

for t=[3,5,7]
    for ix = [38,57]
        ax = subplot(3, 2, p);
        hold on
        Mci = squeeze(meanfire(t,n,1,3,3,:,:));
        Ms = squeeze(predSep(t,n,1,3,3,:,:));
        Mr = squeeze(predRel(t,n,1,3,3,:,:));
        plot(Mci(:,ix),'-', 'LineWidth',lw, 'Color', [0 0 0 0.6])
        plot(Ms(:,ix),'-', 'LineWidth',lw, 'Color', [1 0 0 0.6])
        plot(Mr(:,ix),'-', 'LineWidth',lw, 'Color', [0 0 1 0.6])
        % plot(Mci(ix,:),'-', 'LineWidth',lw, 'Color', [0 0 0 0.6])
        % plot(Ms(ix,:),'-', 'LineWidth',lw, 'Color', [1 0 0 0.6])
        % plot(Mr(ix,:),'-', 'LineWidth',lw, 'Color', [0 0 1 0.6])
        if ismember(p,[6]) 
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-90','0', '90'},'FontSize', fontsize1)
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        elseif ismember(p,[1,3])
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick', ytck)
            set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
        elseif ismember(p,[5])
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-90','0', '90'},'FontSize', fontsize1)
            set(gca,'YTick', ytck)
            set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
        else
            set(gca,'XTick', [2,4])
            set(gca,'XTickLabel', [])
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        end
        set(gca,'XLim',[0,91])
        set(gca,'YLim', [0,1])
        p = p+1;
        % if p==3
        %     legend('Causal Inf.', 'Separable', 'Relative');
        % end
        if ismember(p,[2,4,6])
            pos = get(ax, 'Position');
            pos(1) = pos(1) + 0.07; % Move left
            set(ax, 'Position', pos);
 
        end
    end
end
                %sgtitle("Neuron k:"+Tun{1}{t}+" SD:"+Tun{2}{t}+" Subj:"+string(n)+" Noise:"+string(ns), 'FontSize', fontsize1);
                %print(fig, "RelPred_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns)+"_CS"+string(c), saveformat);
print(fig, "AC_CompModel_cross_"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns), saveformat);
end
%%
%%
ytck = [0,0.5,1];
%ix = 23;
lw=15;
fontsize1 = 50;
xtck = [l/4, l/2, (l*3)/4];
for n=1:5
fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;

for t=[3,5,7]
    for ix = [38,57]
        ax = subplot(3, 2, p);
        hold on
        Mci = squeeze(meanfire(t,n,1,3,3,:,:));
        Ms = squeeze(predSep(t,n,1,3,3,:,:));
        Mr = squeeze(predRel(t,n,1,3,3,:,:));
        plot(Mci(:,ix),'-', 'LineWidth',lw, 'Color', [0 0 0 0.6])
        
        X = [ones(len_c,1), Ms(ix,:)];
        w = X\Mci(ix,:);
        sepcross1 = X*w;

        plot(Ms(:,ix),'-', 'LineWidth',lw, 'Color', [1 0 0 0.6])

                                    for i2 = 1:len_s % center direction
                                angle1 = deg2rad(dir_vec(i1));
                                angle2 = deg2rad(dir_vec(i2));
                                x1 = speed_vec(i) * cos(angle1);
                                y1 = speed_vec(i) * sin(angle1);
                                x2 = speed_vec(j) * cos(angle2);
                                y2 = speed_vec(j) * sin(angle2);
                                dx = x2 - x1;
                                dy = y2 - y1;
                                direction = atan2d(dy, dx);
                                speed = sqrt(dx^2 + dy^2);
                                relActivity(i1,i2) = fr_joint(direction,speed);
                            end
                        end
                        Xrel = [ones(len_c*len_s,1), reshape(relActivity,[len_c*len_s,1])];
                        w = Xrel\y; 
                        predRel(t,n,ns,i,j,:,:) = reshape(Xrel*w,[len_s,len_c]);

        plot(Mr(:,ix),'-', 'LineWidth',lw, 'Color', [0 0 1 0.6])
        % plot(Mci(ix,:),'-', 'LineWidth',lw, 'Color', [0 0 0 0.6])
        % plot(Ms(ix,:),'-', 'LineWidth',lw, 'Color', [1 0 0 0.6])
        % plot(Mr(ix,:),'-', 'LineWidth',lw, 'Color', [0 0 1 0.6])
        if ismember(p,[6]) 
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-90','0', '90'},'FontSize', fontsize1)
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        elseif ismember(p,[1,3])
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick', ytck)
            set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
        elseif ismember(p,[5])
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-90','0', '90'},'FontSize', fontsize1)
            set(gca,'YTick', ytck)
            set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
        else
            set(gca,'XTick', [2,4])
            set(gca,'XTickLabel', [])
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        end
        set(gca,'XLim',[0,91])
        set(gca,'YLim', [0,1])
        p = p+1;
        % if p==3
        %     legend('Causal Inf.', 'Separable', 'Relative');
        % end
        if ismember(p,[2,4,6])
            pos = get(ax, 'Position');
            pos(1) = pos(1) + 0.07; % Move left
            set(ax, 'Position', pos);
 
        end
    end
end
                %sgtitle("Neuron k:"+Tun{1}{t}+" SD:"+Tun{2}{t}+" Subj:"+string(n)+" Noise:"+string(ns), 'FontSize', fontsize1);
                %print(fig, "RelPred_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns)+"_CS"+string(c), saveformat);
print(fig, "AC_CompModel_cross_"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns), saveformat);
end
%%
fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
ix = 23;
lw=15;
fontsize1 = 50;
xtck = [l/4, l/2, (l*3)/4];
for t=[3,5,7]
    for n=[2,1]
        ax = subplot(3, 2, p);
        hold on
        Mci = squeeze(meanfire(t,n,1,3,3,:,:));
        %Ms = squeeze(predSep(t,n,1,3,3,:,:));
        Mr = squeeze(predRel(t,n,1,3,3,:,:));
        % plot(Mci(:,ix),'-', 'LineWidth',lw, 'Color', [0 0 0 0.6])
        % plot(Ms(:,ix),'-', 'LineWidth',lw, 'Color', [1 0 0 0.6])
        % plot(Mr(:,ix),'-', 'LineWidth',lw, 'Color', [0 0 1 0.6])
        plot(Mci(ix,:),'-', 'LineWidth',lw, 'Color', [0 0 0 0.6])
        X = [ones(len_c,1), Ms(ix,:)];
        w = X\Mci(ix,:);
        sepcross1 = X*w;

        plot(sep_cross,'-', 'LineWidth',lw, 'Color', [1 0 0 0.6])
        plot(Mr(ix,:),'-', 'LineWidth',lw, 'Color', [0 0 1 0.6])
        if ismember(p,[6]) 
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-90','0', '90'},'FontSize', fontsize1)
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        elseif ismember(p,[1,3])
            set(gca,'XTick', [])
            set(gca,'XTickLabel', [])
            set(gca,'YTick', ytck)
            set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
        elseif ismember(p,[5])
            set(gca,'XTick', xtck)
            set(gca,'XTickLabel', {'-90','0', '90'},'FontSize', fontsize1)
            set(gca,'YTick', ytck)
            set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
        else
            set(gca,'XTick', [2,4])
            set(gca,'XTickLabel', [])
            set(gca,'YTick',[])
            set(gca,'YTickLabel', [])
        end
        set(gca,'XLim',[0,91])
        set(gca,'YLim', [0,1])
        p = p+1;
        % if p==3
        %     legend('Causal Inf.', 'Separable', 'Relative');
        % end
        if ismember(p,[2,4,6])
            pos = get(ax, 'Position');
            pos(1) = pos(1) + 0.07; % Move left
            set(ax, 'Position', pos);
 
        end
    end
end
                %sgtitle("Neuron k:"+Tun{1}{t}+" SD:"+Tun{2}{t}+" Subj:"+string(n)+" Noise:"+string(ns), 'FontSize', fontsize1);
                %print(fig, "RelPred_4d"+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns)+"_CS"+string(c), saveformat);
print(fig, "AC_CompModel_cross_"+string(ix)+"_neur"+string(t)+"_subj"+string(n)+"_noise"+string(ns), saveformat);