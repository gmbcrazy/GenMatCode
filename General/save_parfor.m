function save_parfor(name_mat, varargin)
% save_parfor 
%
%   Inputs: name_mat: where the .mat will be saved, absolute path is
%                     recommended.
%           varargin: the variables will be saved, don't pass on the names of
%                     the variables, i.e, strings.
%
%   Outputs: 
%
%
% EXAMPLE
%
%
% NOTES
% Wenbin, 11-Nov-2014
% History:
% Ver. 11-Nov-2014  1st ed.
 
num_vars =nargin-1;
name_input =cell(1, num_vars);
for m = 1:num_vars
   name_input{m} =inputname(1+m);
   eval([name_input{m} '=varargin{m};']);
end
 
save(name_mat, name_input{:});