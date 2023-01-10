clear all
close all
clc

load('Z:\Users\WCheng\Sch_meta\data\AAL_TC_COBRE_Nor.mat')
load('Z:\Users\WCheng\Sch_meta\data\AAL_TC_COBRE_Pat.mat')
load('Z:\Users\WCheng\Sch_meta\data\AAL_TC_Huaxi_Nor.mat')
load('Z:\Users\WCheng\Sch_meta\data\AAL_TC_Huaxi_Pat.mat')
load('Z:\Users\WCheng\Sch_meta\data\AAL_TC_Nottingham_Nor.mat')
load('Z:\Users\WCheng\Sch_meta\data\AAL_TC_Nottingham_Pat.mat')
load('Z:\Users\WCheng\Sch_meta\data\AAL_TC_Taiwan_Nor.mat')
load('Z:\Users\WCheng\Sch_meta\data\AAL_TC_Taiwan_Pat.mat')
load('Z:\Users\WCheng\Sch_meta\data\AAL_TC_Xiangya_Nor.mat')
load('Z:\Users\WCheng\Sch_meta\data\AAL_TC_Xiangya_Pat.mat')


%% %%%%%%%%%%%%%%%% link statistic
[diff_taiwan, pval_taiwan, corrN_taiwan, corrP_taiwan, corrZ_N_taiwan, corrZ_P_taiwan, ci_taiwan] = link_test_simple(AAL_TC_Taiwan_Nor, AAL_TC_Taiwan_Pat);
[diff_xiangya, pval_xiangya, corrN_xiangya, corrP_xiangya, corrZ_N_xiangya, corrZ_P_xiangya, ci_xiangya] = link_test_simple(AAL_TC_Xiangya_Nor, AAL_TC_Xiangya_Pat);
[diff_Nottingham, pval_Nottingham, corrN_Nottingham, corrP_Nottingham, corrZ_N_Nottingham, corrZ_P_Nottingham,ci_Nottingham] = link_test_simple(AAL_TC_Nottingham_Nor, AAL_TC_Nottingham_Pat);
[diff_COBRE, pval_COBRE, corrN_COBRE, corrP_COBRE, corrZ_N_COBRE, corrZ_P_COBRE, ci_COBRE] = link_test_simple(AAL_TC_COBRE_Nor, AAL_TC_COBRE_Pat);
[diff_Huaxi, pval_Huaxi, corrN_Huaxi, corrP_Huaxi, corrZ_N_Huaxi, corrZ_P_Huaxi, ci_Huaxi] = link_test_simple(AAL_TC_Huaxi_Nor, AAL_TC_Huaxi_Pat);

df = [size(AAL_TC_Taiwan_Nor,3)+size(AAL_TC_Taiwan_Pat,3), size(AAL_TC_Xiangya_Nor,3)+size(AAL_TC_Xiangya_Pat,3),  size(AAL_TC_Nottingham_Nor,3)+size(AAL_TC_Nottingham_Pat,3)...
      size(AAL_TC_COBRE_Nor,3)+size(AAL_TC_COBRE_Pat,3), size(AAL_TC_Huaxi_Nor,3)+size(AAL_TC_Huaxi_Pat,3)];

%% %%%%%%%%%%%%%%% meta-analysis to find all significant links
load('sig_pval_all.mat')
sig_link = sig_pval_all(31:45,1:2);

%% %%%%%%%%%%%%%%%%%
figure;
hold on;

for j=1:size(sig_link,1)
    subplot(4,4,j)
    val{1}.ci = ci_taiwan{sig_link(j,1), sig_link(j,2)};
    val{1}.mean = mean(val{1}.ci);
    val{1}.p = -log10(pval_taiwan(sig_link(j,1), sig_link(j,2)))/2;
    
    val{2}.ci = ci_xiangya{sig_link(j,1), sig_link(j,2)};
    val{2}.mean = mean(val{2}.ci);
    val{2}.p = -log10(pval_xiangya(sig_link(j,1), sig_link(j,2)))/2;

    val{3}.ci = ci_Nottingham{sig_link(j,1), sig_link(j,2)};
    val{3}.mean = mean(val{3}.ci);
    val{3}.p = -log10(pval_Nottingham(sig_link(j,1), sig_link(j,2)))/2;
    
    
    val{4}.ci = ci_COBRE{sig_link(j,1), sig_link(j,2)};
    val{4}.mean = mean(val{4}.ci);
    val{4}.p = -log10(pval_Nottingham(sig_link(j,1), sig_link(j,2)))/2;
    
    val{5}.ci = ci_Huaxi{sig_link(j,1), sig_link(j,2)};
    val{5}.mean = mean(val{5}.ci);
    val{5}.p = -log10(pval_Nottingham(sig_link(j,1), sig_link(j,2)))/2;
    
    weigth = sqrt(df)./sum(sqrt(df));
    z_socre_wei = [val{1}.mean, val{2}.mean, val{3}.mean, val{4}.mean, val{5}.mean];
    z_all_wei = sum(z_socre_wei.*weigth,2);


    Ns = length(val);
    line_color = {[0 0.5 0],[0 0 1],[1 0 0],[0 0.7 0.7],[0.7 0 0.7]};
    for i=1:Ns
        plot([val{i}.ci(1),val{i}.ci(2)], [i, i] ,'k-', 'LineWidth', 2, 'Color', line_color{i}); % plot the confidence interval
        hold on;
        plot(val{i}.mean, i, 'ks','markerSize', 0.6*(val{i}.p+5),'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0]); % plot the boxes
    end
    plot(z_all_wei, 0, 'Marker', 'diamond','markerSize',20*(abs(z_all_wei))+4,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0]); % plot the boxes
    
    hold on;
    plot([0;0], [-0.8, 5.8], 'k--', 'LineWidth',1);
    ylim([-1 6]);
    set(gca,'ytick',[])
    set(gca,'FontWeight','bold', 'FontSize',8)
    edge = [edge_name{j+30,1},'---',edge_name{j+30,2}];
    title(edge)
    
    if (val{1}.mean+val{2}.mean+val{3}.mean)>0
        xlim([-0.2 0.5]);
        %         set(gca,'xtick',[-0.3 0 0.3 0.6])
        %         text(-0.17,4.2,edge,'HorizontalAlignment','left','FontWeight','bold','FontSize',6);
    else
        xlim([-0.5 0.2]);
        %         set(gca,'xtick',[-0.6 -0.3 0 0.3])
        %         text(-0.47,4.2,edge,'HorizontalAlignment','left','FontWeight','bold','FontSize',6);
    end
    
end

% subplot(4,4,16)
% for i=1:Ns
%     plot([val{i}.ci(1),val{i}.ci(2)], [i, i] ,'k-', 'LineWidth', 2, 'Color', line_color{i}); % plot the confidence interval
%     hold on
% end
% 
% plot(z_all_wei, 0, 'Marker', 'diamond','markerSize',20*(abs(z_all_wei))+4,'MarkerEdgeColor',[0 0 0],'MarkerFaceColor',[0 0 0]); % plot the boxes
% legend('Taiwan', 'Xiangya', 'Nottingham', 'COBRE', 'Huaxi', 'Summary')


% saveas(gcf,'C:\Users\sysbio\Desktop\figure_fortest2.pdf')









