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

site_name = {'Huaxi', 'COBRE', 'Taiwan', 'Xiangya', 'Nottingham'};

for k=1:length(site_name)
    roi_nor_tc = eval(['AAL_TC_',  site_name{k}, '_Nor']);
    roi_pat_tc = eval(['AAL_TC_',  site_name{k}, '_Pat']);
    
    for i=1:size(roi_nor_tc,3)
        Nor_corr(:,:,i) = corrcoef(roi_nor_tc(:,:,i));
        Nor_corr_ssj1(:,i) = ssjnum(Nor_corr(:,:,i));
    end
    for i=1:size(roi_pat_tc,3)
        Pat_corr(:,:,i) = corrcoef(roi_pat_tc(:,:,i));
        Pat_corr_ssj1(:,i) = ssjnum(Pat_corr(:,:,i));
    end
    
    Nor_corr_ssj{k} = Nor_corr_ssj1;
    Pat_corr_ssj{k} = Pat_corr_ssj1;  
    Nor_corr_all{k} = Nor_corr;
    Pat_corr_all{k} = Pat_corr;
    
    clear  Nor_corr_ssj1  Pat_corr_ssj1   Nor_corr  Pat_corr
end

nor_corr = [];
nor_corr2 = [];
pat_corr = [];
pat_corr2 = [];
group = [];
for i=1:length(Nor_corr_ssj)
    for j=1:length(Nor_corr_ssj)
        aa = mean(cat(2,Nor_corr_ssj{i},Pat_corr_ssj{i}),2);
        bb = mean(cat(2,Nor_corr_ssj{j},Pat_corr_ssj{j}),2);
        [~, pp1(i,j)] = ttest2(aa(:), bb(:));  
    end
    
    dd = mean(Pat_corr_ssj{i},2);
    pat_corr = [pat_corr; dd];
    pat_corr2 = [pat_corr2; dd'];

    dd = mean(Nor_corr_ssj{i},2);
    nor_corr = [nor_corr; dd];
    nor_corr2 = [nor_corr2; dd'];
    
    group = [group; ones(length(dd),1)*i];
end

pp_nor = anova1(nor_corr, group, 'off');
pp_pat = anova1(pat_corr, group, 'off');

subplot(1,2,1)
bp = boxplot(nor_corr2');
for i = 1:size(bp,2), set(bp(:,i),'linewidth',2); end
subplot(1,2,2)
bp = boxplot(pat_corr2');
for i = 1:size(bp,2), set(bp(:,i),'linewidth',2); end


















% load('sig_pval_all.mat')
% for i=1:size(sig_pval_all,1)
%     for j=1:length(Nor_corr_all)
%         for k=1:length(Nor_corr_all)
%             aa = [squeeze(Nor_corr_all{j}(sig_pval_all(i,1), sig_pval_all(i,2), :)); squeeze(Pat_corr_all{j}(sig_pval_all(i,1), sig_pval_all(i,2), :))];
%             bb = [squeeze(Nor_corr_all{k}(sig_pval_all(i,1), sig_pval_all(i,2), :)); squeeze(Pat_corr_all{k}(sig_pval_all(i,1), sig_pval_all(i,2), :))];
%             [~, pp2(j,k,i)] = ttest2(aa(:), bb(:));
%         end
%     end
% end
% 
% 
% for i=1:size(sig_pval_all,1)
%     cc = [];
%     group = [];
%     for j=2:5
%         aa = [squeeze(Nor_corr_all{j}(sig_pval_all(i,1), sig_pval_all(i,2), :)); squeeze(Pat_corr_all{j}(sig_pval_all(i,1), sig_pval_all(i,2), :))];
%         cc = [cc; aa];
%         group = [group; ones(length(aa),1)*j];
%     end
%     pp3(i) = anova1(cc, group, 'off');
% end








