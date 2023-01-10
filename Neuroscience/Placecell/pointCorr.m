function Rxy = pointCorr(map1,map2,rowOff,colOff,N)

% Calculates the correlation for a point in the autocorrelogram. It is
% using the Pearsons correlation method.

% Number of rows in the correlation for this lag
numRows = N - abs(rowOff);
% Number of columns in the correlation for this lag
numCol = N - abs(colOff);

% Set the start and the stop indexes for the maps
if rowOff > 0
    rSt1 = single(1+abs(rowOff)-1);
    rSt2 = single(0);
else
    rSt1 = single(0);
    rSt2 = single(abs(rowOff));
end
if colOff > 0
    cSt1 = single(abs(colOff));
    cSt2 = single(0);
else
    cSt1 = single(0);
    cSt2 = single(abs(colOff));
end

sumXY = single(0);
sumX = single(0);
sumY = single(0);
sumX2 = single(0);
sumY2 = single(0);
NB = single(0);
for ii = 1:numRows
    for jj = 1:numCol
        if ~isnan(map1(rSt1+ii,cSt1+jj)) && ~isnan(map2(rSt2+ii,cSt2+jj))
            NB = NB + 1;
            sumX = sumX + map1(rSt1+ii,cSt1+jj);
            sumY = sumY + map2(rSt2+ii,cSt2+jj);
            sumXY = sumXY + map1(rSt1+ii,cSt1+jj) * map2(rSt2+ii,cSt2+jj);
            sumX2 = sumX2 + map1(rSt1+ii,cSt1+jj)^2;
            sumY2 = sumY2 + map2(rSt2+ii,cSt2+jj)^2;
        end
    end
end

if NB >= 20
    sumx2 = sumX2 - sumX^2/NB;
    sumy2 = sumY2 - sumY^2/NB;
    sumxy = sumXY - sumX*sumY/NB;
    if (sumx2<=0 && sumy2>=0) || (sumx2>=0 && sumy2<=0)
        Rxy = single(NaN);
    else
        Rxy = sumxy/sqrt(sumx2*sumy2);
    end
else
    Rxy = single(NaN);
end


