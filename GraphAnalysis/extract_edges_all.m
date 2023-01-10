function [edge_name, sig_pval_all] = extract_edges_all(pval_fix, pval_all, diff_all, thre, pval_hete, pval_random, zval)


% load('AAL_name.mat')
load('Z:\Users\LuZhang\AAL\AAL_name_simple.mat')
% load('AAL_name_GT.mat')

AAL_name = AAL_name_simple;

[ind1, ind2] = find(pval_fix<thre);
sig_pval_all = [];
edge_name = [[], []];
for i=1:length(ind1)
    pval_all_data = [];
    diff_all_data = [];
    for j=1:length(pval_all)
        pval_all_data = [pval_all_data, pval_all{j}(ind1(i), ind2(i))];
        diff_all_data = [diff_all_data, diff_all{j}(ind1(i), ind2(i))];
    end
    
    sig_pval_all = [sig_pval_all; [pval_fix(ind1(i), ind2(i)),pval_random(ind1(i), ind2(i)), zval(ind1(i), ind2(i)), ...
        pval_hete(ind1(i), ind2(i)), pval_all_data, diff_all_data]];
    edge_name = [edge_name; [AAL_name(ind1(i)), AAL_name(ind2(i))]];
end

sig_pval_all = [ind1, ind2, sig_pval_all];

for i=1:length(ind1)
    for j=1:length(ind1)
        if i~=j
            aa = sig_pval_all(i,1:2);
            bb = [sig_pval_all(j,2) sig_pval_all(j,1)];
            if aa==bb
                sig_pval_all(i,:) = zeros(1,size(sig_pval_all,2));
                edge_name(i,:) = cell(1,2);
            end
        end
    end
end

ind_cell = cellfun('isempty',edge_name);
ind_cell2 = double(ind_cell(:,1));
ind11 = ind_cell2>0;
edge_name(ind11,:) = [];
sig_pval_all(mean(sig_pval_all,2)==0,:) = [];

[~, sort2] = sort(sig_pval_all(:,3));
sig_pval_all = sig_pval_all(sort2,:);
edge_name = edge_name(sort2,:);


