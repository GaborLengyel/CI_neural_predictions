%%%%%%%%%%%%%%%%%%%%%%%%%%%% plotting the results %%%%%%%%%%%%%
%load('neural_pred_median_neuron_1.mat') 
close all

variable = {'Perceive', 'Retinal', 'Relative'};
%stat = {'mean', 'variance'};
saving = 1;
saveformat = '-dpdf';
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];
% fonsize1 = 16;
% fonsize2 = 32;
%%
for s=1:5 % loop over subject

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
%colormap(flipud(gray))
clim([0,1])
p = 1;

for i = size(neural_pred_mu,2):-1:1
    for j = 1:size(neural_pred_mu,3)

        subplot(size(neural_pred_mu,3), size(neural_pred_mu,2), p)
        image(flip(squeeze(neural_pred_mu(s,i,j,:,:)), 1), 'CDataMapping','scaled')
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

print(fig{1}, "PredMean2d_B"+"_var"+variable{3}+"_"+"_subj"+string(s), saveformat);
end

%%

ZERO = size(neural_pred_mu,length(size(neural_pred_mu)))/2;
x = ([-45,-20-10,-5,-2.5,0,2.5,5,10,20,45]/(360/90))+ZERO;
y = zeros(1,length(x))+ZERO;
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
%colormap(flipud(gray))
clim([0,1])
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,3)

        subplot(5, size(neural_pred_mu,3), p)

        image(flip(squeeze(neural_pred_mu(n,1,j,:,:)), 1), 'CDataMapping','scaled')
        hold on
        plot(x,y,'r-',"LineWidth",2)
        hold off
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca,'XTick', [])
        set(gca,'XTickLabel', [])
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p=p+1;
    end
end
print(fig{1}, "PredMean2d_allS_180"+"_var"+variable{3}, saveformat);

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
%colormap(flipud(gray))
clim([0,1])
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,3)

        subplot(5, size(neural_pred_mu,3), p)

        sep_pred = reshape(X*squeeze(neural_pred_mu_fit(n,1,j,:)), [len_c,len_c]);
        image(flip(sep_pred, 1), 'CDataMapping','scaled')
        hold on
        plot(x,y,'r-',"LineWidth",2)
        hold off
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca,'XTick', [])
        set(gca,'XTickLabel', [])
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p=p+1;
    end
end
print(fig{1}, "PredMean2d_allS_sep_180"+"_var"+variable{3}, saveformat);

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
%colormap(flipud(gray))
clim([0,1])
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,3)

        subplot(5, size(neural_pred_mu,3), p)

        sep_pred = reshape(X*squeeze(neural_pred_mu_fit(n,1,j,:)), [len_c,len_c]);
        image(abs(flip(sep_pred, 1)-flip(squeeze(neural_pred_mu(n,1,j,:,:)), 1)), 'CDataMapping','scaled')
        hold on
        plot(x,y,'r-',"LineWidth",2)
        hold off
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca,'XTick', [])
        set(gca,'XTickLabel', [])
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p=p+1;
    end
end
print(fig{1}, "PredMean2d_allS_diff_180"+"_var"+variable{3}, saveformat);

%%


fontsize1 = 16;
ZERO = size(neural_pred_mu,length(size(neural_pred_mu)))/2;
x = ([-45,-20-10,-5,-2.5,0,2.5,5,10,20,45]/(360/90))+ZERO;
x = round(x);
% plotting results
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,3)

        subplot(5, size(neural_pred_mu,3), p)
            
        sep_pred = reshape(X*squeeze(neural_pred_mu_fit(n,1,j,:)), [len_c,len_c]);
        plot(x,sep_pred(round(ZERO),x),'k-o', "LineWidth", 2);
        
        ylabel('Predicted activty', 'FontSize', fontsize1);
        xlabel('Center direction (deg.)', 'FontSize', fontsize1);
        %set(gca,'XTick', 1:9)
        %set(gca,'XTickLabel', string(c_dir)+"/"+string(round(s_speed,2)))
        set(gca,'YTick',[0,0.5,1],'FontSize', fontsize1)
        %set(gca,'YTickLabel',["0",string(round(0.5*sqrt(mx),2)),string(round(sqrt(mx),2))])
        set(gca,'YLim',[0,1.1])
        p=p+1;
    end
