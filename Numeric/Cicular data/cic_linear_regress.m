function x=cic_linear_regress(t,s)
%%%%%t is phase by radius, s is linear variable

x = [cos(t),sin(t),ones(size(t))]\s;

a=x(1);
b=x(2);
c=x(3);

t0=atan2(b,a);
r=sqrt(a^2+b^2);

%%%%%s(t)=r*cos(t-t0)+c