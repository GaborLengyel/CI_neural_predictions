% plotting params
saving = 1;
saveformat = '-dpdf';
paperPos = [0 0 16 16];
paperSize = [16, 16];
l = length(dir_vec);
xtck = round([1, l/4, l/2, (l*3)/4, l]);
ytck = [0,0.5,1];
%ix = 23;
lw=15;
fontsize1 = 50;
xtck = [l/4, l/2, (l*3)/4];

% neuron tuning profiles
neuronTypes = {{3, 0, 0.5, 1, 0.5913},...
                {3, 0, 2, 1, 0.5913},...
                {3, 0, 8, 1, 0.5913},...
                {3, 0, 0.5, 0.3, 0.5913},...
                {3, 0, 2, 0.3, 0.5913},...
                {3, 0, 8, 0.3, 0.5913},...
                {3, 0, 0.5, 0.1,0.5913},...
                {3, 0, 2, 0.1, 0.5913},...
                {3, 0, 8, 0.1, 0.5913}};
% Relative model
point = linspace(-180,180,361);
gap = 4;

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
            n3_m-(n3_sd/2), n3_m-(n3_sd/4), n3_m, n3_m+n3_sd, n3_m+(2*n3_sd)];
% Median neuron
R0= 3.4754 ; A=67.8693;  tau=-0.0040; % new fit to neural data
R0_dir=-0.4730;  A_dir=71.7927; % For Cosyne poster we used mu=0.4978;


xdir = deg2rad(dir_vec);
xfine = linspace(min(xdir), max(xdir), 300);

% plotting and fitting

%IX = [[33,59]; [34,58]; [35,57]; [36,56]; [37,55]; [38,54]; [39,53]; [40,52]; [41,51]; [41,51]; [42,50];[43,49];[44,48]; [45,47]];
%IX = [[41,51]; [42,50];[43,49];[44,48]; [45,47]];
ix = 45;

fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
i=3;j=3;
hold on

for n=1:5

for t=[3,5,7]
    neuronType = neuronTypes{t};
    mu_ = neuronType{2};
    kappa_ = neuronType{3};
    alpha_ = neuronType{4};
    n_ = neuronType{5};
    fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu_, kappa_) .* abs(neuron_speed_tuning(nu, R0, A, alpha_, tau, n_));

    Mci = squeeze(meanfire(t,n,1,i,j,:,:));

    CI = Mci(:,ix);
    plot(CI,'-', 'LineWidth',lw)

end
end
set(gca,'XTick', xtck)
set(gca,'XTickLabel', {'-90','0', '90'},'FontSize', fontsize1)
set(gca,'YTick', ytck)
set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
set(gca,'XLim',[0,91])
set(gca,'YLim', [0,1])
print(fig, "CIcross_all", saveformat);

%%
fontsize1 = 120;
ix = 56;
%ls1 = {"c-","c--","c:","c:","c:"};
%ls2 = {"m-","m--","m:","m:","m:"};
c1 = [0 0 1; 0.3010 0.7450 0.9330;0 1 1;0 1 1;0 1 1];
c2 = [[0.6350 0.0780 0.1840];0.4940 0.1840 0.5560; 0.3010 0.7450 0.9330;1 0 1;1 0 1;1 0 1];
lw = 24;
p = 1;
i=3;j=3;
fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
hold on
for n=[1,2,5]

for t=[5]

    Mci = squeeze(meanfire(t,n,1,i,j,:,:));
    CI = Mci(:,ix);
    Ms = squeeze(predSep(t,n,1,i,j,:,:));
    sep = Ms(:,ix);
    Mr = squeeze(predRel(t,n,1,i,j,:,:));
    rel = Mr(:,ix);
    %plot(CI,'-','Color',c1(n,:), 'LineWidth',lw)
    plot(sep,'-','Color',c2(n,:), 'LineWidth',lw)
    %plot(rel,'-', 'LineWidth',lw)

end

set(gca,'XTick', xtck)
set(gca,'XTickLabel', {'-90','0', '90'},'FontSize', fontsize1)
set(gca,'YTick', ytck)
set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
set(gca,'XLim',[0,91])
set(gca,'YLim', [0,1])
end
print(fig, "Sepcross_all"+"_subj"+string(n), saveformat);

%%
fontsize1 = 120;
ix = 30;
%ls1 = {"c-","c--","c:","c:","c:"};
%ls2 = {"m-","m--","m:","m:","m:"};
c1 = [0 0 1; 0.3010 0.7450 0.9330;0 1 1;0 1 1;0 1 1];
c2 = [[0.6350 0.0780 0.1840];0.4940 0.1840 0.5560; 0.3010 0.7450 0.9330;1 0 1;1 0 1;1 0 1];
lw = 24;
p = 1;
i=3;j=3;

for n=[2,5]
fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
hold on
for t=[5]

    Mci = squeeze(meanfire(t,n,1,i,j,:,:));
    CI = Mci(:,ix);
    Ms = squeeze(predSep(t,n,1,i,j,:,:));
    sep = Ms(:,ix);
    Mr = squeeze(predRel(t,n,1,i,j,:,:));
    rel = Mr(:,ix);
    plot(CI,'b-', 'LineWidth',lw)
    plot(rel,'k-', 'LineWidth',lw)
    %plot(rel,'-', 'LineWidth',lw)

