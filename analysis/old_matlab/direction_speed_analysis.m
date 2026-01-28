%Computing relative direction and speed
point = linspace(-180,180,361);
gap = 4;
dir_vec = point( 1: gap: end);
speed_vec = [1/8, 1/4, 1, 4, 16];
c_speed = 1;
s_speed = 1;

% Median neuron
% R0= 3.4754 ; A=67.8693; alpha=0.0834; tau=-0.0040; n=0.5913*1; % new fit to neural data
% R0_dir=-0.4730; kappa=1.4025*1; A_dir=71.7927; mu=0;% mu=14.4978;% For Cosyne poster we used mu=0.4978;
% fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu, kappa) .* abs(neuron_speed_tuning(nu, R0, A, alpha, tau, n));
direction = zeros(length(speed_vec),length(speed_vec),length(dir_vec),length(dir_vec));
speed = zeros(length(speed_vec),length(speed_vec),length(dir_vec),length(dir_vec));
for s1=1:length(speed_vec)
    for s2=1:length(speed_vec)
        for i1 = 1:length(dir_vec) % surround direction
            for i2 = 1:length(dir_vec) % center direction
                angle1 = deg2rad(dir_vec(i1));
                angle2 = deg2rad(dir_vec(i2));
                x1 = speed_vec(s1) * cos(angle1);
                y1 = speed_vec(s1) * sin(angle1);
                x2 = speed_vec(s2) * cos(angle2);
                y2 = speed_vec(s2) * sin(angle2);
                dx = x2 - x1;
                dy = y2 - y1;
                direction(s1,s2,i1,i2) = atan2d(dy, dx);
                speed(s1,s2,i1,i2) = sqrt(dx^2 + dy^2);
                %P_rel(i1,i2) = fr_joint(direction,speed);
            end
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
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
for i = size(direction,1):-1:1
    for j = 1:size(direction,2)

        subplot(size(direction,1), size(direction,2), p)
        imagesc(180-abs(0-flip(squeeze(direction(i,j,:,:)), 1)))
        %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca, 'CLim', [0,180]);
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
print(fig{1}, "relative_directions_4d", saveformat);
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
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
for i = size(direction,1):-1:1
    for j = 1:size(direction,2)

        subplot(size(direction,1), size(direction,2), p)
        imagesc((speed_vec(i)+speed_vec(j))-abs(1-flip(squeeze(speed(i,j,:,:)), 1)))
        %image(flip(squeeze(neural_pred_mu(s,c,i,j,:,:)), 1), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca, 'CLim', [0,speed_vec(i)+speed_vec(j)]);
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
print(fig{1}, "relative_speeds_4d", saveformat);
%%
% using median neuron tuning
% assuming that direction =0 is the preferred direction
% assuming that speed=7 is the preffered speed
% Then we only vary the width of the tuning curve

Von_Tuning = @(x,A,theta0,sigma,B) A*exp(-2*(1-cos((x - theta0)*pi/180))/sigma.^2) + B;
%Von_Tuning = @(x,theta0,kappa) exp( kappa * (cos( (x-theta0)/180*pi ) -1 ) );
Speed_Tuning = @(x,B,A,nu0,sigma,BL) B + A*exp( -1/2/sigma^2*(log( (x+BL)/(nu0+BL))).^2);
R0= 3.4754 ; A=67.8693; alpha=0.0834; tau=-0.0040; n=0.5913*1; % new fit to neural data
R0_dir=-0.4730;  A_dir=71.7927;  mu=0;  kappa=1.4025*1; % For Cosyne poster we used mu=0.4978;
fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu, kappa) .* abs(neuron_speed_tuning(nu, R0, A, alpha, tau, n));

speed_v = linspace(0,20,100);
figure;
hold on
for i=linspace(0,1,10)
    plot(speed_v,neuron_speed_tuning(speed_v, R0, A, i, tau, n),'k-')
end
m11 = 1.2913;
figure;
hold on
plot(speed_v,neuron_speed_tuning(speed_v, R0, A, 0.1, tau, m11),'r-')
plot(speed_v,neuron_speed_tuning(speed_v, R0, A, 1, tau, m11),'k-')
plot(speed_v,neuron_speed_tuning(speed_v, R0, A, 0.3, tau, m11),'b-')
%plot(speed_v,neuron_speed_tuning(speed_v, R0, A, 0.06, tau, 1),'g-')
%plot(speed_v,neuron_speed_tuning(speed_v, R0, A, 0.07, tau, 0.1),'y-')

