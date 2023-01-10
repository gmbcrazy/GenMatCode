function [spatialStability] = stability(splitDataArray, x, y, t, ts, p)

%[angStability, spatialStability] = stability(splitDataArray, x, y, t, ts, p)
% Calculates the angular and spatial stability
% splitDataArray 4x4.
% 1 Row:    First half of data (Half and half type split)
% 2 Row:    Second half of data (Half and half type split)
% 3 Row:    First half of data (Binned type split)
% 4 Row:    Seconf half of data (Binned type split)
% 1 Col:    Posx
% 2 Col:    Posy
% 3 Col:    Post
% 4 Col:    Head direction

% Calculate the extremal values
maxX = nanmax(x);
maxY = nanmax(y);
xStart = nanmin(x);
yStart = nanmin(y);
xLength = maxX - xStart + 10;
yLength = maxY - yStart + 10;
startPos = min([xStart,yStart]);
tLength = max([xLength,yLength]);


spatialStability = zeros(2,1);

% Divide the spike data into 2 halves
duration = t(end) - t(1);
ts1 = ts(ts <= duration/2);
ts2 = ts(ts > duration/2);

% Calculate the spike positions
[spkx1,spky1] = spikePos(ts1, splitDataArray{1,1}, splitDataArray{1,2}, splitDataArray{1,3});
[spkx2,spky2] = spikePos(ts2, splitDataArray{2,1}, splitDataArray{2,2}, splitDataArray{2,3});

% Calculate the rate maps
map1 = rateMap(splitDataArray{1,1},splitDataArray{1,2},spkx1,spky1,p.binWidth,p.binWidth,startPos ,tLength,startPos ,tLength,p.sampleTime,p);
map2 = rateMap(splitDataArray{2,1},splitDataArray{2,2},spkx2,spky2,p.binWidth,p.binWidth,startPos ,tLength,startPos ,tLength,p.sampleTime,p);


spatialStability(1) = zeroLagCorrelation(map1,map2);

% Divide the data by binning
numSpikes = length(ts);
ts3 = zeros(numSpikes,1);
totSpikes3 = 0;

ts4 = zeros(numSpikes,1);
totSpikes4 = 0;

duration = t(end) - t(1);
% Number of 1 minutes bins in the trial
nBins = ceil(duration / 60);
start = t(1);
stop = start + 60;

for ii = 1:nBins
    if mod(ii,2)
        ind = find(ts >= start & ts < stop);
        spikes = length(ind);
        if spikes > 0
            ts3(totSpikes3+1:totSpikes3+spikes) = ts(ind);
            totSpikes3 = totSpikes3 + spikes;
        end
    else
        ind = find(ts >= start & ts < stop);
        spikes = length(ind);
        if spikes > 0
            ts4(totSpikes4+1:totSpikes4+spikes) = ts(ind);
            totSpikes4 = totSpikes4 + spikes;
        end
    end
    start = start + 60;
    stop = stop + 60;
end
ts3 = ts3(1:totSpikes3);
ts4 = ts4(1:totSpikes4);

% Calculate the spike positions
[spkx3,spky3] = spikePos(ts3, splitDataArray{3,1}, splitDataArray{3,2}, splitDataArray{3,3});
[spkx4,spky4] = spikePos(ts4, splitDataArray{4,1}, splitDataArray{4,2}, splitDataArray{4,3});

% Calculate the rate maps
map3 = rateMap(splitDataArray{3,1},splitDataArray{3,2},spkx3,spky3,p.binWidth,p.binWidth,startPos,tLength,startPos,tLength,p.sampleTime,p);
map4 = rateMap(splitDataArray{4,1},splitDataArray{4,2},spkx4,spky4,p.binWidth,p.binWidth,startPos,tLength,startPos,tLength,p.sampleTime,p);

spatialStability(2) = zeroLagCorrelation(map3,map4);

% if isempty(splitDataArray{1,4}) || isempty(splitDataArray{2,4});
%     angStability = nan(2,1);
% else
%     angStability = zeros(2,1);
% 
%     spkInd1 = getSpkInd(ts1, splitDataArray{1,3});
%     spkInd2 = getSpkInd(ts2, splitDataArray{2,3});
% 
%     % Find the direction of the rat at the spike times
%     spkDir1 = splitDataArray{1,4}(spkInd1);
%     spkDir2 = splitDataArray{2,4}(spkInd2);
% 
%     spkDir1(isnan(spkDir1)) = [];
%     spkDir2(isnan(spkDir2)) = [];
% 
%     % Calculate the head direction maps
%     hd1 = hdstat(spkDir1*2*pi/360, splitDataArray{1,4}*2*pi/360, p.sampleTime, p,0);
%     hd2 = hdstat(spkDir2*2*pi/360, splitDataArray{2,4}*2*pi/360, p.sampleTime, p,0);
% 
%     % Calculate the correlation
%     corrValue = corrcoef(hd1.ratemap,hd2.ratemap);
%     angStability(1) = corrValue(1,2);
% 
% 
% 
% 
%     spkInd3 = getSpkInd(ts3, splitDataArray{3,3});
%     spkInd4 = getSpkInd(ts4, splitDataArray{4,3});
% 
%     % Find the direction of the rat at the spike times
%     spkDir3 = splitDataArray{3,4}(spkInd3);
%     spkDir4 = splitDataArray{4,4}(spkInd4);
% 
%     spkDir3(isnan(spkDir3)) = [];
%     spkDir4(isnan(spkDir4)) = [];
% 
%     % Calculate the head direction maps
%     hd3 = hdstat(spkDir3*2*pi/360, splitDataArray{3,4}*2*pi/360, p.sampleTime, p,0);
%     hd4 = hdstat(spkDir4*2*pi/360, splitDataArray{4,4}*2*pi/360, p.sampleTime, p,0);
% 
%     % Calculate the correlation
%     corrValue = corrcoef(hd3.ratemap,hd4.ratemap);
%     angStability(2) = corrValue(1,2);
end


% Finds the position timestamp indexes for spike timestamps
function spkInd = getSpkInd(ts,post)

ts(ts>post(end)) = [];
% Number of spikes
N = length(ts);
spkInd = zeros(N,1,'single');

currentPos = 1;
    for ii = 1:N
        ind = find(post(currentPos:end) >= ts(ii),1,'first') + currentPos - 1;

        spkInd(ii) = ind;
        currentPos = ind;
    end

end





