%[P_var, P_mean] = var(squeeze(mean(squeeze(neural_pred(:,:,2,2,:,:,:)),1)),0,4);
l = size(dir_post,5);
xtck = round([1, l/4, l/2, (l*3)/4, l]);
for s=1:5
[P_d_var, P_d_mean] = var(squeeze(squeeze(dir_post(s,2,2,:,:,:))),0,3);
[P_s_var, P_s_mean] = var(squeeze(squeeze(spe_post(s,2,2,:,:,:))),0,3);
Y = {P_d_var, P_d_mean, P_s_var, P_s_mean};
figure;
for j = 1:4
    if j==1
        clim = [0 160];
    elseif j==2
        clim = [-180 180];
    elseif j==3
        clim = [0 0.001];
    elseif j==4
        clim = [0 4];
    end
    subplot(2, 2, j)
    imagesc(flip(Y{j}, 1))
    set(gca, 'CLim', clim);
    %ylabel(' ', 'FontSize', fonsize1);
    %xlabel(' ', 'FontSize', fonsize1);
    set(gca,'XTick', [])
    set(gca,'XTickLabel', [])
    set(gca,'YTick',[])
    set(gca,'YTickLabel', [])
    %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
end
figure;
for j = 1:4
    subplot(2, 2, j)
    plot(Y{j}(:, 1))
    %ylabel(' ', 'FontSize', fonsize1);
    %xlabel(' ', 'FontSize', fonsize1);
    set(gca,'XTick', xtck)
    set(gca,'XTickLabel', {'-180','-90','0', '90', '180'})
    %set(gca,'YTick',[])
    %set(gca,'YTickLabel', [])
end
end

deg45 = round(l/2+l/8);
surrDir = round(l/2):deg45-1;
figure;
plot(x,squeeze(squeeze(dir_post(1,2,2,2,deg45,:))))



% Define the x-axis values
x = 1:10;

% Define the data for three 1D plots
y1 = sin(x);
y2 = cos(x);
y3 = tan(x);

% Create a new figure
figure;

% Create a larger axis for positioning the smaller rotated plots
largerAxis = axes;
for i=1:length(surrDir)
    % Plot the first rotated plot
    smallAxis = axes('Position', [i/length(surrDir), 0.6, 0.25, 0.25]);
    [bandwidth, density, xmesh] = ksdensity(squeeze(squeeze(dir_post(1,2,2,surrDir(i),deg45,:))), 'Bandwidth', 1, 'Kernel', 'normal');

    plot(smallAxis, xmesh, density, 'r-'); % Red line
    %xlabel(smallAxis1, 'Y-Axis Label');
    %ylabel(smallAxis1, 'X-Axis Label');
    %title(smallAxis1, 'sin(x)');
    set(smallAxis, 'YTickLabel', []);
    set(smallAxis, 'XTick', xtck);
    set(smallAxis, 'XTickLabel',  {'-180','-90','0', '90', '180'});
    axis(smallAxis, 'off');
    %view(smallAxis, [90, 90]); % Rotate subplot by 90 degrees
end

% Set limits for the larger axis
xlim(largerAxis, [0, 10]); % Customize X-axis limits
%ylim(largerAxis, [0,91]); % Customize Y-axis limits

% Hide tick labels and axis for the larger axis
%%
save('post_dir_relVar_subj2.mat','dir_post', "-v7.3")
save('post_spe_relVar_subj2.mat','spe_post', "-v7.3")