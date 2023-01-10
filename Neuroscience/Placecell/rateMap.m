function  varargout= rateMap(posx,posy,spkx,spky,xBinWidth,yBinWidth,xStart,yStart,xEnd,yEnd,sampleTime,p)

% % % [map, rawMap, rowAxis, colAxis, timeMap,spikeMap] = rateMap(posx,posy,spkx,spky,xBinWidth,yBinWidth,xStart,yStart,xEnd,yEnd,sampleTime,p)

xLength = xEnd-xStart;
yLength = yEnd-yStart;

numColBins = ceil(xLength/p.binWidth);
numRowBins = ceil(yLength/p.binWidth);
numBinsX = numColBins;
numBinsY = numRowBins;

rowAxis = zeros(numRowBins,1);
for ii = 1:numRowBins
    rowAxis(numRowBins-ii+1) = yStart+p.binWidth/2+(ii-1)*p.binWidth;
end
colAxis = zeros(numColBins, 1);
for ii = 1:numColBins
    colAxis(ii) = xStart+p.binWidth/2+(ii-1)*p.binWidth;
end

maxBins = max([numColBins, numRowBins]);

spikeMap = zeros(numRowBins, numColBins);
timeMap = zeros(numRowBins, numColBins);

posPdf = zeros(numRowBins, numColBins);



% 
% xLength = xEnd-xStart;
% yLength = yEnd-yStart;
% % Number of bins in each direction of the map
% numBinsX = ceil(xLength/xBinWidth);
% numBinsY = ceil(yLength/yBinWidth);
% 
% % Allocate memory for the maps
% spikeMap = zeros(numBinsY,numBinsX);
% timeMap = zeros(numBinsY,numBinsX);
% 
% xAxis = zeros(numBinsX,1);
% yAxis = zeros(numBinsY,1);



% Overall objective:
% Foreach (x-bin,y-bin) pair,
% count in spikemap/timemap (xbins x ybins) the number of places where
% (spky is in ybin and spkx is in xbin)
% (posy is in ybin and posx is in xbin)
% Bucketsort spikes and samples into regular bins
% Fortranesqe base1-indexing, add 1 for good measure

spkx_bin_idx = floor(((spkx - xStart) / xBinWidth)) + 1;
spky_bin_idx = floor(((spky - yStart) / yBinWidth)) + 1;
timex_bin_idx = floor(((posx - xStart) / xBinWidth)) + 1;
timey_bin_idx = floor(((posy - yStart) / yBinWidth)) + 1;
for n=1:length(spkx_bin_idx)
    ii = spkx_bin_idx(n);
    jj = spky_bin_idx(n);
    if ( ii>0 && ii<=numBinsX && jj>0 && jj<=numBinsY)
        spikeMap((numBinsY-jj+1),ii) = spikeMap((numBinsY-jj+1),ii) + 1;
    end
end
for n=1:length(timex_bin_idx)
    ii = timex_bin_idx(n);
    jj = timey_bin_idx(n);
    if ( ii>0 && ii<=numBinsX && jj>0 && jj<=numBinsY)
        timeMap((numBinsY-jj+1),ii) = timeMap((numBinsY-jj+1),ii) + 1;
    end
end

% Transform the number of spikes to time
timeMap = timeMap * sampleTime;
rawMap = spikeMap ./ timeMap;

temptimemap=timeMap;
timeMap = boxcarSmoothing(timeMap);
spikeMap = boxcarSmoothing(spikeMap);
spikeMap(temptimemap==0)= 0;

map = spikeMap ./ timeMap;


%%%%%%%For circular Arena
% % % % binPosX = (xStart+p.binWidth/2);
% % % % center_arena_x=(xStart+xEnd)/2;
% % % % center_arena_y=(yStart+yEnd)/2;
% % % % r=50;
% % % %     for ii = 1:numColBins
% % % %         binPosY = (yStart + p.binWidth/2);
% % % %         for jj = 1:numRowBins
% % % %             currentPosition = sqrt((binPosX-center_arena_x)^2 + (binPosY-center_arena_y)^2);
% % % % 
% % % %             currentPosition = sqrt((binPosX-center_arena_x)^2 + (binPosY-center_arena_y)^2);
% % % %             if currentPosition > r
% % % %                 map(numRowBins-jj+1,ii) = NaN;
% % % %                 posPdf(numRowBins-jj+1,ii) = NaN;
% % % %             end
% % % %         binPosY = binPosY + p.binWidth;
% % % % 
% % % %         end
% % % %         binPosX = binPosX + p.binWidth;
% % % % 
% % % %     end
%%%%%%%For circular Arena