end
print(fig{1}, "predMean1D_allS_180", saveformat);

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,3)

        subplot(5, size(neural_pred_mu,3), p)
        sep_pred = reshape(X*squeeze(neural_pred_mu_fit(n,1,j,:)), [len_c,len_c]);
        yy=abs(sep_pred-squeeze(neural_pred_mu(n,1,j,:,:)));
        plot(x,yy(round(ZERO),x),'r-o', "LineWidth", 2);
        ylabel('Predicted activty', 'FontSize', fontsize1);
        xlabel('Center direction (deg.)', 'FontSize', fontsize1);
        %set(gca,'XTick', 1:9)
        %set(gca,'XTickLabel', string(c_dir)+"/"+string(round(s_speed,2)))
        set(gca,'YTick',[0,0.5,1],'FontSize', fontsize1)
        %set(gca,'YTickLabel',["0",string(round(0.5*sqrt(mx),2)),string(round(sqrt(mx),2))])
        set(gca,'YLim',[0,1.1])
        p=p+1;
    end
end
print(fig{1}, "predMean1D_allS_sep_180", saveformat);

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,3)

        subplot(5, size(neural_pred_mu,3), p)
        sep_pred = reshape(X*squeeze(neural_pred_mu_fit(n,1,j,:)), [len_c,len_c]);
        hold on
        plot(x,squeeze(neural_pred_mu(n,1,1,round(ZERO),x)),'k-o', "LineWidth", 2);
        plot(x,sep_pred(round(ZERO),x),'r-o', "LineWidth", 2);
        hold off
        ylabel('Predicted activty', 'FontSize', fontsize1);
        xlabel('Center direction (deg.)', 'FontSize', fontsize1);
        %set(gca,'XTick', 1:9)
        %set(gca,'XTickLabel', string(c_dir)+"/"+string(round(s_speed,2)))
        set(gca,'YTick',[0,0.5,1],'FontSize', fontsize1)
        %set(gca,'YTickLabel',["0",string(round(0.5*sqrt(mx),2)),string(round(sqrt(mx),2))])
        set(gca,'YLim',[0,1.1])
        p=p+1;
    end
end
print(fig{1}, "predMean1D_allS_diff_180", saveformat);

%%
variable = {'Perceive', 'Retinal', 'Relative'};
saving = 1;
saveformat = '-dpdf';
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];

s_dir1 = -45;
c_dir1 = [-117 -99 -81 -63 -45 -27 -9 9 27];

s_dir2 = -135;
c_dir2 = [-180 -171 -153 -135 -117 -99 -81 -63];
c_dir3 = [153 171 180];

ZERO = size(neural_pred_mu,length(size(neural_pred_mu)))/2;
x1 = round((c_dir1/(360/90))+ZERO);
x2 = round((c_dir2/(360/90))+ZERO);
x3 = round((c_dir3/(360/90))+ZERO);
y1 = repmat(round((s_dir1/(360/90))+ZERO), 1, length(c_dir1));
y2 = repmat(round((s_dir2/(360/90))+ZERO), 1, length(c_dir2));
y3 = repmat(round((s_dir2/(360/90))+ZERO), 1, length(c_dir3));

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
%colormap(flipud(gray))
clim([0,1])
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,2)

        subplot(5, size(neural_pred_mu,2), p)
        
        image(flip(squeeze(neural_pred_mu(n,j,1,:,:)), 1), 'CDataMapping','scaled')
        hold on
        plot(x1,y1,'r-',"LineWidth",2)
        plot(x2,y2,'k-',"LineWidth",2)
        plot(x3,y3,'k-',"LineWidth",2)
        hold off
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca,'XTick', [])
        set(gca,'XTickLabel', [])
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p=p+1;
    end
