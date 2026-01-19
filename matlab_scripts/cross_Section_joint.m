% plotting params
saving = 1;
saveformat = '-dpdf';
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];
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


xdir = [deg2rad(dir_vec) deg2rad(dir_vec)];
xfine = linspace(min(xdir), max(xdir), 300);
% plotting and fitting
IX = [38,57];
for n=1:5
fig = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p = 1;
i=3;j=3;
for t=[3,5,7]
    neuronType = neuronTypes{t};
    mu_ = neuronType{2};
    kappa_ = neuronType{3};
    alpha_ = neuronType{4};
    n_ = neuronType{5};
    fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu_, kappa_) .* abs(neuron_speed_tuning(nu, R0, A, alpha_, tau, n_));
    
    loss = inf;
    Y = [Mci(:,IX(1))' Mci(:,IX(1))'];
    for mu=linspace(-pi,pi,100)
        % Initial guess for parameters [mu, kappa, scale, bias]
        initialGuess = [mu, 1, 1, 0.1, 1, 0.1];
        
        % Bounds for mu and kappa
        lb = [-pi, 0, -100, -100, -100, -100]; % Lower bounds
        ub = [pi, 200, 100, 100, 100, 100]; % Upper bounds
        
        % Options for fmincon
        options = optimoptions('fmincon', 'Display', 'iter', 'Algorithm', 'sqp');
        
        % Minimize the objective function
        [optParams, fval] = fmincon(@(params) vonMisesSSE(params, xdir', Y', len_c), ...
                                    initialGuess, [], [], [], [], lb, ub, [], options);
        if fval < loss
            finalParams = optParams;
            loss = fval;
        end
    end

    for ix = IX
        ax = subplot(3, 2, p);
        hold on
        Mci = squeeze(meanfire(t,n,1,i,j,:,:));
        Ms = squeeze(predSep(t,n,1,i,j,:,:));
        Mr = squeeze(predRel(t,n,1,i,j,:,:));
        plot(Mci(:,ix),'-', 'LineWidth',lw, 'Color', [0 0 0 0.6])
        % Extract optimized parameters
        if ix==IX(1)
            fp = finalParams(1:4);
        else
            fp = [finalParams(1:2) finalParams(5:6)];
        end
        %yfit = vonMisesFun(fp, deg2rad(dir_vec));
        %plot(yfit,'-', 'LineWidth',lw, 'Color', [1 0 0 0.6])

        for i1 = 1:len_s % center direction
            angle1 = deg2rad(dir_vec(i1));
            angle2 = deg2rad(dir_vec(ix));
            x1 = speed_vec(t,i) * cos(angle1);
            y1 = speed_vec(t,i) * sin(angle1);
            x2 = speed_vec(t,j) * cos(angle2);
            y2 = speed_vec(t,j) * sin(angle2);
            dx = x2 - x1;
            dy = y2 - y1;
            direction = atan2d(dy, dx);
            speed = sqrt(dx^2 + dy^2);
            relActivity(i1) = fr_joint(direction,speed);
        end
    
        Xrel = [ones(len_s,1), relActivity'];
        w = Xrel\Mci(:,ix); 

        plot(Xrel*w,'-', 'LineWidth',lw, 'Color', [0 0 1 0.6])
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


% Define the von Mises PDF as a custom model for curve fitting
function sse = vonMisesSSE(params, x, y, c)
    mu = params(1);
    kappa = params(2);
    s1 = params(3);
    b1 = params(4);
    s2 = params(5);
    b2 = params(6);
    % Ensure kappa is positive
    kappa = abs(kappa);

    % Calculate the von Mises probability densities
    predicted_y1 = s1 * (exp(kappa * cos(x(1:c) - mu)) / (2 * pi * besseli(0, kappa))) + b1;
    predicted_y2 = s2 * (exp(kappa * cos(x(c+1:end) - mu)) / (2 * pi * besseli(0, kappa))) + b2;
    % Sum of squared errors
    sse = sum((y - [predicted_y1' predicted_y2']').^2);
end

% Define the von Mises PDF as a custom model for curve fitting
function y = vonMisesFun(params, x)
    mu = params(1);
    kappa = params(2);
    s = params(3);
    b = params(4);
    % Ensure kappa is positive
    kappa = abs(kappa);

    % Calculate the von Mises probability densities
    y = s * (exp(kappa * cos(x - mu)) / (2 * pi * besseli(0, kappa))) + b;
end