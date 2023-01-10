function [pval, diff_sign] = voxel_ttest_remcov_fastLU(mask1_tc_N, mask1_tc_P, Normal_voxel_all, Patient_voxel_all, cov)


% % Invalid=find((sum(isnan(cov)'))>0);
%%%%%%%%%
% i = 2;
% mask1_tc_N = whole_brain_tc_nor(:,cut_index1(i):cut_index2(i),:);
% mask1_tc_P = whole_brain_tc_pat(:,cut_index1(i):cut_index2(i),:);
% Normal_voxel_all = whole_brain_tc_nor;
% Patient_voxel_all = whole_brain_tc_pat;
%%%%%%%%%%
tic 
N_Z = zeros(size(mask1_tc_N,2), size(Normal_voxel_all,2), size(mask1_tc_N,3));
for i=1:size(mask1_tc_N,3)
    N_corr = corr(mask1_tc_N(:,:,i), Normal_voxel_all(:,:,i),'type','Pearson');
    N_Z(:,:,i) = gretna_fishertrans(N_corr);
end

P_Z = zeros(size(mask1_tc_P,2), size(Patient_voxel_all,2), size(mask1_tc_P,3));
for i=1:size(mask1_tc_P,3)
    P_corr = corr(mask1_tc_P(:,:,i), Patient_voxel_all(:,:,i),'type','Pearson');
    P_Z(:,:,i) = gretna_fishertrans(P_corr);
end

pval = ones(size(N_Z,1), size(N_Z,2));
GroupLabel = [zeros(size(N_Z,3),1); ones(size(P_Z,3),1)];

% for i=1:size(N_Z,1)
parfor i=1:size(N_Z,1)
    normal = squeeze(N_Z(i,:,:));
    patient = squeeze(P_Z(i,:,:));
    DependentVariable = [normal'; patient'];
    pval(i,:) = ttest2_cov(DependentVariable, GroupLabel, cov);
end
diff = nanmean(N_Z,3) - nanmean(P_Z,3);
diff_sign = sign(diff);


