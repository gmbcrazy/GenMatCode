function res = shuffle(data,n)
% SHUFFLE(data) 
% shuffles the order of the entries in data.
% This is used for sampling WITHOUT replacement.
%
% shuffle(data,n)
% Take n samples, WITHOUT replacement, from data.
% n must be no larger than the number of points in data
% otherwise, sampling will be done WITH replacement.
%
% shuffle(data, -n) or shuffle(data,0)
% treat data as a two-column array of multiplicities and values
% and sample without replacement.

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved

[r,c] = size(data);

if nargin < 2
   res = resamp(data,1); % flag to resamp for sampling WITH REPLACEMENT
else
   if c ~= 2 | n > 0
     res = resamp(n, data, 1);
   else
   nsamps = -n;
   if iscell(data)
      error('SHUFFLE doesn''t work with urns');
   elseif r==1 | c == 1
      % it's a simple vector
      inds = randperm(length(data) );
      res = data(inds);
   elseif c == 2
   % it's a pair of column vectors, use the first column for
   % multiplicity, and the second for the values.
   expanded = expand(data);
   if nsamps == 0
         res = resamp(expanded,1);
      else
         res = resamp(nsamps,expanded,1);
      end
      
   end 

   end   
end
   
   
   