end
print(fig{1}, "PredMean2d_allB_0"+"_var"+variable{3}, saveformat);

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
%colormap(flipud(gray))
clim([0,1])
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,2)

        subplot(5, size(neural_pred_mu,2), p)
        
        sep_pred = reshape(X*squeeze(neural_pred_mu_fit(n,j,1,:)), [len_c,len_c]);
        image(flip(sep_pred, 1), 'CDataMapping','scaled')
        hold on
        plot(x1,y1,'r-',"LineWidth",2)
        plot(x2,y2,'k-',"LineWidth",2)
        plot(x3,y3,'k-',"LineWidth",2)
        hold off
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca,'XTick', [])
        set(gca,'XTickLabel', [])
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p=p+1;
    end
end
print(fig{1}, "PredMean2d_allB_sep_0"+"_var"+variable{3}, saveformat);

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
%colormap(flipud(gray))
clim([0,1])
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,2)

        subplot(5, size(neural_pred_mu,2), p)
        
        sep_pred = reshape(X*squeeze(neural_pred_mu_fit(n,j,1,:)), [len_c,len_c]);
        image(abs(flip(sep_pred, 1)-flip(squeeze(neural_pred_mu(n,j,1,:,:)), 1)), 'CDataMapping','scaled')
        hold on
        plot(x1,y1,'r-',"LineWidth",2)
        plot(x2,y2,'k-',"LineWidth",2)
        plot(x3,y3,'k-',"LineWidth",2)
        hold off
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca,'XTick', [])
        set(gca,'XTickLabel', [])
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p=p+1;
    end
end
print(fig{1}, "PredMean2d_allB_diff_0"+"_var"+variable{3}, saveformat);

%%
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];
fontsize1 = 16;
s_dir1 = -45;
c_dir1 = [-117 -99 -81 -63 -45 -27 -9 9 27];

s_dir2 = -135;
c_dir2 = [-180 -171 -153 -135 -117 -99 -81 -63];
c_dir3 = [153 171 180];

ZERO = size(neural_pred_mu,length(size(neural_pred_mu)))/2;
x1 = round((c_dir1/(360/90))+ZERO);
x2 = round((c_dir2/(360/90))+ZERO);
x3 = round((c_dir3/(360/90))+ZERO);

p=1;
% plotting results
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
for n=1:5
    for j = 1:size(neural_pred_mu,2)

        subplot(5, size(neural_pred_mu,2), p)    

        hold on
        
        plot(x1,squeeze(neural_pred_mu(n,j,1,round(ZERO),x1)),'r-o', "LineWidth", 2);
        plot(x2,squeeze(neural_pred_mu(n,j,1,round(ZERO),x2)),'k-o', "LineWidth", 2);
        plot(x3,squeeze(neural_pred_mu(n,j,1,round(ZERO),x3)),'k-o', "LineWidth", 2);
        sep_pred = reshape(X*squeeze(neural_pred_mu_fit(n,j,1,:)), [len_c,len_c]);
        plot(x1,sep_pred(round(ZERO),x1),'g-o', "LineWidth", 2);
        plot(x2,sep_pred(round(ZERO),x2),'y-o', "LineWidth", 2);
        plot(x3,sep_pred(round(ZERO),x3),'y-o', "LineWidth", 2);
        hold off
        ylabel('Predicted activty', 'FontSize', fontsize1);
        xlabel('Center direction (deg.)', 'FontSize', fontsize1);
        set(gca,'XTick', [0,45,91])
        set(gca,'XTickLabel', ["-180","0", "180"])
        set(gca,'YTick',[0,0.5,1],'FontSize', fontsize1)
        %set(gca,'YTickLabel',["0",string(round(0.5*sqrt(mx),2)),string(round(sqrt(mx),2))])
        set(gca,'YLim',[0,1.1])
        p=p+1;
    end