figure;
hold on
for i=linspace(-10,0,10)
    plot(speed_v,neuron_speed_tuning(speed_v, R0, A, 0.01, i, n),'k-')
end


for i=linspace(0,1,10)
figure;
hold on
    for j=linspace(-10,0,10)
    plot(speed_v,neuron_speed_tuning(speed_v, R0, A, i, j, n),'k-')
    end
end

figure;
hold on
for i=linspace(0,1,10)
    plot(speed_v,neuron_speed_tuning(speed_v, 3, A, 0.1, 0, i),'k-')
end

figure;
hold on
for i=linspace(0.4,15,3)
    plot(dir_vec,neuron_dir_VonMisses_tuning(dir_vec, R0_dir, A_dir, 0, i),'k-')
end

neuronTypes = {{3, 0, 0.5, 0.1, 0.5913},...
                {3, 0, 2, 1, 0.5913},...
                {3, 0, 8, 0.3, 0.5913},...
                {3, 0, 0.5, 0.06, 1},...
                {3, 0, 2, 0.07, 0.1},...
                {3, 0, 8, 0.1, 0.5913},...
                {3, 0, 0.5, 0.06, 1},...
                {3, 0, 2, 0.07, 0.1},...
                {3, 0, 8, 0.1, 0.5913}};
neuronTypes = {{3, 0, 0.5, 1, 0.5913},...
                {3, 0, 2, 1, 0.5913},...
                {3, 0, 8, 1, 0.5913},...
                {3, 0, 0.5, 0.3, 0.5913},...
                {3, 0, 2, 0.3, 0.5913},...
                {3, 0, 8, 0.3, 0.5913},...
                {3, 0, 0.5, 0.1,0.5913},...
                {3, 0, 2, 0.1, 0.5913},...
                {3, 0, 8, 0.1, 0.5913}};

R0= 3.4754 ; A=67.8693;  tau=-0.0040; % new fit to neural data
R0_dir=-0.4730;  A_dir=71.7927; % For Cosyne poster we used mu=0.4978;
colors = [
    1.0, 0.0, 0.0; % Red
    0.0, 1.0, 0.0; % Green
    0.0, 0.0, 1.0; % Blue
    1.0, 1.0, 0.0; % Yellow
    0.0, 1.0, 1.0; % Cyan
    1.0, 0.0, 1.0; % Magenta
    0.5, 0.0, 0.0; % Dark Red
    0.0, 0.5, 0.0; % Dark Green
    0.0, 0.0, 0.5; % Dark Blue
    0.75, 0.75, 0.75; % Grey
];

speed_v = linspace(0,20,1000);
dir_vec = linspace(-180,180,1000);
figure;
hold on
D = zeros(6,1000);
i=1;
for n=1:9
    neuronType = neuronTypes{n};
    mu_ = neuronType{2};
    kappa_ = neuronType{3};
    alpha_ = neuronType{4};
    n_ = neuronType{5};
    yyy = neuron_speed_tuning(speed_v, R0, A, alpha_, tau, n_);
    plot(speed_v,yyy,'-','Color',colors(n,:))
   
    samples = randsample(speed_v, 100000, true, yyy/sum(yyy));
    disp(std(samples,0,"all"));
    [M,I] = max(yyy,[],"all");
    disp("Ix:")
    disp(speed_v(I));
    if ismember(n, [1, 4, 7])
        D(i,:) = yyy;
        i = i+1;
    end
end

figure;
hold on
i=4;
for n=1:5
    neuronType = neuronTypes{n};
    mu_ = neuronType{2};
    kappa_ = neuronType{3};
    alpha_ = neuronType{4};
    n_ = neuronType{5};
    yyy = neuron_dir_VonMisses_tuning(dir_vec, R0_dir, A_dir, mu_, kappa_);
    plot(dir_vec,yyy,'-','Color',colors(n,:))
    if ismember(n, [1, 2, 3])
        D(i,:) = yyy;
        i = i+1;
    end
end
figure;
plot(D(1:3,:)')

figure;
plot(D(4:end,:)')
save('tuning_prof.mat','D',"-v7.3")