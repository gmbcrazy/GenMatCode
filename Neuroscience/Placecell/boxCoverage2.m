function coverage = boxCoverage2(posx, posy, binWidth, boxType, radius)
% boxType=1 => rectangular box
% boxType=2 => cylinder 
 

binWidth = single(binWidth);

minX = nanmin(posx);
maxX = nanmax(posx);
minY = nanmin(posy);
maxY = nanmax(posy);

% Side lengths of the box
xLength = maxX - minX;
yLength = maxY - minY;

% Number of bins in each direction
colBins = ceil(xLength/binWidth); % ici x <-> Col
rowBins = ceil(yLength/binWidth); % ici y <-> Row

% Allocate memory for the coverage map
coverageMap = zeros(rowBins, colBins,'single');
rowAxis = zeros(rowBins,1,'single');
colAxis = zeros(colBins,1,'single');

% Find start values that centre the map over the path
xMapSize = colBins * binWidth; % ici x <-> Col
yMapSize = rowBins * binWidth;% ici y <-> Row
xOff = xMapSize - xLength;
yOff = yMapSize - yLength;


%%%Julie : § re-written to correctly fill coverage map (x/y inversion)
yStart = minY - yOff / 2;
yStop = yStart + binWidth;

% Julie 25.10.2012: in fact this § re-calculate occupancy map but
% - does not take into account smoothing (IS IT WHAT WE WANT ??)
for r = 1:rowBins
    rowAxis(r) = (yStart + yStop) / 2; 
    ind = find(posy >= yStart & posy < yStop);
    xStart = minX - xOff / 2; 
    xStop = xStart + binWidth; 
    for c = 1:colBins
        colAxis(c) = (xStart + xStop) / 2;
        coverageMap(r,c) = length(find(posx(ind) >= xStart & posx(ind) < xStop));% Julie : why is'it superior or equal here ?? (>=)
    xStart = xStart + binWidth;
    xStop = xStop + binWidth;
    end
    yStart = yStart + binWidth;
    yStop = yStop + binWidth;    
end
%%% end of the re-written §

if (boxType == 1) % for rectangular box
    coverage = length(find(coverageMap > 0)) / (colBins*rowBins) * 100;
else             % for cylinder
    %Julie : we define the coordinates of the center of cylindre, C : 
    rowC=(rowAxis(end)+rowAxis(1))/2;
    colC=(colAxis(end)+colAxis(1))/2;
    %%%%
    fullMap = zeros(rowBins, colBins,'single');
    for r = 1:rowBins
        for c = 1:colBins
            %dist = sqrt(rowAxis(r)^2 + colAxis(c)^2);
            dist = sqrt((rowAxis(r)-rowC)^2 + (colAxis(c)-colC)^2);% right definition of the circle but the center is not exactly well centered
            % due to rearrangement at the begining -> i will re-write the
            % 1st part of the fct using ccupancy map.
            if dist > radius
                fullMap(r,c) = NaN;
                coverageMap(r, c) = NaN;
            end
        end
    end
    numBins = sum(sum((isfinite(fullMap))));
    coverage = (length(find(coverageMap > 0)) / numBins) * 100;
end