end
print(fig{1}, "predMean1D_allB_0", saveformat);
%%
dataM1 = [45.9553349875931	96.9727047146402	63.0272952853598	99.8511166253102	54.0281224152192	81.7204301075269	71.1331679073615	70.8354011579818	92.2084367245658	67.1960297766749	95.4838709677419	64.4499586435070	102.398676592225	58.9247311827957	113.647642679901	80.0661703887511	113.779983457403	111.232423490488	91.4474772539289	81.7204301075269	67.0967741935484	73.4491315136476	104.946236559140	125.889164598842;
53.6972704714640	96.3440860215054	75.4011579818032	98.8254755996691	57.7005789909016	81.3234077750207	73.4160463192721	71.8941273779983	89.2307692307692	65.4425144747725	86.7162944582299	59.9172870140612	90.0578990901572	52.4731182795699	94.5905707196030	73.3498759305211	91.8114143920596	90.9842845326716	75.6658395368073	75.7981803143093	64.3176178660050	69.5781637717122	103.391232423491	124.499586435070;
55.7485525227461	88.1720430107527	78.4119106699752	93.6311000827130	56.0463192721257	81.2903225806452	66.5674110835401	68.3870967741936	73.8792390405294	62.4648469809760	71.4309346567411	61.0752688172043	70.7692307692308	52.5392886683209	74.6071133167907	68.8833746898263	73.3167907361456	74.6732837055418	65.2440033085195	67.4276261373036	62.7956989247312	69.1149710504549	100.148883374690	115.765095119934;
59.1563275434243	90.8188585607941	80.9263854425145	100.512820512821	54.1935483870968	85.0951199338296	59.3879239040529	71.9933829611249	63.4904880066170	68.3540115798180	59.5533498759305	64.4168734491315	56.0132340777502	56.1786600496278	60.6120760959471	71.2655086848635	62.0016542597188	67.0967741935484	64.3176178660050	68.1555004135649	61.2406947890819	65.6079404466501	103.953680727874	118.577336641853;
65.5086848635236	83.7386269644334	83.8378825475600	87.9073614557486	57.5682382133995	80.3970223325062	58.7923904052936	69.0157154673284	56.2448304383788	66.2034739454094	48.0397022332506	64.9793217535153	42.6137303556658	51.8775847808106	47.1133167907361	70.4714640198511	52.9693961952027	60.6120760959471	62.7295285359801	62.9611248966088	58.1637717121588	60.6782464846981	95.6492969396195	112.258064516129;
67.8577336641853	77.2870140612076	82.0512820512821	85.2605459057072	58.7593052109181	77.0223325062035	54.6236559139785	69.4789081885856	47.5434243176179	71.9602977667494	42.2167080231596	67.7915632754342	39.8676592224979	56.6749379652606	44.4334160463193	70.5045492142266	50.1571546732837	61.2406947890819	63.9536807278743	67.5268817204301	55.7485525227461	60.6120760959471	91.9437551695616	106.567411083540;
65.8395368072787	65.5086848635236	72.4565756823821	73.3167907361456	56.1124896608768	72.1257237386270	52.1422663358147	65.0124069478908	45.7568238213399	73.1844499586435	39.6691480562448	64.6484698097601	34.4086021505376	53.2340777502068	41.5550041356493	69.0818858560794	49.0322580645161	56.5425971877585	65.6741108354012	68.7841191066998	54.2266335814723	54.3589743589744	77.1877584780811	94.1273779983458;
59.0901571546733	59.0570719602978	65.2440033085195	68.3540115798180	55.5831265508685	75.5004135649297	50.8850289495451	68.7841191066998	46.2200165425972	71.5632754342432	38.9412737799835	69.7766749379653	35.0041356492969	58.4615384615385	39.0736145574855	75.2688172043011	47.5103391232424	59.6195202646816	72.1257237386270	82.0512820512821	65.7071960297767	59.6195202646816	74.0446650124069	84.1025641025641;
53.3995037220844	62.5641025641026	59.9172870140612	74.6401985111663	51.4143920595534	83.9371381306865	55.3515301902399	79.9338296112490	47.5765095119934	84.2679900744417	42.4152191894127	84.9627791563275	41.1248966087676	70.1075268817204	46.4185277088503	89.5947063689000	52.9032258064516	72.6881720430108	95.7816377171216	110.901571546733	91.2489660876758	78.0479735318445	83.5070306038048	82.2828784119107];

