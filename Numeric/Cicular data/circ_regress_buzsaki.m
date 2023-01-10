function [DATA]=circ_regress_buzsaki(x,t,k,ppdir,boot)
% Function to find approximation to circular-linear regression for phase
% precession.
% x - n-by-1 list of in-field positions (linear variable)
% t - n-by-1 list of phases
% k - number of random permutations to perform, to calculate p-value of fit
%     usually set to 1000.
% ppdir - 1-by-2 element vector to constrain slope, to avoid spurious
% values. Set to empty [], to perform unconstrained optimisation.
% boot - is a flag that enables(true) or disables(fales) bootstrap
% estimation of the correlation coefficient and it's confidence intervals -
% an additional check which is slow and probably unnecessary.
%
% Acknowledgments: Schmidt, Diba, Leibold, Schmitz, Buzsáki & Kempter 2009

%% Example (Data from Fisher $3.3)
% x = [107 46 33 67 122 69 43 30 12 25 37 69 5 83 68 38 21 1 71 60 71 71 57 53 38 70 7 48 7 21 27];
% t = [67 66 74 61 58 60 100 89 171 166 98 60 197 98 86 123 165 133 101 105 71 84 75 98 83 71 74 91 38 200 56]*(pi/180);
% [DATA]=circ_regress_raluca(x,t,1000,[])

%% Housekeeping
% Initialise variables
x = x(:);
t = t(:);

% Normalise x to lie in the range +/-1. This helps fminbnd along.
% minX = min(x);
% x = x - minX;
% A not very robust check to see if angles are in radians, range [0 2*pi]
t = mod(t,2*pi);

% Check dimensional consistency of inputs
if any(size(x)~=size(t))
    error('x and t must be of the same size/dimensionality');
end

% Set constraints on slope min/max given the data - this for phase
% precession: if we can be sure that phase precession must be in a certain
% direction, say because we know that intrinsic frequencuy is mostly above
% theta frequency or vice versa, we can setup the constraints on the slope
% to exclude spuriously high or low gradients. If ie = +1, the slope is
% constrained to be NEGATIVE, if ie = -1 slope is constrained to be
% POSITIVE. If ppdir = [], then this code produces unconstrained
% optimisation.
h = ppdir(1);% ie = ppdir(2);
if h==1 %&& ie==1
    con = [-1 eps];
elseif h==-1 %&& ie==-1
    con = [eps 1];
else
    con = [-1 1-eps];
end

% Constrain maximum slope to give at most 360 deg phase precession over the
% field. 
max_slope = (2*pi)/(max(x)-min(x));

%% Performs slope optimisation using fminbnd and find intercept

[DATA.slope_opt,DATA.fval_opt]=fminbnd(@(m) cost(m,x,t),...
    con(1)*max_slope, con(2)*max_slope, optimset('TolFun',1e-3, 'TolX', 1e-2)); %-0.000001

% DATA.phase_opt = mod(atan2(sum(sin(t - DATA.slope_opt*x)),...
%     sum(cos(t - DATA.slope_opt*x))) - DATA.slope_opt,2*pi);
% DATA.phase_opt = mod(atan2(sum(sin(t - DATA.slope_opt*x)),...
%     sum(cos(t - DATA.slope_opt*x))),2*pi);
DATA.phase_opt = atan2(sum(sin(t - DATA.slope_opt*x)),...
    sum(cos(t - DATA.slope_opt*x)));

% line for plot and unwrapping
% x = x + 1; % Recover original x values.
yhat = DATA.slope_opt*x + DATA.phase_opt; % model phase values
ydif = t - yhat; % Difference between model and observed values

%use the above to unwrap: subtract 2*pi when ydif>pi, add 2*pi when ydif<pi
%all values that are more than pi or less then -pi away from the regression
%line are shifted so that they are less than pi or more than -pi away. This
%is necessary, so that the linear correlation, performed below is a good
%approximation.
ycir = t;
ycir(ydif>5*pi/2) = t(ydif>5*pi/2) - 6*pi;
ycir(ydif>pi) = t(ydif>pi) - 2*pi;
ycir(ydif<-pi) = t(ydif<-pi) + 2*pi;

%compute correlation coefficient between x and unwrapped phase
[cor, p, rlo, rup]=corrcoef(ycir,x);
DATA.cor=cor(3);
DATA.p=p(3);
DATA.ci=[rlo(3) rup(3)];

% Most conservative and intuitive method of finding a p-value is to perform
% a randomisation test.
n=length(x);
ind = zeros(n,k);
for i=1:k
    ind(:,i) = randperm(n)';
end
j = size(x,1);
ybar = mean(ycir);
xbar = mean(x);
ycir = repmat(ycir,[1,k]);
rhosim = sort(cc(ycir,x(ind),ybar,xbar,j));
[m b] = min(abs(rhosim-DATA.cor));
if b>k/2
    DATA.psim = 1 - (b-1)/k;
else
    DATA.psim = (b+1)/k;
end
clear ind rhosim

% Finally, as an additional check, perform a bootstrap test to infer the
% correlation and it's significance (95% confidence interval)
if boot
    DATA.bootstrap.cor = mean(bootstrp(k,@cc,ycir(:,1),x,ybar,xbar,j));
    DATA.bootstrap.ci = bootci(k,{@cc,ycir(:,1),x,ybar,xbar,j})';
end

function [cost] = cost(m,x,t)
%% cost function to be minimised
%parameters: m=line slope, b=line intercept, x=data vector, k=von M
%concentration. Currently ommited.
alpha = t - m*x;
cost = -circ_r(alpha);

function [cor] = cc(ycir,x,ybar,xbar,j)
%% function to calculate simulated correlation values for significance
%% test.
cor = sum((x-xbar).*(ycir-ybar))/((j-1)*std(x(:,1)).*std(ycir(:,1)));