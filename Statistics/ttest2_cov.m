function varargout = ttest2_cov(DependentVariable, GroupLabel, Covariate)

if size(DependentVariable,2)==1
   i1=find(isnan(DependentVariable)==1);
else
  i1=find(sum(isnan(DependentVariable))>0);
end

if size(Covariate,2)==1
   i2=find(isnan(Covariate)==1);
else
   i2=find(sum(isnan(Covariate))>0);
end

invalid=union(i1,i2);
DependentVariable(invalid,:)=[];
Covariate(invalid,:)=[];
GroupLabel(invalid)=[];



Df_E = size(DependentVariable,1) - 2 - size(Covariate,2);
SSE_H = regress_wei(DependentVariable,[ones(size(DependentVariable,1),1),Covariate]);
SSE_H(isnan(SSE_H)) = 1;
% Calulate SSE
SSE = regress_wei(DependentVariable,[ones(size(DependentVariable,1),1),GroupLabel,Covariate]);
SSE(isnan(SSE)) = 1;

% Calculate F
pval =1-fcdf(((SSE_H-SSE)/1)./(SSE./Df_E),1,Df_E);


varargout{1}=pval;
varargout{2}=Df_E;
% varargout{3}=pval;