dataSD1 = [1.09138165196077	2.31603112610680	1.31302794593776	2.03251911376776	1.09252730943613	2.94744864188447	2.22821213589945	1.98361438669471	1.90380581818082	1.90109331579943	1.37225234591254	2.09036047873120	1.83955720913542	1.71606167870570	1.96492154858716	2.48736921800762	1.96161604469031	2.57685515360376	3.13704275271734	3.24082947460627	2.12283670872245	1.78738806541305	1.97199177773486	2.15326270958977;
1.80059377472256	3.27330903547087	1.89408867845175	2.96023360100860	1.71469426234573	3.19828163398831	1.74855889473095	2.60852007768469	2.24213444329154	1.75284633613601	1.75123977568590	1.69405057076481	2.30591496695209	1.86538807501803	1.76214437688423	2.33539559725368	1.95234687957678	2.49443183214099	2.21882333761433	2.28732653725657	1.45521135609406	1.51010834789916	1.99258116542055	1.84223299190517;
1.70385309404732	1.86614239368275	1.73410069613817	2.22663252802709	1.01875693768210	2.30862597510928	1.81658937584882	1.87462841811894	1.50673912810398	1.70192467094564	1.79881253519513	2.13070413183349	1.81202128393050	1.99269888040537	1.91514821087917	2.31572727141070	1.75458511661491	1.73130295710825	2.17881947646197	2.44753781140069	1.70811542604043	1.46538441338005	2.82992404336873	1.50486985284393;
1.51010834789916	3.29300391248964	2.00654076340823	2.98548215036828	1.27330417983091	3.65711678139747	1.68586145121227	2.75059455553933	1.57195713466877	1.67805176040513	1.51460618994417	2.00287456344863	1.39014072327161	1.34410147329305	1.60547223679372	2.64377114291142	1.54562349125559	2.06798534174151	1.83005435400949	2.02121643074403	1.80098454271820	1.91118398490158	2.22779101664614	2.48916030884181;
1.44323410421830	2.30112903969979	1.73779401366672	2.48887759071699	1.16437861129727	2.61979591660270	1.36287595975733	2.41696669860159	1.38828341181373	1.88622918378628	1.30334551025004	1.97353749009108	1.32800807439842	1.18916176212652	1.42727243077737	2.75678441619618	1.27722808491019	1.64515989424703	1.99970999973677	2.46567952144076	2.12394137482662	1.53801678070067	2.50933883460003	1.58142878342176;
1.00950513167195	2.72790243708238	2.20333484410553	1.92768161101770	1.07623185588917	3.15446613815867	1.59565334018693	1.70683326318941	1.51785492765250	1.30226524026729	0.740018780090249	2.32512830254659	1.33575710426378	1.84879978204824	1.41853545994191	3.51337882075525	1.72288248122920	2.18577016220573	1.88813501031971	2.25375161774993	2.14507709838213	1.23084037966837	3.16421690993325	3.13292758254507;
1.35753008773353	2.71865752205830	1.55736557077684	2.11966680858190	1.23995408982199	3.16429103912513	1.55922205696585	1.52848073485565	1.22734158865980	1.87066191814103	1.72220161660186	1.82855839069873	1.18995050536742	2.22283688928928	1.37708693902438	2.41149342199758	1.73828886176306	1.74721691170325	1.45832434082869	1.82106014069363	1.07040410569795	0.957512864463660	1.85555402787761	2.57676412491989;
1.65269925218819	2.08425470794479	1.40273866739479	1.90397008806492	1.30765766598563	2.63713816348545	1.45607077524832	1.62430639375699	1.22702302204175	1.54238254989242	1.06645237130099	1.71833828784002	0.833063908156438	1.47235753102779	1.15473625626338	2.97241123639941	1.30538358109659	1.98621419616922	1.86047754901696	2.64149293490170	2.50153701854641	1.77544977364045	2.74279482642216	2.82148462597166;
1.58927050484785	2.21490841749244	1.59712267964943	2.54522636120997	1.11477257772427	3.44235962930977	1.09037821422793	2.40187703874196	1.11589422064689	2.40906046931899	1.62435452919814	3.13544720667848	1.50128056966596	2.16239380771335	1.44637286746092	3.35680236448259	1.64867306686751	2.54617848497031	2.88524900322553	3.14167520879254	2.30184246802648	2.07831910994732	2.52842885182663	2.20148879112781];

