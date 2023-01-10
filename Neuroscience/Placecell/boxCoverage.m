function coverage = boxCoverage(posx, posy, binWidth, boxType, radius)
% boxType=1 => rectangular box
% boxType=2 => cylinder 
 

binWidth = single(binWidth);

minX = nanmin(posx);
maxX = nanmax(posx);
minY = nanmin(posy);
maxY = nanmax(posy);

% Side lengths of the box
xLength = maxX - minX; % ici x <-> Col
yLength = maxY - minY;% ici y <-> Row

% Number of bins in each direction
colBins = ceil(xLength/binWidth);
rowBins = ceil(yLength/binWidth);

% Allocate memory for the coverage map
coverageMap = zeros(rowBins, colBins,'single');
rowAxis = zeros(rowBins,1,'single');
colAxis = zeros(colBins,1,'single');

% Find start values that centre the map over the path
xMapSize = colBins * binWidth;
yMapSize = rowBins * binWidth;
xOff = xMapSize - xLength;
yOff = yMapSize - yLength;

xStart = minX - xOff / 2;
xStop = xStart + binWidth;

% Julie 25.10.2012: in fact this § re-calculate occupancy map but
% - does not rotate the map (shoul not influence coverage calcul
% - does not take into account smoothing (IS IT WHAT WE WANT ??)
for r = 1:rowBins
    rowAxis(r) = (xStart + xStop) / 2; % ATTENTION !!! ici x <-> Row ERROR
    ind = find(posx >= xStart & posx < xStop);
    yStart = minY - yOff / 2;
    yStop = yStart + binWidth;
    for c = 1:colBins
        colAxis(c) = (yStart + yStop) / 2; % ATTENTION !!! ici y <-> Col ERROR
        coverageMap(r,c) = length(find(posy(ind) > yStart & posy(ind) < yStop));% Julie : why is'it superior or equal here ?? (>=) corrected in boxcoverage2
        yStart = yStart + binWidth;
        yStop = yStop + binWidth;
    end
    xStart = xStart + binWidth;
    xStop = xStop + binWidth;
end

if (boxType == 1) % for rectangular box
    coverage = length(find(coverageMap > 0)) / (colBins*rowBins) * 100;
else             % for cylinder
    fullMap = zeros(rowBins, colBins,'single');
    for r = 1:rowBins
        for c = 1:colBins
            dist = sqrt(rowAxis(r)^2 + colAxis(c)^2);
            if dist > radius
                fullMap(r,c) = NaN;
                coverageMap(r, c) = NaN;
            end
        end
    end
    numBins = sum(sum((isfinite(fullMap))));
    coverage = (length(find(coverageMap > 0)) / numBins) * 100;
end
