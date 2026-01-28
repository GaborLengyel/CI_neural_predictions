close all

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
s=2;% loop over subject
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
for i = size(neural_pred_mu,3):-1:1
    for j = 1:size(neural_pred_mu,4)
        % p1 = reshape(flip(squeeze(neural_pred(s,1,i,j,:,:,:)), 1), [size(neural_pred,5)*size(neural_pred,6), size(neural_pred,7)])';
        % p2 = reshape(flip(squeeze(neural_pred(s,2,i,j,:,:,:)), 1), [size(neural_pred,5)*size(neural_pred,6), size(neural_pred,7)])';
        % p3 = [p1,p2];
        % r = corrcoef(p3);
        % r_ = r(1:size(p1,2),size(p1,2)+1:end);
        R = zeros(size(neural_pred_mu,5),size(neural_pred_mu,6));
        for i2 = 1:size(neural_pred_mu,5)
            for j2 = 1:size(neural_pred_mu,6)
                s1 = squeeze(neural_pred(s,1,i,j,i2,j2,:));
                s2 = squeeze(neural_pred(s,2,i,j,i2,j2,:));
                s3 = squeeze(neural_pred_opp(s,1,i,j,i2,j2,:));
                s4 = squeeze(neural_pred_opp(s,2,i,j,i2,j2,:));
                x = [s1(randi(length(s1),[100,1])); s2(randi(length(s1),[1,100]))];
                y = [s3(randi(length(s1),[100,1])); s4(randi(length(s1),[1,100]))];
                r = corrcoef(x,y);
                R(i2,j2) = r(1,2);
            end
        end
        subplot(size(neural_pred_mu,4), size(neural_pred_mu,3), p)
        imagesc(flip(R,1))
        %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca, 'CLim', [-1 1]);
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
print(fig{1}, "NoiseR_oppNeuron_2d_stim1_tck"+"_var"+variable{3}+"_"+"subj"+string(s), saveformat);