dataM2 = [36.4267990074442	51.7452440033085	42.4813895781638	75.3349875930521	45.4921422663358	72.5227460711332	55.3184449958644	83.8047973531845	57.5020678246485	100.578990901572	64.0860215053763	109.214226633581	67.2622001654260	106.931348221671	77.0885028949545	97.0057899090157	100.512820512821	133.995037220844	161.819685690653	145.541770057899	99.4540942928040	81.8196856906534	84.6980976013234	81.0918114143921;
34.2100909842845	50.2894954507858	38.8089330024814	71.7617866004963	45.9884201819686	66.2696443341605	56.4764267990074	74.3424317617866	61.9685690653433	87.2125723738627	69.0818858560794	90.9181141439206	74.0777502067825	88.6683209263854	86.5839536807279	83.7055417700579	109.975186104218	131.546732837055	150.372208436725	125.558312655087	80.9263854425145	70.5045492142266	80.2646815550042	78.9412737799835;
33.9123242349049	61.6377171215881	39.2059553349876	75.8974358974359	46.0545905707196	67.7253928866832	57.6013234077750	69.2142266335815	66.8982630272953	79.9007444168735	74.7063688999173	75.2026468155501	85.1282051282051	74.8056244830438	98.1306865177833	69.7105045492142	121.323407775021	126.484698097601	129.131513647643	98.7923904052936	66.5674110835401	66.7659222497932	86.2861869313482	100.645161290323;
32.1918941273780	65.6079404466501	41.5880893300248	81.2572373862697	45.2274607113317	67.8246484698098	59.1894127377998	65.4755996691481	71.0339123242349	73.0521091811414	80.1654259718776	65.9387923904053	92.1091811414392	66.7328370554177	103.788254755997	58.6600496277916	117.518610421836	111.166253101737	101.042183622829	71.9933829611249	54.9214226633582	66.2365591397849	94.5244003308520	103.325062034739;
38.8420181968569	72.2580645161290	47.8081058726220	87.3779983457403	55.3515301902399	70.3722084367246	71.5301902398677	67.2291149710505	78.1803143093466	68.1224152191894	84.1025641025641	60.1488833746898	88.3043837882548	60.7444168734491	89.3631100082713	47.8742762613730	86.9148056244831	75.3680727874276	65.6079404466501	52.2415219189413	49.6608767576509	64.9793217535153	106.832092638544	114.838709677419;
58.7923904052936	80.1654259718776	68.2547559966915	91.7452440033085	66.8982630272953	73.2506203473945	77.6840363937138	69.9090157154673	75.0041356492969	71.2655086848635	73.7138130686518	59.3548387096774	73.6476426799007	58.2961124896609	74.0777502067825	47.0471464019851	69.9090157154673	61.9685690653433	58.7262200165426	53.9619520264682	52.5392886683209	69.6774193548387	113.482216708023	121.058726220017;
72.2580645161290	81.5880893300248	80.4962779156328	91.9106699751861	72.0595533498759	73.2837055417701	75.2357320099256	70.6038047973532	67.6923076923077	72.2911497105045	64.8138957816377	57.5351530190240	58.0314309346568	53.1348221670802	57.2373862696443	45.2274607113317	60.1488833746898	57.1712158808933	57.6674937965260	54.0612076095947	57.5351530190240	71.6956162117453	112.820512820513	124.532671629446;
80.5293631100083	80.4301075268817	90.4549214226634	94.6567411083540	76.1952026468156	71.9933829611249	73.0190239867659	71.8941273779983	62.4648469809760	66.8651778329198	55.7816377171216	61.4722911497105	50.8850289495451	55.9470636889992	49.6277915632754	46.4185277088503	51.6129032258065	51.4474772539289	55.9139784946237	57.9652605459057	59.5533498759305	75.4342431761787	114.044665012407	121.952026468156;
83.2423490488007	77.9487179487180	95.9470636889992	96.2117452440033	73.5153019023987	74.3755169561621	68.3870967741936	75.7320099255583	54.8552522746071	72.9197684036394	51.0504549214227	62.6633581472291	45.7237386269644	57.6674937965261	49.2638544251447	48.6683209263855	52.8370554177006	57.5351530190240	57.8990901571547	61.4392059553350	63.2919768403639	75.2026468155500	115.467328370554	119.106699751861];

