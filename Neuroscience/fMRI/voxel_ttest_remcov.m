function [pval, diff_sign] = voxel_ttest_remcov(mask1_tc_N, mask1_tc_P, Normal_voxel_all, Patient_voxel_all, cov)

%%%%%%%%%
% mask1_tc_N = whole_region_tc_Nor(:,cut_index1(i):cut_index2(i),:);
% mask1_tc_P = whole_region_tc_Pat(:,cut_index1(i):cut_index2(i),:);
% Normal_voxel_all = whole_region_tc_Nor;
% Patient_voxel_all = whole_region_tc_Pat;
% cov = age_gender;
%%%%%%%%%%


[~, ~, subN] = size(mask1_tc_N);
[~, ~, subP] = size(mask1_tc_P);

N_Z = single(zeros(size(mask1_tc_N,2), size(Normal_voxel_all,2), size(mask1_tc_N,3)));
for i=1:size(mask1_tc_N,3)
    N_corr = corr(mask1_tc_N(:,:,i), Normal_voxel_all(:,:,i),'type','Pearson');
    N_Z(:,:,i) = single(gretna_fishertrans(N_corr));
    clear N_corr
end

P_Z = single(zeros(size(mask1_tc_P,2), size(Patient_voxel_all,2), size(mask1_tc_P,3)));
for i=1:size(mask1_tc_P,3)
    P_corr = corr(mask1_tc_P(:,:,i), Patient_voxel_all(:,:,i),'type','Pearson');
    P_Z(:,:,i) = single(gretna_fishertrans(P_corr));
    clear P_corr
end

pval = ones(size(N_Z,1), size(N_Z,2));
diff = zeros(size(N_Z,1), size(N_Z,2));
for i=1:size(N_Z,1)
    parfor j=1:size(N_Z,2)
        normal = squeeze(N_Z(i,j,:));
        patient = squeeze(P_Z(i,j,:));
        DependentVariable = [normal; patient];
        GroupLabel = [zeros(subN,1); ones(subP,1)];
        DependentVariable = DependentVariable(abs(DependentVariable)>0 & abs(DependentVariable)<1000000);
        GroupLabel = GroupLabel(abs(DependentVariable)>0 & abs(DependentVariable)<1000000);
        cov2 = cov;
        cov2 = cov2(abs(DependentVariable)>0 & abs(DependentVariable)<1000000,:);

        [~, pval(i,j)] = ttest2_cov(DependentVariable, GroupLabel, cov2);
        diff(i,j) = mean(DependentVariable(GroupLabel==0)) - mean(DependentVariable(GroupLabel==1));
        
    end
end
diff_sign = sign(diff);

