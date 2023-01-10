clear all
close all
clc

name_list = {'Nottingham', 'Taiwan', 'Xiangya',  'COBRE', 'Huaxi'};
Net_var = {'Cp'; 'Lp'; 'locE'; 'gE'; 'deg'; 'bw'; 'mod'; 'Cpratio'; 'Lpratio'; 'Sigma'};
Name_var = {'Clustering coefficient'; 'Path length'; 'Local efficiency'; 'Global efficiency'; 'Degree';...
    'Betweennesses'; 'Modularity'; 'Gamma'; 'Lambda'; 'Sigma'};

for i=1:length(name_list)
    load([name_list{i}, '_pearson_binary.mat'])
    Nor_Net.Sigma = Nor_Net.Cpratio./Nor_Net.Lpratio;
    Pat_Net.Sigma = Pat_Net.Cpratio./Pat_Net.Lpratio;
    for j=1:length(Net_var)
        eval(['Nor_data{i,j} = Nor_Net.', Net_var{j}, ';']);
        eval(['Pat_data{i,j} = Pat_Net.', Net_var{j}, ';']);
    end
end

for i=1:size(Nor_data,1)               %%% 单位
    for j=1:size(Nor_data,2)           %%% 网络属性
        Nor_net_var = Nor_data{i,j};
        Pat_net_var = Pat_data{i,j};
        df(i) = size(Nor_net_var,2) + size(Pat_net_var,2);
        
        for s=1:size(Nor_net_var,1)    %%% 阈值
            [~, pval_ttest(i,j,s)] = ttest2(Nor_net_var(s,:), Pat_net_var(s,:));
            diff_ttest(i,j,s) = mean(Nor_net_var(s,:)) - mean(Pat_net_var(s,:));
        end
        
    end
end

for j=1:size(Nor_data,2)
    for s=1:size(Nor_net_var,1)
        pval = pval_ttest(:,j,s);
        diff = diff_ttest(:,j,s);
        [z_socre(j,s), pval_Stouffer_wei(j,s)] = meta_pval(pval', diff', df);
    end
end

for i=1:size(Nor_data,1)               %%% 单位
    for j=1:size(Nor_data,2)           %%% 网络属性
        Nor_net_var = Nor_data{i,j};
        Pat_net_var = Pat_data{i,j};
        for s=1:size(Nor_net_var,1)    %%% 阈值
            Nor_data_mean(i,j,s) = mean(Nor_net_var(s,:));
            Nor_data_std(i,j,s) = std(Nor_net_var(s,:));
            Pat_data_mean(i,j,s) = mean(Pat_net_var(s,:));
            Pat_data_std(i,j,s) = std(Pat_net_var(s,:));
        end
    end
end


for k=1:size(Nor_data_mean,2)
    barvalues_nor = [];
    errors_nor = [];
    barvalues_pat = [];
    errors_pat = [];
    for i=1:size(Nor_data_mean,3)
        barvalues_nor = [barvalues_nor; Nor_data_mean(:,k,i)'];
        errors_nor = [errors_nor; Nor_data_std(:,k,i)'];
        barvalues_pat = [barvalues_pat; Pat_data_mean(:,k,i)'];
        errors_pat = [errors_pat; Pat_data_std(:,k,i)'];
    end
    
    width = 0.8;
    groupnames = {'Threshold = 0.2'; 'Threshold = 0.25'; 'Threshold = 0.3'; 'Threshold = 0.35'; 'Threshold = 0.4'; 'Threshold = 0.45'; 'Threshold = 0.5';};
    bw_title = [Name_var{k}, ' under different threshold'];
    bw_xlabel = [];
    bw_ylabel = Name_var{k};
    bw_colormap = [1 0.8 0; 0 0.6 0.8; 0.7 0 0.7; 0.8 0.5 0;0.4 0.7 0.2];
    gridstatus = 'y';
    bw_legend = name_list;
    error_sides = 1;
    legend_type = 'axis';
    
    figure(k)
    subplot(2,1,1)
    barweb(barvalues_nor, errors_nor, width, groupnames, bw_title, bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend, error_sides, legend_type)
    
    subplot(2,1,2)
    barweb(barvalues_pat, errors_pat, width, groupnames, bw_title, bw_xlabel, bw_ylabel, bw_colormap, gridstatus, bw_legend, error_sides, legend_type)
end



for i=1:size(Nor_data,1)               %%% 单位
    for j=1:size(Nor_data,2)           %%% 网络属性
        Nor_net_var = Nor_data{i,j};
        Pat_net_var = Pat_data{i,j};
        for s=1:size(Nor_net_var,1)    %%% 阈值
            Nor_data_all{i,j,s} = Nor_net_var(s,:);
            Pat_data_all{i,j,s} = Pat_net_var(s,:);
        end
    end
end


Nor_anova = [];
group_anova = [];
for j=1:size(Nor_data_all,2)            %%% 网络属性
    for s=1:size(Nor_data_all,3)        %%% 阈值
        for i=1:size(Nor_data_all,1)    %%% 单位
            Nor_anova = [Nor_anova; Nor_data_all{i,j,s}'];
            group_anova = [group_anova; i*ones(length(Nor_data_all{i,j,s}),1)];
        end
         [p(j,s),anovatab,stats] = anova1(Nor_anova,group_anova, 'off');
    end
end





















