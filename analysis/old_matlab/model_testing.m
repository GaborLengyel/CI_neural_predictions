%% selecting a speed combo and a subject
P = squeeze(neural_pred_mu(:,1,1,3,:,:));
s = size(P,1); n = size(P,2); m = size(P,3);
%% Defining alternative models for the seleceted surface
% separable model
C = ones(n,m);
BC = zeros(n*m,m);
BS = zeros(n*m,n);
for i=1:n
    i1=(i-1)*n+1;
    i2 = (i1-1)+n;
    BC(i1:i2,i) = C(:,i);
    B = zeros(n,1);
    B(i)=1;
    BS(:,i) = repmat(B,n,1);
end
X = [BC, BS];
for i=1:s
    w = X\reshape(squeeze(P(i,:,:)),[n*m,1]);
    P_sep(i,:,:) = reshape(X*w, [n,m]);
end

% Relative model
point = linspace(-180,180,361);
gap = 4;
dir_vec = point( 1: gap: end);
c_speed = 1;
s_speed = 1;

% Median neuron
R0= 3.4754 ; A=67.8693; alpha=0.0834; tau=-0.0040; n=0.5913*1; % new fit to neural data
R0_dir=-0.4730; kappa=1.4025*1; A_dir=71.7927; mu=0;% mu=14.4978;% For Cosyne poster we used mu=0.4978;
fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu, kappa) .* abs(neuron_speed_tuning(nu, R0, A, alpha, tau, n));

for i1 = 1:length(dir_vec) % surround direction
    for i2 = 1:length(dir_vec) % center direction
        angle1 = deg2rad(dir_vec(i1));
        angle2 = deg2rad(dir_vec(i2));
        x1 = s_speed * cos(angle1);
        y1 = s_speed * sin(angle1);
        x2 = c_speed * cos(angle2);
        y2 = c_speed * sin(angle2);
        dx = x2 - x1;
        dy = y2 - y1;
        direction = atan2d(dy, dx);
        speed = sqrt(dx^2 + dy^2);
        P_rel(i1,i2) = fr_joint(direction,speed);
    end
