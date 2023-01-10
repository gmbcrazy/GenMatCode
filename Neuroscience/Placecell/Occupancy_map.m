function [occ_map, rawMap, xAxis, yAxis] = Occupancy_map(posx,posy,...
                    xStart,yStart,xEnd,yEnd,p)
                
sampleTime=p.sampleTime;
xBinWidth=p.binWidth;
yBinWidth=p.binWidth;

xLength = xEnd-xStart;
yLength = yEnd-yStart;

% Number of bins in each direction of the map
numBinsX = ceil(xLength/xBinWidth);
numBinsY = ceil(yLength/yBinWidth);

% Allocate memory for the map
timeMap = zeros(numBinsY,numBinsX);

xAxis = zeros(numBinsX,1);
yAxis = zeros(numBinsY,1);

% Overall objective:
% Foreach (x-bin,y-bin) pair,
% count in spikemap/timemap (xbins x ybins) the number of places where
% (spky is in ybin and spkx is in xbin)
% (posy is in ybin and posx is in xbin)

% Bucketsort spikes and samples into regular bins
% Fortranesqe base1-indexing, add 1 for good measure

timex_bin_idx = floor(((posx - xStart) / xBinWidth)) + 1;
timey_bin_idx = floor(((posy - yStart) / yBinWidth)) + 1;

for n=1:length(timex_bin_idx)
    ii = timex_bin_idx(n);
    jj = timey_bin_idx(n);
    if ( ii>0 && ii<=numBinsX && jj>0 && jj<=numBinsY)
        timeMap((numBinsY-jj+1),ii) = timeMap((numBinsY-jj+1),ii) + 1;
        % be careful the Y axis is reversed by taking (numBinY-jj+1)
        % instead of jj (because track origin is in the left bottom corner 
        % whereas matrice origin is in the left top corner
    end
end

% Transform the number of pixel crossing to time
timeMap = timeMap * sampleTime;
rawMap(timeMap < p.minBinTime) = NaN;

% 
% if p.smoothingMode == 0
%     % time map   
%     timeMap = boxcarSmoothing(timeMap);
% else
%     %  time map   
%     timeMap = boxcarSmoothing3x3(timeMap);
% end

% %to choose the smoothing factor (in parameter file)% Julie october 2012
timeMap = SmoothDec(timeMap, p.smoothfactor);

% Calculate the smoothed rate map
occ_map =  timeMap;

occ_map(timeMap<p.minBinTime) = NaN;

% Set the axis
% Julie : this definition is ok for us to use it (usefull for placefield
% drawing)
% rq : this can probably be done using a vector rather than a loop

start = xStart + xBinWidth/2;
for ii = 1:numBinsX
    xAxis(ii) = start + (ii-1) * xBinWidth;
end
 
start = yStart + yBinWidth/2;
for ii = 1:numBinsY
    yAxis(ii) = start + (ii-1) * yBinWidth;
end

% Gaussian smoothing using a boxcar method
function sMap = boxcarSmoothing(map)

% Load the box template
box = boxcarTemplate2D();

% Size of map
[numRows,numCols] = size(map);

sMap = zeros(numRows,numCols);

for ii = 1:numRows
    for jj = 1:numCols
        
        for k = 1:5
            % Phase index shift
            sii = k-3;
            % Phase index
            rowInd = ii+sii;
            % Boundary check
            if rowInd<1
                rowInd = 1;
            end
            if rowInd>numRows
                rowInd = numRows;
            end
            
            for l = 1:5
                % Position index shift
                sjj = l-3;
                % Position index
                colInd = jj+sjj;
                % Boundary check
                if colInd<1
                    colInd = 1;
                end
                if colInd>numCols
                    colInd = numCols;
                end
                % Add to the smoothed rate for this bin
                sMap(ii,jj) = sMap(ii,jj) + map(rowInd,colInd) * box(k,l);
            end
        end
    end
end
   

% Gaussian boxcar template 5 x 5
function box = boxcarTemplate2D()

% Gaussian boxcar template
box = [0.0025 0.0125 0.0200 0.0125 0.0025;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0200 0.1000 0.1600 0.1000 0.0200;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0025 0.0125 0.0200 0.0125 0.0025;];

box = single(box);
   

% Calculate how many points lies inside the circle
%
% cx        X-coordinate for the circle centre
% cy        Y-coordinate for the circle centre
% radius    Radius for the circle
% pointX    X-coordinate(s) for the point(s) to check
% pointY    Y-coordinate(s) for the point(s) to check
function n = insideCircle(cx, cy, radius, pointX, pointY)

radius = radius^2;
dist = (pointX-cx).^2 + (pointY-cy).^2;
n = single(length(dist(dist <= radius)));




