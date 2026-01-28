%%%%%%%%%%%%%%%%%%%%%%%%%%%% plotting the results %%%%%%%%%%%%%
%load('neural_pred_median_neuron_1.mat') 
close all

variable = {'Perceive', 'Retinal', 'Relative'};
causalLab = {'CS1', 'CS2', 'CS3','CS4'};
%stat = {'mean', 'variance'};
saving = 1;
saveformat = '-dpdf';
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];
% fonsize1 = 16;
% fonsize2 = 32;


for c=[2,4]
for sn=1:size(neural_pred_mu,2)
for cn=1:size(neural_pred_mu,3)
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
%colormap(flipud(gray))
clim([0,1])
p = 1;

for i = size(neural_pred_mu,5):-1:1
    for j = 1:size(neural_pred_mu,5)

        subplot(size(neural_pred_mu,5), size(neural_pred_mu,4), p)
        image(flip(squeeze(neural_pred_mu(c,sn,cn,i,j,:,:)), 1), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca,'XTick', [])
        set(gca,'XTickLabel', [])
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p = p+1;

    end
end

print(fig{1}, "NewPredMean2d"+"_var"+variable{3}+"_"+causalLab{c}+"_cNoise"+string(cn)+"_sNoise"+string(sn), saveformat);
end
end
end