% Calculates the correlation for a point in the autocorrelogram. It is
% using the Pearsons correlation method. The 2 maps are assumed to be of
% same size.
function Rxy = zeroLagCorrelation(map1,map2)

% Julie 09.11.2012 : seems to calculate correlation btw 2 maps
[numRows, numCols] = size(map1);

% TO DO ONE DAY ? 
% put NaN the bin < threshold in map1 and map2
% to be able to detect anti-correlation when rotation
% propostion for threshold (karim 13.12.2012) : 1/6 x peak

sumXY = 0;
sumX = 0;
sumY = 0;
sumX2 = 0;
sumY2 = 0;
NB = 0;
for r = 1:numRows
    for c = 1:numCols
        if ~isnan(map1(r,c)) && ~isnan(map2(r,c))
            NB = NB + 1;
            sumX = sumX + map1(r,c);
            sumY = sumY + map2(r,c);
            sumXY = sumXY + map1(r,c) * map2(r,c);
            sumX2 = sumX2 + map1(r,c)^2;
            sumY2 = sumY2 + map2(r,c)^2;
        end
    end
end

if NB >= 0
    sumx2 = sumX2 - sumX^2/NB; % be careful sumx2 is var(map1) x NB
    sumy2 = sumY2 - sumY^2/NB; % be careful sumy2 is var(map2) x NB
    sumxy = sumXY - sumX*sumY/NB; % be careful sumxy is cov(map1,map2) x NB
    if (sumx2<=0 && sumy2>=0) || (sumx2>=0 && sumy2<=0) % if not the same sign
        Rxy = NaN;
    else
        % Rxy is the correlation coef btw map1 and map2
        Rxy = sumxy/sqrt(sumx2*sumy2);
    end
else
    Rxy = NaN;
end
