function res = resamp(arg1,arg2,arg3)
% RESAMP --- basic resampling program
% res = resamp(data)
% resamples, WITH REPLACEMENT, a data set for bootstrapping
% If data is a matrix, this is done by rows
%
% res = resamp(nsamps,data)
% nsamps --- the number of resamples to take
%
% res = resamp(nsamps,data,1)
% samples WITHOUT REPLACEMENT

% (c) 1998-9 by Daniel T. Kaplan, All Rights Reserved


nsamps = -1; % flag --- nsamps not set
noresamp = 0; % flag --- sample with replacement

if nargin == 1
   data = arg1;
elseif nargin == 2
   if length(arg1) == 1
      nsamps = arg1;
      data = arg2;
   else
      data = arg1;
      noresamp = arg2;
   end
else
   nsamps = arg1;
   data = arg2;
   noresamp = arg3;
end

[r,c] = size(data);

% set nsamps
if nsamps == -1
  if r==1 | c == 1 % it's a vector
      nsamps = length(data);
  else
    nsamps = r;
  end
end

if noresamp
   indstotal = randperm(length(data));
   if nsamps > length(data)
      warning('resamp: cannot sample more than length(data) without replacement.');
      warning('using replacement sampling.');
      inds = ceil(length(data)*rand(nsamps,1));
   else
      inds = indstotal(1:nsamps);
	end   
else
   inds = ceil(length(data)*rand(nsamps,1));
end


if r==1 | c == 1
   res = data(inds);
else
   res = data(inds,:);
end