if nargout==1
   varargout{1}=map;
elseif nargout==2
   varargout{1}=map;
   varargout{2}=rawMap;
elseif nargout==4
   varargout{1}=map;
   varargout{2}=rawMap;
   varargout{3}=rowAxis;
   varargout{4}=colAxis;
elseif nargout==5
       
   varargout{1}=map;
   varargout{2}=rawMap;
   varargout{3}=rowAxis;
   varargout{4}=colAxis;
   varargout{5}=timeMap;
elseif nargout==6
       
   varargout{1}=map;
   varargout{2}=rawMap;
   varargout{3}=rowAxis;
   varargout{4}=colAxis;
   varargout{5}=timeMap;
   varargout{6}=spikeMap;

else

end


% rawMap(timeMap < p.minBinTime) = NaN;

% % added 19.12.2012
% spikeMap(timeMap<0.1) = 0;
% added 14.11.2012
% spikeMap(timeMap<p.RawminBinTime) = 0;

% if p.smoothingMode == 0
%     % Smooth the spike and time map
%     spikeMap = boxcarSmoothing(spikeMap);
%     timeMap = boxcarSmoothing(timeMap);
% else
%     % Smooth the spike and time map
%     spikeMap = boxcarSmoothing3x3(spikeMap);
%     timeMap = boxcarSmoothing3x3(timeMap);
% end
% 
% spikeMap(isnan(spikeMap))=0;
% timeMap(isnan(timeMap))=0;
% 
% spikeMap = SmoothDec(spikeMap, p.smoothfactor);
% timeMap = SmoothDec(timeMap, p.smoothfactor);
% spikeMap = boxcarSmoothing(spikeMap);
% timeMap = boxcarSmoothing(timeMap);

% Calculate the smoothed rate map
% map = spikeMap ./ timeMap;
% 
% map(isnan(rawMap)) = NaN;

% Set the axis
% start = xStart + xBinWidth/2;
% for ii = 1:numBinsX
%     xAxis(ii) = start + (ii-1) * xBinWidth;
% end
% start = yStart + yBinWidth/2;
% for ii = 1:numBinsY
%     yAxis(ii) = start + (ii-1) * yBinWidth;
% end


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

% Gaussian smoothing using a boxcar method
function sMap = boxcarSmoothing3x3(map)

% Load the box template
box = boxcarTemplate2D3by3();

% Using pos and phase naming for the bins originate from the first use of
% this function.
[numPhaseBins,numPosBins] = size(map);

sMap = zeros(numPhaseBins,numPosBins,'single');

for ii = 1:numPhaseBins
    for jj = 1:numPosBins
        for k = 1:3
            % Phase index shift
            sii = k-1;
            % Phase index
            phaseInd = ii+sii;
            % Boundary check
            if phaseInd<1
                phaseInd = 1;
            end
            if phaseInd>numPhaseBins
                phaseInd = numPhaseBins;
            end
            
            for l = 1:3
                % Position index shift
                sjj = l-1;
                % Position index
                posInd = jj+sjj;
                % Boundary check
                if posInd<1
                    posInd = 1;
                end
                if posInd>numPosBins
                    posInd = numPosBins;
                end
                % Add to the smoothed rate for this bin
                sMap(ii,jj) = sMap(ii,jj) + map(phaseInd,posInd) * box(k,l);
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
   
% Gaussian boxcar template 3 x 3
function box = boxcarTemplate2D3by3()

box = [0.075, 0.125, 0.075;...
       0.125, 0.200, 0.125;...
       0.075, 0.125, 0.075];

box = single(box);   
   
   