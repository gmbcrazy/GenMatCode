% Mehdi 05092016 :Comments added.
%
function [occ_map,IndexMap,rawMap,rowAxis,colAxis] = OccupancyVector_map(posx,posy,xStart,yStart,xEnd,yEnd,p)
     
shape(1) = 2;
shape(2) = 100;

% sampling period in sec
sampleTime = p.sampleTime;

% bins in cm
xBinWidth = p.binWidth;
yBinWidth = p.binWidth;

xLength = xEnd-xStart;
yLength = yEnd-yStart;

% coordinates of the center (based on the default arena-image loaded, not the current behaviour)
Center = [(xStart+xEnd)/2; (yStart+yEnd)/2];
center_arena_x = Center(1);
center_arena_y = Center(2);

% number of bins along x/y
numBinsX = ceil(xLength/xBinWidth);
numBinsY = ceil(yLength/yBinWidth);

% Allocate memory for the map
timeMap = zeros(numBinsY,numBinsX);
IndexMap = cell(numBinsY,numBinsX);

% these are same as numBinsX, numBinsY. numColBins=numBinsX; numRowBins=numBinsY
numColBins = ceil(xLength/p.binWidth);
numRowBins = ceil(yLength/p.binWidth);

% rowAxis and colAxis are the midline-axis of bins in y and x-direction respectively
rowAxis = zeros(numRowBins,1);
for ii = 1:numRowBins
    rowAxis(numRowBins-ii+1) = yStart+p.binWidth/2+(ii-1)*p.binWidth;
end
colAxis = zeros(numColBins, 1);
for ii = 1:numColBins
    colAxis(ii) = xStart+p.binWidth/2+(ii-1)*p.binWidth;
end

% comments added by someone else:
% Overall objective:
% For each (x-bin,y-bin) pair,
% count in spikemap/timemap (xbins x ybins) the number of places where
% (spky is in ybin and spkx is in xbin)
% (posy is in ybin and posx is in xbin)

% Bucketsort spikes and samples into regular bins
% Fortranesqe base1-indexing, add 1 for good measure

% timex_bin_idx : the x-bin the samples fall in. % timey_bin_idx : the y-bin the samples fall in.
timex_bin_idx = floor(((posx - xStart) / xBinWidth)) + 1;
timey_bin_idx = floor(((posy - yStart) / yBinWidth)) + 1;


