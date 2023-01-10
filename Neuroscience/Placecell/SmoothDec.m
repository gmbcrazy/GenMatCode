%Smooth - Smooth using a Gaussian kernel.
%
%  USAGE
%
%    smoothed = Smooth(data,smooth)
%
%    data           data to smooth
%    smooth         horizontal and vertical standard deviations [Sv Sh]
%                   for Gaussian kernel, measured in number of samples
%                   (0 = no smoothing)

% Copyright (C) 2004-2006 by Michaël Zugaro, 2009 Karim Benchenane
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.

function smoothed = SmoothDec(data,smooth)

vector = min(size(data)) == 1;
matrix = (~vector & length(size(data)) == 2);
if ~vector & ~matrix,
	error('Smoothing applies only to vectors or matrices (type ''help Smooth'' for details).');
end

if nargin < 2,
	error('Incorrect number of parameters (type ''help Smooth'' for details).');
end

% If Sh = Sv = 0, no smoothing required
if isa(smooth,'numeric') & all(~smooth),
	smoothed = data;
	return
end

%  if ~IsPositiveInteger(smooth,'off') | (matrix & length(smooth) > 2) | (vector & length(smooth) ~= 1),
%  	error('Incorrect value for property ''smooth'' (type ''help Smooth'' for details).');
%  end


if vector,
	% Vector smoothing
	if size(data,2) ~= 1,
		data = data';
	end
	% Build Gaussian kernel
	vSize = size(data,1);
	vSize = min([vSize 1001]);
	r = (-vSize:vSize)/vSize;
	vSmoothFactor = smooth/vSize;
	vSmoother = exp(-r.^2/vSmoothFactor^2/2);
	vSmoother = vSmoother/sum(vSmoother);
	% Convolute (and return central part)
	tmp = conv(vSmoother,data);
	if size(tmp,2) ~= 1,
		tmp = tmp';
	end
	middle = (size(tmp,1)-1)/2;
	smoothed = tmp(vSize+1:end-vSize,:);
else
	% Matrix smoothing
	if length(smooth) == 1,
		% For 2D data, providing only one value S for the std is interpreted as Sh = Sv = S
		smooth = [smooth smooth];
	end
	% Build Gaussian kernel
	[vSize,hSize] = size(data);
	hSize = min([hSize 1001]);
	vSize = min([vSize 1001]);
%  	maxSize = max([hSize vSize]);
%  	r = (-maxSize:maxSize)/maxSize;
	if smooth(1) ~= 0,
		r = (-vSize:vSize)/vSize;
		vSmoothFactor = smooth(1)/vSize;
		vSmoother = exp(-r.^2/vSmoothFactor^2/2);
		vSmoother = vSmoother/sum(vSmoother);
	end
	if smooth(2) ~= 0,
		r = (-hSize:hSize)/hSize;
		hSmoothFactor = smooth(2)/hSize;
		hSmoother = exp(-r.^2/hSmoothFactor^2/2);
		hSmoother = hSmoother/sum(hSmoother);
	end
	% Convolute
	if smooth(1) == 0,
		% Smooth only across columns (Sv = 0)
		for i = 1:size(data,1),
			tmp = conv(hSmoother,data(i,:))';
			middle = (size(tmp,2)-1)/2;
			start = middle - (hSize-1)/2;
			stop = middle + (hSize-1)/2;
			smoothed(i,:) = tmp(start:stop,:);
		end
	elseif smooth(2) == 0,
		% Smooth only across lines (Sh = 0)
		for i = 1:size(data,2),
			tmp = conv(vSmoother,data(:,i));
			middle = (size(tmp,1)-1)/2;
			start = middle - (vSize-1)/2;
			stop = middle + (vSize-1)/2;
			smoothed(:,i) = tmp(start:stop);
		end
	else
		% Smooth in 2D
		smoothed = conv2(vSmoother,hSmoother,data,'same');
	end
end