end
%% plotting
variable = {'Perceive', 'Retinal', 'Relative'};
%stat = {'mean', 'variance'};
saving = 1;
saveformat = '-dpdf';
paperPos = [0 0 31 6];
paperSize = [30, 5];
fontsize1 = 24;
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
l = size(neural_pred_mu,length(size(neural_pred_mu)));
xtck = round([1, l/4, l/2, (l*3)/4, l]);
cmax = 0.7;
for i=1:s
    subplot(1, s, i)
    imagesc(flip(squeeze(P(i,:,:)), 1))
    set(gca, 'CLim', [0 cmax]);
    % hold on
    % plot(x,y,'r-',"LineWidth",2)
    % hold off
    %colorbar
    %ylabel(' ', 'FontSize', fonsize1);
    %xlabel(' ', 'FontSize', fonsize1);
    set(gca,'XTick', xtck)
    set(gca,'XTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
    set(gca,'YTick', xtck)
    set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
    % set(gca,'XTick', [])
    % set(gca,'XTickLabel', [])
    % set(gca,'YTick',[])
    % set(gca,'YTickLabel', [])
    %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
end
print(fig{1}, "model_test_CI"+"_var"+variable{3}, saveformat);

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');

for i=1:s
    subplot(1, s, i)
    imagesc(flip(squeeze(P_sep(i,:,:)), 1))
    set(gca, 'CLim', [0 cmax]);
    % hold on
    % plot(x,y,'r-',"LineWidth",2)
    % hold off
    %colorbar
    %ylabel(' ', 'FontSize', fonsize1);
    %xlabel(' ', 'FontSize', fonsize1);
    if i==1
        set(gca,'YTick', xtck)
        set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
    else
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
    end
    set(gca,'XTick', [])
    set(gca,'XTickLabel', [])
    
    %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
end
print(fig{1}, "model_test_sep"+"_var"+variable{3}, saveformat);

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');

for i=1:s
    subplot(1, s, i)
    imagesc(flip(P_rel, 1))
    set(gca, 'CLim', [0 cmax]);
    % hold on
    % plot(x,y,'r-',"LineWidth",2)
    % hold off
    %colorbar
    %ylabel(' ', 'FontSize', fonsize1);
    %xlabel(' ', 'FontSize', fonsize1);
    if i==1
        set(gca,'YTick', xtck)
        set(gca,'YTickLabel', {'-180','-90','0', '90', '180'},'FontSize', fontsize1)
    else
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
    end
    set(gca,'XTick', [])
    set(gca,'XTickLabel', [])
    
    %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
end
print(fig{1}, "model_test_rel"+"_var"+variable{3}, saveformat);

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
ZERO = size(neural_pred_mu,length(size(neural_pred_mu)))/2;
x = ([-45,-20-10,-5,-2.5,0,2.5,5,10,20,45]/(360/90))+ZERO;
x = round(x);
Y={P,P_sep,P_rel};
for i=1:s
    subplot(1, s, i)
    hold on
    plot(x,squeeze(P(i,round(ZERO),x)),'k-o',"LineWidth", 4);
    plot(x,squeeze(P_sep(i,round(ZERO),x)),'r-o', "LineWidth", 4);
    plot(x,P_rel(round(ZERO),x),'g-o', "LineWidth", 4);
    ylabel('Predicted activty', 'FontSize', fontsize1);
    xlabel('Center direction (deg.)', 'FontSize', fontsize1);
    %set(gca,'XTick', 1:9)
    %set(gca,'XTickLabel', string(c_dir)+"/"+string(round(s_speed,2)))
    set(gca,'YTick',[0,0.2,0.4],'FontSize', fontsize1)
    %set(gca,'YTickLabel',["0",string(round(0.5*sqrt(mx),2)),string(round(sqrt(mx),2))])
    set(gca,'YLim',[0,0.41])
    
    %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
end
print(fig{1}, "model_test_1d_all"+"_var"+variable{3}, saveformat);
%%
subplot(2, 3, 4)
image(abs(flip(Y{1}-Y{3}, 1)), 'CDataMapping','scaled')
% hold on
% plot(x,y,'r-',"LineWidth",2)
% hold off
%colorbar
%ylabel(' ', 'FontSize', fonsize1);
%xlabel(' ', 'FontSize', fonsize1);
set(gca,'XTick', [])
set(gca,'XTickLabel', [])
set(gca,'YTick',[])
set(gca,'YTickLabel', [])
%title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);

subplot(2, 3, 5)
image(abs(flip(Y{2}-Y{3}, 1)), 'CDataMapping','scaled')
% hold on
% plot(x,y,'r-',"LineWidth",2)
% hold off
%colorbar
%ylabel(' ', 'FontSize', fonsize1);
%xlabel(' ', 'FontSize', fonsize1);
set(gca,'XTick', [])
set(gca,'XTickLabel', [])
set(gca,'YTick',[])
set(gca,'YTickLabel', [])
%title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);

fontsize1 = 26;
ZERO = size(neural_pred_mu,length(size(neural_pred_mu)))/2;
x = ([-45,-20-10,-5,-2.5,0,2.5,5,10,20,45]/(360/90))+ZERO;
x = round(x);
col = {"k","r","g"};
subplot(2, 3, 6)
for i=1:3
    y = Y{i};
    hold on
    plot(x,y(round(ZERO),x),'-o', "Color", col{i} ,"LineWidth", 4);
    ylabel('Predicted activty', 'FontSize', fontsize1);
    xlabel('Center direction (deg.)', 'FontSize', fontsize1);
    %set(gca,'XTick', 1:9)
    %set(gca,'XTickLabel', string(c_dir)+"/"+string(round(s_speed,2)))
    set(gca,'YTick',[0,0.5,1],'FontSize', fontsize1)
    %set(gca,'YTickLabel',["0",string(round(0.5*sqrt(mx),2)),string(round(sqrt(mx),2))])
    set(gca,'YLim',[0,1.1])
end
hold off
print(fig{1}, "model_test_CI_sep_rel_s5"+"_var"+variable{3}, saveformat);
