function [a,b,rho,pval]=GT_cic_linear_regressBuzsaki(phi,x)


%%%%%%%Calculate the phase precession Slope and P-value
%%%%%created by Lu Zhang based on following work
%%%%%%%R. Kempter et al. / Journal of Neuroscience Methods 207 (2012) 113¨C 124
%%%%%phi is phase by rad, x is linear variable


% phi=circ_ang2rad(phi);
if isempty(phi)
   a=nan;
   b=nan;
   rho=nan;
   pval=nan;
   
   return
   
end

phi=phi(:);
x=x(:);

range=-5:0.01:5;

% range=0:0.01:1;

for i=1:length(range)
    R(i)=sqrt(mean(cos(phi-(2*pi*range(i))*x))^2+mean(sin(phi-(2*pi*range(i))*x))^2);
end

[~,Index]=max(R);

% figure;
% plot(R)

a=range(Index);

b=atan2(sum(sin(phi-(2*pi*a).*x)),sum(cos(phi-(2*pi*a).*x)));

a1=mod(abs(a)*2*pi*x,2*pi);

% [rho,pval]=circ_corrcc(mod(phi,2*pi),a1);
[rho,pval]=circ_corrcl(mod(phi,2*pi),x);
rho=sign(a)*rho;

% b=circ_rad2ang(b);
a=2*pi*a;