% timeMap counts the number of pos-samples happenning in each bin
% IndexMap stores the sample-index of pos-samples happenning in each bin
for n = 1:length(timex_bin_idx)
    
    %(ii, jj) reprsents the bin(x-y) animal occupies in sample number n 
    ii = timex_bin_idx(n);
    jj = timey_bin_idx(n);
    
    if ii>0 && ii<=numBinsX && jj>0 && jj<=numBinsY % if its not a miss-trackign sample
                
        timeMap((numBinsY-jj+1),ii) = timeMap((numBinsY-jj+1),ii) + 1;      
        IndexMap{(numBinsY-jj+1),ii} = [IndexMap{(numBinsY-jj+1),ii};n];
        % be careful the Y axis is reversed by taking (numBinY-jj+1)
        % instead of jj (because track origin is in the left bottom corner 
        % whereas matrice origin is in the left top corner
    end
end

% Transform the number of samples crossing a bin to time (~ relativel time
% spent in that bin)
timeMap = timeMap * sampleTime;

% the first bin in x-direction = colAxis(1)
binPosX = (xStart+p.binWidth/2);


% This loop discards those timeMap values in the bin ii-jj (by assigning "nan") whose
% distance to the center of aparaturs is more than 50cm
%--------------------------------------------------------------------------
% for all bins in x-direction
for ii = 1:numColBins
    
    % the first bin in x-direction = rowAxis(end) (note that rowAxis is formatted in descending direction)
    binPosY = (yStart + p.binWidth/2);
    
    for jj = 1:numRowBins
        currentPosition = sqrt((binPosX-center_arena_x)^2 + (binPosY-center_arena_y)^2);
        if currentPosition > shape(2)/2
            timeMap(numRowBins-jj+1,ii) = NaN;
        end
        binPosY = binPosY + p.binWidth;
    end
    
    binPosX = binPosX + p.binWidth;
end
%--------------------------------------------------------------------------
% strange code (no initializatio, size may not equal timeMap in some cases; fortunately not used later)
rawMap(timeMap < p.minBinTime) = NaN;

% just replacement
occ_map =  timeMap;

% sets zero those bin with occupancy-time bellow a threshold (20 msec)
occ_map(timeMap<p.minBinTime) = 0;

% Set the axis
% Julie : this definition is ok for us to use it (usefull for placefield
% drawing)
% rq : this can probably be done using a vector rather than a loop

rowAxis = zeros(numRowBins,1);

for ii = 1:numRowBins
    rowAxis(numRowBins-ii+1) = yStart+p.binWidth/2+(ii-1)*p.binWidth;
end

colAxis = zeros(numColBins, 1);

for ii = 1:numColBins
    colAxis(ii) = xStart+p.binWidth/2+(ii-1)*p.binWidth;
end



% mehdi.
%--------------------------------------------------------------------------
% for debugging purposes
%--------------------------------------------------------------------------
% figure(1); clf; 
% set(gcf,'Units','Normalized','Position',[0.0667    0.2458    0.7630    0.5175]);
% subplot(121); hold on;
% set(gca,'Position',[.06 .08 .41 .88]);
% % normalized x-y axis
% xcolAxis = (colAxis);
% ycolAxis = (colAxis);
% 
% normBin = p.binWidth;
% 
% % plot bins
% for ii=1:length(xcolAxis)
%     plot([xcolAxis(ii)-normBin/2; xcolAxis(ii)-normBin/2], [ycolAxis(1)-normBin/2; ycolAxis(end)+normBin/2],'k:')
% end
%     plot([xcolAxis(end)+normBin/2; xcolAxis(end)+normBin/2], [ycolAxis(1)-normBin/2; ycolAxis(end)+normBin/2],'k:')
% 
% for ii=1:length(xcolAxis)
%     plot([xcolAxis(1)-normBin/2; xcolAxis(end)+normBin/2], [ycolAxis(ii)-normBin/2; ycolAxis(ii)-normBin/2],'k:')
% end
%     plot([xcolAxis(1)-normBin/2; xcolAxis(end)+normBin/2], [ycolAxis(end)+normBin/2; ycolAxis(end)+normBin/2],'k:')
% 
% % plot normalized actual trajectory
% plot((posx), (posy),'b-.','LineWidth',2)
% % plot timex_bin_idx based-on which time-map is geneerated
% % % % % plot(timex_bin_idx, timey_bin_idx,'r-','LineWidth',2)
% % config figure
% set(gca, 'xtick',(min(xcolAxis)-normBin/2:2*normBin:max(xcolAxis)+normBin/2), 'ytick',(min(ycolAxis)-normBin/2:2*normBin:max(ycolAxis)+normBin/2)...
%     ,'xlim',[min(xcolAxis)-normBin/2 , max(xcolAxis)+normBin/2], 'ylim', [min(ycolAxis)-normBin/2 , max(ycolAxis)+normBin/2]...
%     );
% xlabel('x (cm)')
% ylabel('y (cm)');
% axis equal
% 
% 
%--------------------------------------------------------------------------
% subplot(122); hold on;
% set(gca,'Position',[.53 .07 .41 .88]);
% 
% % normalized x-y axis
% xcolAxis = (colAxis- xStart)/xBinWidth;
% ycolAxis = (colAxis- yStart)/yBinWidth;
% 
% normBin = p.binWidth / xBinWidth;
% 
% % plot bins
% for ii=1:length(xcolAxis)
%     plot([xcolAxis(ii)-normBin/2; xcolAxis(ii)-normBin/2], [ycolAxis(1)-normBin/2; ycolAxis(end)+normBin/2],'k:')
% end
%     plot([xcolAxis(end)+normBin/2; xcolAxis(end)+normBin/2], [ycolAxis(1)-normBin/2; ycolAxis(end)+normBin/2],'k:')
% 
% for ii=1:length(xcolAxis)
%     plot([xcolAxis(1)-normBin/2; xcolAxis(end)+normBin/2], [ycolAxis(ii)-normBin/2; ycolAxis(ii)-normBin/2],'k:')
% end
%     plot([xcolAxis(1)-normBin/2; xcolAxis(end)+normBin/2], [ycolAxis(end)+normBin/2; ycolAxis(end)+normBin/2],'k:')
% 
% % plot normalized actual trajectory
% plot((posx - xStart) / xBinWidth, (posy - yStart) / yBinWidth,'b-.','LineWidth',2)
% % plot timex_bin_idx based-on which time-map is geneerated
% plot(timex_bin_idx, timey_bin_idx,'r-','LineWidth',2)
% % config figure
% set(gca, 'xtick',(min(xcolAxis)-normBin/2:2*normBin:max(xcolAxis)+normBin/2), 'ytick',(min(ycolAxis)-normBin/2:2*normBin:max(ycolAxis)+normBin/2)...
%     ,'xlim',[min(xcolAxis)-normBin/2 , max(xcolAxis)+normBin/2], 'ylim', [min(ycolAxis)-normBin/2 , max(ycolAxis)+normBin/2]...
%     );
% xlabel('scaled x')
% ylabel('scaled y');
% axis equal
%--------------------------------------------------------------------------
