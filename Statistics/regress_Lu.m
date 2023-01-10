function [b,yhat,r,SSE] = regress_Lu(y,X)
% [b,r,SSE,SSR, T] = y_regress_ss(y,X)
% Perform regression.
% Revised from MATLAB's regress in order to speed up the calculation.
% Input:
%   y - Independent variable.
%   X - Dependent variable.
% Output:
%   b - beta of regression model.
%   r - residual.
%   SSE - The sum of squares of error.
%   SSR - The sum of squares of regression.
%   T - T value for each beta.


b = X \ y;
yhat = X*b;                     % Predicted responses at each data point.
r = y-yhat;                     % Residuals.
SSE=sum(r.^2);
end
