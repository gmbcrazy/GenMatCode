% function [pval_Fisher, pval_Stouffer, pval_Stouffer_wei ] = meta_pval(p, diff, df)
function [z_socre, pval_Stouffer_wei] = meta_pval(p, diff, df)

% p = p_all_data;
% diff = diff_all_data;
% df = df_all_data;


p = p/2;
%%%%%%%%%%%% Fisher's method
% chi_square = -2*(sum(log(p)));
% pval_Fisher = 1-chi2cdf(chi_square, 2*length(p));
% 
% %%%%%%%%%%%% Stouffer's Z-score method
% [z_socre] = norminv(1-p);
% z_all = sum(z_socre)/sqrt(length(p));
% pval_Stouffer = 1-normcdf(z_all);

%%%%%%%%%%%% weighted Stouffer's Z-score method
z_socre_wei = norminv(1-p).*sign(diff);
weigth = sqrt(df);
% z_all_wei = abs(sum(z_socre_wei.*weigth,2)./sqrt(sum(weigth.*weigth,2)));
z_all_wei = abs(sum(z_socre_wei.*weigth)./sqrt(sum(weigth.*weigth)));

pval_Stouffer_wei = 2*(normcdf(z_all_wei,'upper'));
% z_socre = sum(z_socre_wei.*weigth,2)./sqrt(sum(weigth.*weigth,2));
z_socre = sum(z_socre_wei.*weigth)./sqrt(sum(weigth.*weigth));