end

set(gca,'XTick', xtck)
set(gca,'XTickLabel', {'-90','0', '90'},'FontSize', fontsize1)
set(gca,'YTick', ytck)
set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
set(gca,'XLim',[0,91])
set(gca,'YLim', [0,1])

print(fig, "Compcross_all"+"_subj"+string(n), saveformat);
end
%%
for n=1:5
fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
i=3;j=3;
hold on
for t=[3,5,7]
    neuronType = neuronTypes{t};
    mu_ = neuronType{2};
    kappa_ = neuronType{3};
    alpha_ = neuronType{4};
    n_ = neuronType{5};
    fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu_, kappa_) .* abs(neuron_speed_tuning(nu, R0, A, alpha_, tau, n_));

    Mci = squeeze(meanfire(t,n,1,i,j,:,:));

    CI = Mci(:,ix);
    plot(CI,'-', 'LineWidth',lw)

end

set(gca,'XTick', xtck)
set(gca,'XTickLabel', {'-90','0', '90'},'FontSize', fontsize1)
set(gca,'YTick', ytck)
set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
set(gca,'XLim',[0,91])
set(gca,'YLim', [0,1])
print(fig, "CIcross_all"+"_subj"+string(n), saveformat);
end

%%

col = {"k","r","b","g","y","c","c"};
for n=1:5

for t=[3,5,7]

    fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');

    hold on

    neuronType = neuronTypes{t};
    mu_ = neuronType{2};
    kappa_ = neuronType{3};
    alpha_ = neuronType{4};
    n_ = neuronType{5};
    fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu_, kappa_) .* abs(neuron_speed_tuning(nu, R0, A, alpha_, tau, n_));
    for i=1:5
        Mci = squeeze(meanfire(t,n,1,i,:,3,45));
        plot(speed_vec(t,:), Mci,'-', 'LineWidth',lw,'Color',col{i})
    end
    set(gca,'XTick', speed_vec(t,:))
    set(gca,'XTickLabel', speed_vec(t,:),'FontSize', fontsize1)
    set(gca,'YTick', ytck)
    set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
    set(gca,'XLim',[0,max(speed_vec(t,:))])
    set(gca,'YLim', [0,1])
    sgtitle("Neuron#"+string(t)+" Subj#"+string(n), 'FontSize', fontsize1);
    print(fig, "CIcross_speed"+"_subj"+string(n)+"_neur"+string(t), saveformat);
    hold off


    fig2 = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
    p = 1;
    for i = 1:5
        for j = 1:5
    
            subplot(5, 5, p)
            hold on
            %imagesc(flip(squeeze(meanfire(t,n,ns,c,i,j,:,:)), 1))
            imagesc(flip(squeeze(meanfire(t,n,1,i,j,:,:)), 1))
            %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
            %colorbar
            %ylabel(' ', 'FontSize', fonsize1);
            %xlabel(' ', 'FontSize', fonsize1);
            plot(45,3,'o', 'MarkerSize',15,'Color',col{i})
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
            hold off
            p = p+1;
    
        end
    end
    sgtitle("Neuron k:"+string(t)+" Subj:"+string(n), 'FontSize', fontsize1);

end
end

%%

col = {"k","r","b","g","y","c","c"};
for n=1:5

for t=[3,5,7]

    fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');

    hold on

    neuronType = neuronTypes{t};
    mu_ = neuronType{2};
    kappa_ = neuronType{3};
    alpha_ = neuronType{4};
    n_ = neuronType{5};
    fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu_, kappa_) .* abs(neuron_speed_tuning(nu, R0, A, alpha_, tau, n_));
    ii=1;
    for i=[1,22,45,67,90]
        Mci = squeeze(meanfire(t,n,1,3,3,i,:));
        plot(Mci,'-', 'LineWidth',lw,'Color',col{ii})
        ii = ii+1;
    end
    set(gca,'XTick', xtck)
    set(gca,'XTickLabel',  {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
    set(gca,'YTick', ytck)
    set(gca,'YTickLabel', {'0','0.5','1'},'FontSize', fontsize1)
    set(gca,'XLim',[0,91])
    set(gca,'YLim', [0,1])
    sgtitle("Neuron#"+string(t)+" Subj#"+string(n), 'FontSize', fontsize1);
    print(fig, "CIcross_dir"+"_subj"+string(n)+"_neur"+string(t), saveformat);
    hold off


    fig2 = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
    p = 1;
    for i = 1:5
        for j = 1:5
    
            subplot(5, 5, p)
            hold on
            %imagesc(flip(squeeze(meanfire(t,n,ns,c,i,j,:,:)), 1))
            imagesc(flip(squeeze(meanfire(t,n,1,i,j,:,:)), 1))
            %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
            %colorbar
            %ylabel(' ', 'FontSize', fonsize1);
            %xlabel(' ', 'FontSize', fonsize1);
            plot([45,45],[1,91],'-', 'LineWidth',lw-5,'Color',col{i})
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
            hold off
            p = p+1;
    
        end
    end
    sgtitle("Neuron k:"+string(t)+" Subj:"+string(n), 'FontSize', fontsize1);

end
end