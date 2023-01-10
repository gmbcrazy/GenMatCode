% Calculates the auto-correlation map for the rate map
%
% Author: Raymond Skjerpeng and Jan Christian Meyer.
function Rxy = correlation(map)


bins = size(map,1);
N = bins + round(0.8*bins);
if ~mod(N,2)
    N = N - 1;
end
% Centre bin
cb = (N+1)/2;
Rxy = NaN(N);
%'correlation-function'
%tic
for r = 1:(N+1)/2
    rowOff = r-cb;
    numRows = bins - abs(rowOff);
    rSt1 = max(0, rowOff);
    rSt2 = abs(min(0,rowOff));
    for c = 1:N
        colOff = c-cb;
        numCol = bins - abs(colOff);
        cSt1 = max(0,colOff);
        cSt2 = abs(min(0,colOff));
        map1_local = map((rSt1+1):(rSt1+numRows),(cSt1+1):(cSt1+numCol));
        map2_local = map((rSt2+1):(rSt2+numRows),(cSt2+1):(cSt2+numCol));

        nans = max(isnan(map1_local),isnan(map2_local));
        NB = numRows * numCol - sum(sum(nans));

        if NB >= 20
            map1_local(nans) = 0;
            sumX = sum(sum(map1_local));
            sumX2 = sum(sum(map1_local.^2));
            % be careful sumx2 is var(map1_local) x NB
            sumx2 = sumX2 - sumX^2/NB;

            map2_local(nans) = 0;
            sumY = sum(sum(map2_local));
            sumY2 = sum(sum(map2_local.^2));
            % be careful sumy2 is var(map2_local) x NB
            sumy2 = sumY2 - sumY^2/NB;
            % If sumx2 and sumy2 are of the same sign
            if ~((sumx2<=0 && sumy2>=0) || (sumx2>=0 && sumy2<=0))
                sumXY = sum(sum(map1_local .* map2_local));
                % be careful sumx2 is cov(map1_local,map2_local) x NB
                sumxy = sumXY - sumX*sumY/NB;
                % Rxy is the correlation coef btw map1_local and map2_local
                Rxy(r,c) = sumxy/sqrt(sumx2*sumy2);
            end
        end
    end
end


% Fill the second half of the correlogram
for r = (N+1)/2+1:N
    rInd = cb + (cb - r);
    for c = 1:N
        cInd = cb + (cb - c);
        Rxy(r,c) = Rxy(rInd,cInd);
    end
end