dataSD2 = [1.52371598870729	2.34904880066170	1.44550768247699	2.38852582925484	1.52361335738068	2.49123259473606	1.59300511386755	2.22410282193658	1.84159625340720	1.66767571765990	1.80363084982440	2.21119873520583	1.55952290053368	2.17235049662915	2.20599469962003	1.98325960316898	2.19009421370839	1.90368260646545	2.20854514716674	3.59325404418262	2.26637893891426	1.56852137635867	1.99493414537684	3.28865595793888;
1.19761352916853	2.16845984554057	1.40134448863837	1.76081274790474	1.26819728317765	1.47209198779858	1.83542972630190	1.56951802239668	2.21617887907088	2.12519263559990	1.61518303868461	1.86898929448921	1.94540621400132	1.71140800541523	1.01228955197267	1.64430420377690	1.60249873129030	2.40090025561975	2.78808848030576	3.10492569166369	1.77452472748602	1.30358544867443	1.62334338519794	2.84161457614420;
1.35666587751052	3.45030017851273	1.30765766598563	2.90407570357944	1.52479320056945	2.21247132698638	1.71127094109005	2.81065632213961	1.79145165688713	2.86976090404719	1.87879463451667	2.72678437961253	1.93779522270274	2.36447562491209	2.46358574125003	1.97080194328426	2.36665708939113	3.11994811420269	4.14005201073575	4.20979498999769	2.77242422696176	1.79776903948601	3.02218355577680	11.1105467758761;
1.41936199998910	1.96921437903171	1.14528581389911	2.46263343449438	1.42760108084062	1.59653510613773	1.92662674759843	1.33470306754373	0.890231533305126	1.53170004491959	1.80493088904787	1.91649499571865	2.61028794648390	1.64230585885735	2.06325383989001	1.41798416558355	2.34491784030486	3.14880976737293	3.01982834837983	2.68631172051924	1.50580478053399	1.47209198779858	2.43889726967505	2.57199579439451;
0.898884519743004	2.22722940044849	1.64430420377690	2.50184955831181	1.62940083706542	1.85513260795715	2.20503752125240	1.81723487649430	1.12113696361116	2.41356760229459	1.57300131071041	1.51166083967125	1.68989157075418	1.34810930404419	2.29959951940515	1.26282210181668	2.60852007768469	2.33723624407977	1.36230214138330	1.59418264645205	1.08238946059158	1.53496354162409	2.24906327865771	2.39813054287416;
1.37657584465633	2.05870136751726	1.52991237565174	2.13367442016691	1.59177759113539	1.80033321560467	1.54592698116091	2.60041449570572	1.42595707306232	1.66213415930316	1.28034633710758	1.38755106106771	1.65577149402283	1.47924492348110	1.91318755869683	1.05354397539061	1.27023019490174	1.30843473503955	1.34712297445211	1.44523720595151	1.93840036138822	1.96181532908170	1.87053652324754	1.91686213644980;
1.36453866847320	2.27309629392590	1.68623243904780	2.42942154692292	1.44014279262759	2.18945150707625	1.55495385338592	2.05790364943475	1.95762609660705	2.24080891291066	2.03574789914510	1.96818177557134	1.79293497195835	2.11023969470213	1.86739891434606	1.69985607563469	1.82646198361386	1.88709947380302	2.14810031034847	2.06756940407429	1.39064683224691	1.78533090412571	2.15761567099270	1.51728818897576;
1.81697670375464	3.21167490326505	2.17321413985037	2.85848639515263	2.02712637644869	2.46406175661059	2.16802711998754	2.99019251904835	1.92260485477877	3.04637986012487	0.964752986670302	2.17828112857583	1.41605294513000	1.86601669508070	1.36126865876542	1.87817029121115	2.26648243362578	2.30479574709620	1.91331015832050	2.35589551287602	1.76759356735880	1.89256070442969	2.83944003580746	2.67010901116102;
1.71742800632896	3.16681039918883	2.93428824620767	2.90302549743872	1.90606328811700	1.99093242483705	1.25381225885931	2.38045945318347	1.50751730870991	2.71799596771779	1.58931970141505	2.10132848329092	1.69847561244526	1.74972111413127	1.91073391427237	1.36511154673366	1.81076951524565	2.00654076340823	2.57038410609547	2.24474832471179	1.68808615525539	2.11323874726895	2.06427676255914	3.07532176373790];

