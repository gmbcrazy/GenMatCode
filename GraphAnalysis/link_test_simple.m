function [diff, pval, corrN, corrP, corrZ_N, corrZ_P,ci] = link_test_simple(normal_tc, patient_tc)

[~, ~, sub1] = size(normal_tc);
for i=1:sub1
    [corrN(:,:,i), ~] = corrcoef(normal_tc(:,:,i));
end
corrZ_N = gretna_fishertrans(corrN);

[~, region, sub1] = size(patient_tc);
for i=1:sub1
    [corrP(:,:,i), ~] = corrcoef(patient_tc(:,:,i));
end
corrZ_P = gretna_fishertrans(corrP);

for i=1:region
    for j=1:region
        [~, pval(i,j),ci{i,j}] = ttest2(corrZ_N(i,j,:), corrZ_P(i,j,:));
        diff(i,j) = mean(corrN(i,j,:)) - mean(corrP(i,j,:));
    end
end



