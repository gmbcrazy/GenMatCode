function [A,B,r,U,V,stats] = partial_canoncorrLU(X,Y,Z)

%%%%%%based on page formula 126Bioinformatics, 31, 2015, i124¨Ci132
%%%%%%regress Z from X and Y and then use matlab defaut function canoncorr
X=X-Z*pinv(Z'*Z)*Z'*X;
Y=Y-Z*pinv(Z'*Z)*Z'*Y;

[A,B,r,U,V,stats] = canoncorr(X,Y);