paperPos = [0 0 66 16];
paperSize = [65, 15];
fontsize1 = 12;
s_dir1 = -45;
c_dir1 = [-117 -99 -81 -63 -45 -27 -9 9 27];

s_dir2 = -135;
c_dir2 = [-180 -171 -153 -135 -117 -99 -81 -63];
c_dir3 = [153 171 180];

ZERO = size(neural_pred_mu,length(size(neural_pred_mu)))/2;
x1 = round((c_dir1/(360/90))+ZERO);
x2 = round((c_dir2/(360/90))+ZERO);
x3 = round((c_dir3/(360/90))+ZERO);
c_dir4 = [-117 -99 -81 -63 -45 -27 -9 9 27];
c_dir5 = [-171 -153 -135 -117 -99 -81 -63];
c_dir6 = [171 180];
x1 = round((c_dir4/(360/90))+ZERO);
x2 = round((c_dir5/(360/90))+ZERO);
x3 = round((c_dir6/(360/90))+ZERO);

p=1;
% plotting results
fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
for n=1:size(dataM1,2)
    for j = 1:size(neural_pred_mu,2)

        subplot(size(neural_pred_mu,2), size(dataM1,2), p)    

        hold on
        
        plot(x1,dataM1(:,n),'r-o', "LineWidth", 2);
        plot(x2,dataM2(1:length(x2),n),'k-o', "LineWidth", 2);
        plot(x3,dataM2(length(x2)+1:end,n),'k-o', "LineWidth", 2);
        
        hold off
        ylabel('Predicted activty', 'FontSize', fontsize1);
        xlabel('Center direction (deg.)', 'FontSize', fontsize1);
        %set(gca,'XTick', 1:9)
        %set(gca,'XTickLabel', string(c_dir)+"/"+string(round(s_speed,2)))
        %set(gca,'YTick',[0,0.5,1],'FontSize', fontsize1)
        %set(gca,'YTickLabel',["0",string(round(0.5*sqrt(mx),2)),string(round(sqrt(mx),2))])
        %set(gca,'YLim',[0,1.1])
        p=p+1;
    end
end
print(fig{1}, "DataMean1D_allB_0", saveformat);

%%
paperPos = [0 -0.5 16 16];
paperSize = [15, 15];

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
%colormap(flipud(gray))
clim([0,1])
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,3)

        subplot(5, size(neural_pred_mu,3), p)
        
        image(flip(squeeze(neural_pred_mu(n,1,j,:,:)), 1), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca,'XTick', [])
        set(gca,'XTickLabel', [])
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p=p+1;
    end
end

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
%colormap(flipud(gray))
clim([0,1])
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,3)

        subplot(5, size(neural_pred_mu,3), p)
        sep_pred = reshape(X*squeeze(neural_pred_mu_fit(n,1,j,:)), [len_c,len_c]);
        image(flip(sep_pred, 1), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca,'XTick', [])
        set(gca,'XTickLabel', [])
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p=p+1;
    end
end

%print(fig{1}, "PredMean2d_allB_135"+"_var"+variable{3}, saveformat);

fig{1} = figure('PaperPosition',paperPos,'PaperOrientation','landscape', 'PaperSize',paperSize, 'PaperUnits', 'centimeters');
%colormap(flipud(gray))
clim([0,1])
p=1;
for n=1:5
    for j = 1:size(neural_pred_mu,3)

        subplot(5, size(neural_pred_mu,3), p)
        sep_pred = reshape(X*squeeze(neural_pred_mu_fit(n,1,j,:)), [len_c,len_c]);
        image(abs(flip(sep_pred, 1)-flip(squeeze(neural_pred_mu(n,1,j,:,:)), 1)), 'CDataMapping','scaled')
        %colorbar
        %ylabel(' ', 'FontSize', fonsize1);
        %xlabel(' ', 'FontSize', fonsize1);
        set(gca,'XTick', [])
        set(gca,'XTickLabel', [])
        set(gca,'YTick',[])
        set(gca,'YTickLabel', [])
        %title(['SpeedTunining: ', speedTun{neuronType}, ' with ', speedTun{s}], 'FontSize', fonsize1);
        p=p+1;
    end
end
