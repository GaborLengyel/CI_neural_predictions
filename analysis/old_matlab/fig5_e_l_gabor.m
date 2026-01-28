%cc = cbrewer('qual', 'Set1', 5);
plt_id = 1;

for i=1:4
    figure;
    nfigid(i) = get(gcf,'Number');
end
for i=1:4
    figure;
    nfigid1(i) = get(gcf,'Number');
end


for subid = [1:5]


    load(['../mat_files/models10_', num2str(subid), '.mat'])
    burnin = 5000;
    ispropburnin = 0;
    thin = 9;

    nchain = 72;
    nsamp = size(model.post_samps, 1) ./ (2 * nchain);
    samps = get_full_params(model.phi_theta(get_samples_burnin_thin(model.post_samps, burnin, thin, 72, nsamp), model), model);

    for kk1 = 5:5



        sig_e_2 = samps(:, 8) .^ 2;
        [alps, sig_p_2, bet, sig_g_2, sig_r_2] = get_prior_params_samps_v13(samps, model.add_noise_01);
        sig_pg_2 = sig_p_2(:, 1);
        sig_pr_2 = sig_p_2(:, 1 + kk1);
        sig_pgr_2 = sig_p_2(:, 7 + kk1);
        sig_r_2 = sig_r_2(:, kk1);
        alp_cg = alps(:, 1);
        alp_cr = alps(:, 1 + kk1);
        alp_cgr = alps(:, 7 + kk1);
        bet_gr = bet;


        thets = linspace(0, 45, 101)';
        eps_r = [ones(size(thets)), 0 * tand(thets)];
        eps_g = [ones(size(thets)), tand(thets)];
        eps_g = repmat(eps_g, [1, 1, size(samps, 1)]);
        eps_r = repmat(eps_r, [1, 1, size(samps, 1)]);

        for i = 1:4
            st_arr{i} = [0, 1];
        end

        sts = cartprod_cell(st_arr);

        mi1 = [];
        mi2 = [];
        %%

        for ii=1:size(sts,1)
            ii
            cg = sts(ii, 1);
            cr = sts(ii, 2);
            cgr = sts(ii, 3);
            sgr = sts(ii, 4);
            t1 = log(alp_cg .* (1 - cg) + (1 - alp_cg) .* (cg));
            t2 = log(alp_cr .* (1 - cr) + (1 - alp_cr) .* (cr));
            t3 = log(alp_cgr .* (1 - cgr) + (1 - alp_cgr) .* (cgr));
            t4 = log(bet_gr .* (sgr) + (1 - bet_gr) .* (1 - sgr));
            lp = t1 + t2 + t3 + t4;

            sig_5_2 = sig_g_2 + sig_r_2 + 2 .* sig_e_2 + cg .* sig_pg_2 + cr .* sig_pr_2;
            gam_5 = (sig_r_2 + sig_e_2 + cr .* sig_pr_2) ./ sig_5_2;
            gam_50 = gam_5;
            sig_6_2 = sig_5_2 .* gam_5 .* (1 - gam_5) + (sig_e_2 + cgr .* sig_pgr_2) .* sgr;

            sig_5_2 = reshape(sig_5_2, [1, 1, size(eps_g, 3)]);
            sig_6_2 = reshape(sig_6_2, [1, 1, size(eps_g, 3)]);
            gam_5 = reshape(gam_5, [1, 1, size(eps_g, 3)]);
            sig_5_2 = repmat(sig_5_2, [size(eps_g, 1), size(eps_g, 2), 1]);
            sig_6_2 = repmat(sig_6_2, [size(eps_g, 1), size(eps_g, 2), 1]);
            gam_5 = repmat(gam_5, [size(eps_g, 1), size(eps_g, 2), 1]);
            lprs = squeeze(sum(lognormpdf(eps_r - eps_g, zeros(size(eps_r)), sqrt(sig_5_2)), 2));
            lprs = lprs + squeeze(sum(lognormpdf(eps_r .* (1 - gam_5) + eps_g .* gam_5, zeros(size(eps_r)), sqrt(sig_6_2)), 2));
            lprs = lprs + repmat(lp(:)', size(lprs, 1), 1);
            lprs1(:, :, ii) = lprs;

            sig_1_2 = sig_r_2 + sig_g_2 + 2 * sig_e_2;
            gam_1 = (sig_r_2 + sig_e_2) ./ sig_1_2;

            if sgr ~= 0
                sig_2_2 = sig_1_2 + (((sig_1_2 .* gam_1 .* (1 - gam_1)) + sgr .* (sig_e_2 + cgr .* sig_pgr_2)) ./ ((1 - gam_1) .^ 2));

                gam_2 = exp(logsumexp([(log(sig_1_2) + log(gam_1) + log(1 - gam_1)), log(sgr) + log(sig_e_2 + cgr * sig_pgr_2)], 2) ...
                    -logsumexp([(log(sig_1_2) + log(1 - gam_1)), log(sgr) + log(sig_e_2 + cgr * sig_pgr_2)], 2));

                gam_1_minus_gam_2 = -exp((log(sgr) + log(sig_e_2 + cgr * sig_pgr_2) + log(1 - gam_1)) - (logsumexp([log(sig_1_2) + log(1 - gam_1), log(sgr) + log(sig_e_2 + cgr * sig_pgr_2)], 2)));

                S_gam1_eq_gam2 = ones(size(sig_1_2));

                idd = find(sig_e_2 == 0);

                if cgr == 0 && ~isempty(idd)
                    sig_2_2(idd) = sig_1_2(idd) ./ (1 - gam_1(idd));
                    gam_2(idd) = gam_1(idd);
                    gam_1_minus_gam_2(idd) = eps;
                    S_gam1_eq_gam2(idd) = 0;
                end

            else
                sig_2_2 = sig_1_2 ./ (1 - gam_1);
                gam_2 = gam_1;
                gam_1_minus_gam_2 = eps;
                S_gam1_eq_gam2 = zeros(size(sig_1_2));
            end

            sig_3_2 = (sig_1_2 .* gam_2 + cr .* sig_pr_2 + sig_2_2 .* (gam_1_minus_gam_2 .^ 2)) .* ((1 - gam_1) .^ 2);
            gam_3 = (sig_2_2 .* ((1 - gam_1) .^ 2) .* ((gam_1_minus_gam_2) .^ 2)) ./ (sig_3_2);
            sig_4_2 = sig_2_2 .* (((1 - gam_1) .^ 2) .* (1 - (S_gam1_eq_gam2 .* gam_3))) + cg .* sig_pg_2;

            mi1(:, ii) = (-1 * ((1 - gam_1) .* S_gam1_eq_gam2 .* gam_3 ./ gam_1_minus_gam_2));
            mi2(:, ii) = -1 * (1 - gam_50);

        end

        prs = exp(lprs1 - logsumexp(lprs1, 3));
        clear sig_5_2 sig_6_2 gam_5 eps_g eps_r lprs lprs1

        for i = 13:16
            prs1_all{subid, kk1, i - 12} = squeeze(prs(:, :, i));
            for i1=1:size(prs1_all{subid, kk1, i - 12},1)
                mess_prs(subid,i-12,i1)=multiESS(prs1_all{subid, kk1, i - 12}(i1,:)');
            end
            if sts(i, 1) == 1
                mi1s_all{subid, kk1, i - 12} = squeeze(mi1(:, i));
            else
                mi1s_all{subid, kk1, i - 12} = squeeze(mi2(:, i));
            end
            
                mess_m1s(subid,i-12)=multiESS(mi1s_all{subid, kk1, i - 12});
            
            
        end

        mitmper2(subid, kk1, :) = get_rgstat(mi2(:, [13, 15]), 144, numel(burnin + 1:thin + 1:nsamp));
        mitmper1(subid, kk1, :) = get_rgstat(mi1(:, [14, 16]), 144, numel(burnin + 1:thin + 1:nsamp));
        tmp = [];
        tmp = [tmp, mi1s_all{subid, kk1, 1}];
        tmp = [tmp, mi1s_all{subid, kk1, 2}];
        tmp = [tmp, mi1s_all{subid, kk1, 3}];
        tmp = [tmp, mi1s_all{subid, kk1, 4}];
        mess(subid, kk1) = multiESS(tmp);
        mess1(subid, kk1) = miness(4, 0.05, 0.1);

        if plt_id == 1
            ids1={'g','h','i','j'};
            ids2={'l','l','n','n'};
            ids3={'k','k','m','m'};
            for i = 13:16
                figure(nfigid(i-12));


                %             subplot(4,4,i);
                hold on; ylim([0, 1]); xlim([0, 30]); xticks([0:15:30]); yticks([0, 0.5, 1]);
                prs1 = squeeze(prs(:, :, i));
                %             prs1=squeeze(sum(prs(:,:,13:16),3));
                %                 shaded_errorbar(thets,quantile(prs1,0.5,2),[quantile(prs1,1-0.025,2)'-quantile(prs1,0.5,2)';quantile(prs1,0.5,2)'-quantile(prs1,0.025,2)'],'lineProps',{'-','color',cc(subid,:)*0.25+0.75*[1,1,1]});
                shaded_errorbar(thets, quantile(prs1, 0.5, 2), [quantile(prs1, 1 - 0.16, 2)' - quantile(prs1, 0.5, 2)'; quantile(prs1, 0.5, 2)' - quantile(prs1, 0.16, 2)'], 'lineProps', {'-', 'color', cc(subid, :) * 0.25 + 0.75 * [1, 1, 1]});
                plot(thets, quantile(prs1, 0.5, 2)', 'color', cc(subid, :) * 1 + 0 * [1, 1, 1], 'linewidth', 1.5);
                drawnow

                xlabel({'differences between center','and surround motion directions'});
                ylabel('prob. of structure');
                standardize_figure(nfigid(i-12), [2, 2]);
                saveas(nfigid(i-12), ['../plots/fig5_gabor_', ids1{i-12}, '.pdf']);
            end

            for i = 13:16
                figure(nfigid1(i-12));

                hold on; ylim([-1, 1]); xlim([0.5, 5.5]); hline(0, 'k--'); xticks([1:5]); yticks([-1, -0.5, 0, 0.5, 1]);

                if sts(i, 1) == 1
                    mi1s = squeeze(mi1(:, i));
                    errorbar(subid, quantile(mi1s, 0.5), abs(quantile(mi1s, 0.025) - quantile(mi1s, 0.5)), abs(quantile(mi1s, 1 - 0.025) - quantile(mi1s, 0.5)), '.', 'linewidth', 1.5, 'color', cc(subid, :),'markersize',15,'capsize',0);
                    drawnow
                    xlabel('observer');
                    ylabel('predicted modulation index');
                    standardize_figure(nfigid1(i-12), [2, 2]);
                    saveas(nfigid1(i-12), ['../plots/fig5_gabor_', ids2{i-12}, '.pdf']);
                end

            end

            for i = 13:16
                figure(nfigid1(i-12));

                hold on; ylim([-1, 1]); xlim([0.5, 5.5]); hline(0, 'k--'); xticks([1:5]); yticks([-1, -0.5, 0, 0.5, 1]);

                if sts(i, 1) == 0 && sts(i, 3) == 1 && sts(i, 4) == 1
                    mi1s = squeeze(mi2(:, i));
                    errorbar(subid, quantile(mi1s, 0.5), abs(quantile(mi1s, 0.025) - quantile(mi1s, 0.5)), abs(quantile(mi1s, 1 - 0.025) - quantile(mi1s, 0.5)), '.', 'linewidth', 1.5, 'color', cc(subid, :),'markersize',15,'capsize',0);

                    drawnow
                    xlabel('observer');
                    ylabel('predicted modulation index');
                    standardize_figure(nfigid1(i-12), [2, 2]);
                    saveas(nfigid1(i-12), ['../plots/fig5_gabor_', ids3{i-12}, '.pdf']);
                end

            end

        end

    end

end
