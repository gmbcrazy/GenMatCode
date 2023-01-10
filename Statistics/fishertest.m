function p = fishertest(x)
% function p = fishertest(x)
% 
% Fisher's exact test is used in the analysis of contingency tables.
% Usually, it is employed when sample sizes are small, but it is valid for all sample sizes,
% and given enough computer power, it is to be preferred over approximation tests.
% 
% It is named after its inventor, R. A. Fisher. It is called 'exact' because the probability
% of deviation from a null hypothesis can be calculated exactly, rather than relying on an 
% approximation that becomes exact in the limit as the sample size grows to infinity, 
% as with many statistical tests.
% 
% also see "Lady tasting tea" on Wikipedia
% 
% INPUT
% x   matrix with four entries which should be absolute (not relative!) frequencies
%     as in a fourfold contingency table (thus, x = [a,b;c,d]):
%    +---+---+
%    | a | b |
%    +---+---+
%    | c | d |
%    +---+---+
% 
% Fisher showed that the probability of obtaining any such set of values was given by the
% hypergeometric distribution:
% p = ((a+b)!(c+d)!(a+c)!(b+d)!) / (a!b!c!d!n!)
% This formula gives the exact probability of observing this particular arrangement of the data,
% assuming the given marginal totals, on the null hypothesis.
% 
% Maik C. Stttgen, September 2012
%% the (simple) works
a = x(1,1);
b = x(1,2);
c = x(2,1);
d = x(2,2);
p = (factorial(a+b)*factorial(c+d)*factorial(a+c)*factorial(b+d)) / ...
  (factorial(a)*factorial(b)*factorial(c)*factorial(d)*factorial(a+b+c+d));
