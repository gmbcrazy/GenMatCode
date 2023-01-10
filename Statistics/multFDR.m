function [t,ts] = multFDR(P,df,q)
% Find common T threshold FDR over several images
% FORMAT [t,ts] = multFDR(P,df,q)
%
% P     Array of filenames of T images
% df    Common degrees-of-freedom of T images
% q     Level at which to control FDR
%
% t     Common level-q FDR T threshold
% ts    level-q FDR T threshold for each image (for comparison)
%______________________________________________________________________________
% $Id: multFDR.m,v 1.2 2004/10/15 02:56:20 nichols Exp $

if nargin<1, P = spm_get(Inf,'IMAGE','Select T images'); end
if nargin<2, df = spm_input('Enter df of T images','+1','r'); end
if nargin<3, FDRa = 0.05; end

V = spm_vol(P);

Pval = [];
Ths = [];
for i = 1:size(P,1)

    tmp = spm_read_vols(V(i));
    tmp = tmp(:); tmp(isnan(tmp)) = []; tmp(tmp==0) = [];
    tmp = 1-spm_Tcdf(tmp,df);

    Ths = [Ths; myFDR(tmp,FDRa)];
    Pval = [Pval; tmp];

end

Ths0 = myFDR(Pval,FDRa);

t = spm_invTcdf(1-Ths0,df);
ts = spm_invTcdf(1-Ths,df);

return



function [pID,pN] = myFDR(p,q)
%
% p   - vector of p-values
% q   - False Discovery Rate level
%
% pID - p-value threshold based on independence or positive dependence
% pN  - Nonparametric p-value threshold
%______________________________________________________________________________
% Based on FDR.m     1.4 Tom Nichols 02/07/02


p = sort(p(:));
V = length(p);
I = (1:V)';

cVID = 1;
cVN = sum(1./(1:V));

pID = p(max(find(p<=I/V*q/cVID)));
pN = p(max(find(p<=I/V*q/cVN)));

return



