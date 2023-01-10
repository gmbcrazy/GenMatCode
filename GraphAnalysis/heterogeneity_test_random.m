function [pval_fix, pval_hete, pval_random, Z] = heterogeneity_test_random(data_Nor, data_Pat)

Num_sites = length(data_Nor);

for i=1:Num_sites
    
    NorData = data_Nor{i};
    PatData = data_Pat{i};
    Diff(i) = mean(NorData) - mean(PatData);
    
    S_Nor = std(NorData);
    S_Pat = std(PatData);
    Num_Nor = length(NorData);
    Num_Pat = length(PatData);
    
    S_pooled(i) = sqrt(((Num_Nor-1)*S_Nor^2 + (Num_Pat-1)*S_Pat^2)/(Num_Nor+Num_Pat-2));
    V_D(i) = (Num_Nor+Num_Pat)/(Num_Nor*Num_Pat)*S_pooled(i)^2;
    SE_D(i) = sqrt(V_D(i));
    
    omiga(i) = 1/V_D(i);
    omiga1(i) = sqrt(length(NorData)+length(PatData));
end

SE_M = sqrt(1/sum(omiga));
M = sum(omiga.*Diff)/sum(omiga);
Z = M/SE_M;
pval_fix = 2*(normcdf(abs(Z), 'upper'));

Q = sum(omiga.*((Diff - M).^2));
% QQ = sum(omiga.*Diff.*Diff) - (sum(omiga.*Diff)^2/sum(omiga));
pval_hete = 1-chi2cdf(Q, Num_sites-1);

df = Num_sites-1;
C = sum(omiga) - sum(omiga.^2)/sum(omiga);
tau2 = abs((Q-df)/C);
I2 = (Q - df)/Q*100;

for i=1:Num_sites
    V_D_new(i) = V_D(i) + tau2;
    omiga_new(i) = 1/V_D_new(i);
end
M_new = sum(omiga_new.*Diff)/sum(omiga_new);
SE_M_new = sqrt(1/sum(omiga_new));
Z_new = M_new/SE_M_new;
pval_random = 2*(1-normcdf(abs(Z_new)));














