% Parameters
sz = 8;               % Size of the matrix (8x8)
% plotting params
saving = 1;
saveformat = '-dpdf';
paperPos = [0 0 6 26];
paperSize = [6, 26];
lw = 2;
fontsize1 = 12;

fig7 = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p=1;
for f=[1,2]
    for a=[180,45,90,135]
        for ph=[0,1]
            frequency = f;          % Spatial frequency (cycles per unit length)
            angle = a;             % Angle of the grating in degrees
            phase = ph;              % Phase of the grating (radians)

            % Create coordinate system
            [x, y] =  meshgrid(linspace(-1, 1, sz), linspace(-1, 1, sz));
            
            % Convert angle to radians
            theta = deg2rad(angle);
            
            % Calculate the grating
            grating = cos(2 * pi * frequency * (x * cos(theta) + y * sin(theta)) + phase);
            subplot(16,2,p)
            imagesc(grating);
            
            colorbar;
            axis equal tight;
            title(['Grating Stimulus - Angle: ', num2str(angle), '°, Frequency: ', num2str(frequency), ', Phase: ', num2str(phase)]);
            subplot(16,2,p+1)
            theta=1:179;
            [R, xp] = radon(grating,theta);
            
            % Display the Radon transform
            imagesc(theta,xp, R);
            xlabel('\theta (degrees)');
            ylabel('x''');
            title('Radon Transform');
            
            colorbar;
            p = p+2;
        end
    end
end
print(fig7, "radonGrating", saveformat);

paperPos = [0 0 8 56];
paperSize = [8, 56];
fig8 = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p=1;
for m1=[1,4,6]
    for m2=[1,4,6]
        for v1=1:2
            for v2=1:2
                mean1 = [m1,m1]; mean2=[m2,m2];        
                variance1 = [v1,v2]; variance2 = [v1,v2];             
                % Create coordinate system
                [x, y] = meshgrid(1:sz, 1:sz);
    
                % Calculate the first Gaussian blob
                gaussian1 = exp(-((x - mean1(1)).^2 / (2 * variance1(1)) + (y - mean1(2)).^2 / (2 * variance1(2))));
    
                % Calculate the second Gaussian blob
                gaussian2 = exp(-((x - mean2(1)).^2 / (2 * variance2(1)) + (y - mean2(2)).^2 / (2 * variance2(2))));
    
                % Combine the two Gaussian blobs into one matrix
                combined_gaussian = gaussian1 + gaussian2;
    
                subplot(36,2,p)
                imagesc(combined_gaussian);
                
                colorbar;
                axis equal tight;
                subplot(36,2,p+1)
                theta=1:179;
                [R, xp] = radon(combined_gaussian,theta);
                
                % Display the Radon transform
                imagesc(theta,xp, R);
                xlabel('\theta (degrees)');
                ylabel('x''');
                
                colorbar;
                p = p+2;
            end
        end
    end
end
print(fig8, "radonBlobsAntiD", saveformat);

fig8 = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p=1;
for m1=[1,4,6]
    for m2=[1,4,6]
        for v1=1:2
            for v2=1:2
                mean1 = [8-m1,m1]; mean2=[8-m2,m2];        
                variance1 = [v1,v2]; variance2 = [v1,v2];             
                % Create coordinate system
                [x, y] = meshgrid(1:sz, 1:sz);
    
                % Calculate the first Gaussian blob
                gaussian1 = exp(-((x - mean1(1)).^2 / (2 * variance1(1)) + (y - mean1(2)).^2 / (2 * variance1(2))));
    
                % Calculate the second Gaussian blob
                gaussian2 = exp(-((x - mean2(1)).^2 / (2 * variance2(1)) + (y - mean2(2)).^2 / (2 * variance2(2))));
    
                % Combine the two Gaussian blobs into one matrix
                combined_gaussian = gaussian1 + gaussian2;
    
                subplot(36,2,p)
                imagesc(combined_gaussian);
                
                colorbar;
                axis equal tight;
                subplot(36,2,p+1)
                theta=1:179;
                [R, xp] = radon(combined_gaussian,theta);
                
                % Display the Radon transform
                imagesc(theta,xp, R);
                xlabel('\theta (degrees)');
                ylabel('x');
                
                colorbar;
                p = p+2;
            end
        end
    end
end
print(fig8, "radonBlobsD", saveformat);

[m,ii] = max(squeeze(CsCI(6,2,:,:,:,:)),[],"all");
[i1,i2,i3,i4] = ind2sub(size(squeeze(CsCI(4,2,:,:,:,:))), ii);
YT = flip(squeeze(predCI{i4}(p,i1,i2,i3,:,:)),1);
yr = rescale(YT,0,1);
%yr(:,4) = 1;
%yr(:,5) = 0.5;
[R, xp] = radon(yr,theta);
figure;
imagesc(theta,xp, R);
xlabel('\theta (degrees)');
ylabel('x''');
figure;
imagesc(yr)
R(5:9,26:30)

yr = repelem(yr, 4, 4);
[R, xp] = radon(yr,theta);
figure;
imagesc(theta,xp, R);
xlabel('\theta (degrees)');
ylabel('x''');
figure;
imagesc(yr)
R(5:9,26:30)