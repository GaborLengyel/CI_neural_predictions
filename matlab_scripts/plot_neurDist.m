
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
for s=2 % loop over subject
for c=1:2
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
for i = size(neural_pred_mu,3):-1:1
    for j = 1:size(neural_pred_mu,4)

        subplot(size(neural_pred_mu,4), size(neural_pred_mu,3), p)
        hist(squeeze(neural_pred(s,c,i,j,round(l/2),round(l/2),:)),20)
        %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        % set(gca, 'CLim', [0 1]);
        % if ismember(p,tckj) 
        %     set(gca,'XTick', xtck)
        %     set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        %     set(gca,'YTick',[])
        %     set(gca,'YTickLabel', [])
        % elseif ismember(p,tcki)
        %     set(gca,'XTick', [])
        %     set(gca,'XTickLabel', [])
        %     set(gca,'YTick', xtck)
        %     set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        % elseif ismember(p,tckij)
        %     set(gca,'XTick', xtck)
        %     set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        %     set(gca,'YTick', xtck)
        %     set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
        % else
        %     set(gca,'XTick', [])
        %     set(gca,'XTickLabel', [])
        %     set(gca,'YTick',[])
        %     set(gca,'YTickLabel', [])
        % end
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p = p+1;

    end
end

%print(fig{1}, "PredMean2d_oppNeur_stim1_tck"+"_var"+variable{2}+"_"+"subj"+string(s)+"_"+"CS"+string(c), saveformat);
end
end