function [pval_fix, Z_wei,SE_M, M_new, pval_random,varargout] = meta_correlation(correlation, df)
 
k = length(correlation);
correlation=0.5*log((correlation+1)./(1-correlation));

Num_sites=length(df);
if Num_sites==1
   pval_fix=[];
   Zwei=[];
   M=[];
   pval_random=[];
end
 
for i=1:Num_sites
%     r = correlation(i);
    
    Diff(i)=correlation(i);
%     Diff(i)  = 0.5*log((1+r)./(1-r));
    
    V_D(i) = 1/(df(i));
    omiga(i) = 1/V_D(i);
end
 
SE_M = sqrt(1/sum(omiga));
M = sum(omiga.*Diff)/sum(omiga);
Z = M/SE_M;
pval_fix = 2*(1-normcdf(abs(Z)));

Z_wei = sum(omiga.*correlation')/sum(omiga);


Q = sum(omiga.*((Diff - M).^2));
% QQ = sum(omiga.*Diff.*Diff) - (sum(omiga.*Diff)^2/sum(omiga));
pval_hete = 1-chi2cdf(Q, Num_sites-1);

if nargout>5
   varargout{1}=pval_hete;
end

 
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
 
 
 
 
 
 
 
 
 
 
 
 
 
 

