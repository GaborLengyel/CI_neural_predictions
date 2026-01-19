len_c =size(meanfire,7);
len_s =size(meanfire,6);
len_s_speed=size(meanfire,4);
len_c_speed=size(meanfire,5);
len_subj = size(meanfire,2);
len_neuron = size(meanfire,1);
len_noise = size(meanfire,3);
%len_cause = size(meanfire,4);

% Classic divisive normalization model
C = ones(len_c,len_c);
%B = zeros(len_c,len_c);
%[C,S] = meshgrid(xr,xr);
BC = zeros(len_c*len_s,len_c);
BS = zeros(len_c*len_s,len_s);
for i=1:len_c
    i1=(i-1)*len_c+1;
    i2 = (i1-1)+len_c;
    BC(i1:i2,i) = C(:,i);
    B = zeros(len_c,1);
    B(i)=1;
    BS(:,i) = repmat(B,len_c,1);
end
X = [BC, BS];

% Neurons types for the relative model
% neuronTypes = {{0, 0.4, 0.1, 0.5913},...
%     {0, 0.4, 1, 0.5913},...
%     {0, 0.4, 0.3, 0.5913},...
%     {0, 0.4, 0.06, 1},...
%     {0, 0.4, 0.07, 0.1},...
%     {0, 8, 0.1, 0.5913},...
%     {0, 8, 1, 0.5913},...
%     {0, 8, 0.3, 0.5913},...
%     {0, 8, 0.06, 1},...
%     {0, 8, 0.07, 0.1}};
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

% fitting the models
%predSep = zeros(len_neuron,len_subj,len_noise,len_cause,len_s_speed,len_c_speed,len_c,len_s);
%predRel = zeros(len_neuron,len_subj,len_noise,len_cause,len_s_speed,len_c_speed,len_c,len_s);
predSep = zeros(len_neuron,len_subj,len_noise,len_s_speed,len_c_speed,len_c,len_s);
predRel = zeros(len_neuron,len_subj,len_noise,len_s_speed,len_c_speed,len_c,len_s);
for t=1:len_neuron
    neuronType = neuronTypes{t};
    mu_ = neuronType{2};
    kappa_ = neuronType{3};
    alpha_ = neuronType{4};
    n_ = neuronType{5};
    fr_joint = @(theta1,nu) neuron_dir_VonMisses_tuning(theta1, R0_dir, A_dir, mu_, kappa_) .* abs(neuron_speed_tuning(nu, R0, A, alpha_, tau, n_));
    for n=1:len_subj
        for ns=1:len_noise
            %for c=1:len_cause
    
                for i=1:len_s_speed % speed surround
                    for j=1:len_c_speed % speed center
                        y = reshape(meanfire(t,n,ns,i,j,:,:),[len_c*len_s,1]);
                        %y(isnan(y)) = 0;
                        w=X\y;
                        predSep(t,n,ns,i,j,:,:) = reshape(X*w,[len_s,len_c]);
                        relActivity = zeros(len_s,len_c);
                        for i1 = 1:len_c % surround direction
                            for i2 = 1:len_s % center direction
                                angle1 = deg2rad(dir_vec(i1));
                                angle2 = deg2rad(dir_vec(i2));
                                x1 = speed_vec(t,i) * cos(angle1);
                                y1 = speed_vec(t,i) * sin(angle1);
                                x2 = speed_vec(t,j) * cos(angle2);
                                y2 = speed_vec(t,j) * sin(angle2);
                                dx = x2 - x1;
                                dy = y2 - y1;
                                direction = atan2d(dy, dx);
                                speed = sqrt(dx^2 + dy^2);
                                relActivity(i1,i2) = fr_joint(direction,speed);
                            end
                        end
                        %imagesc(relActivity)
                        Xrel = [ones(len_c*len_s,1), reshape(relActivity,[len_c*len_s,1])];
                        w = Xrel\y; 
                        predRel(t,n,ns,i,j,:,:) = reshape(Xrel*w,[len_s,len_c]);
                    end
                end
            %end
        end
    end
end

save('AlternativeFire_All.mat',"-v7.3")

