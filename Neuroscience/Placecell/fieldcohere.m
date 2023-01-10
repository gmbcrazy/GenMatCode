function [cc,z] = fieldcohere(map)
[n,m] = size(map);
tmp = zeros(n*m,2);
k=0;
for y = 1:n
    for x = 1:m
        k = k + 1;
        % Consider a 3x3box from top left to bottom right
        xstart = max([1,x-1]);
        ystart = max([1,y-1]);
        xend = min([m x+1]);
        yend = min([n y+1]);
        % check that the 8pixel periphery is not empty(NaN)
        nn = sum(sum(isfinite(map(ystart:yend,xstart:xend)))) - isfinite(map(y,x));
        % if it's not empty :
        if (nn > 0)
            tmp(k,1) = map(y,x);
            tmp(k,2) = nansum([ nansum(nansum(map(ystart:yend,xstart:xend))) , -map(y,x) ]) / nn;
        else
            tmp(k,:) = [NaN,NaN];    
        end
    end
end
% find the indices of the non-NaN lines in tmp 
index = find( isfinite(tmp(:,1)) & isfinite(tmp(:,2)) );
if length(index) > 3
    cc = corrcoef(tmp(index,:));
    z = atanh(cc(2,1));
    cc=cc(2,1);
else
    z = NaN;
end
