function [MapSpec,aRowAxis,aColAxis]=MapCohWavelet(fileName,Chan,WaveParam,p)

timerange=WaveParam.timerange;
F=WaveParam.ALLFreq;
wname=WaveParam.wname;
Samplingrate=WaveParam.Samplingrate;
ntw=WaveParam.ntw;
nsw=WaveParam.nsw;
range=WaveParam.range;
bin_width=1/Samplingrate;


fc = centfrq(wname);
scales=sort(fc./F./0.001);  
  


[NumStim, nm, nl, TSStim, names, NaviType] = nex_marker2(fileName, 'FirstStim');

% Temp=AnalysisP.ArtificialDelay;
Temp=1.2;

Fs=Samplingrate;
Temp=round(Temp*Fs);

TSStimI=round(TSStim*Fs);
TSStimI=TSStimI(:);
ArtI=[];
for i=1:length(TSStim)
    TempI=[(TSStimI(i)-10):(TSStimI(i)+Temp)];
    ArtI=[ArtI;TempI(:)];
end

for i=1:length(Chan)
    Data{i}=smrORnex_cont(fileName,Chan{i},timerange);
    ArtI=intersect(ArtI,[1:length(Data{i}.Data)]');
%     IArtI=setdiff(1:length(Data{i}.Data),ArtI);
%     meanN=mean(Data{i}.Data(IArtI));
%     stdN=std(Data{i}.Data(IArtI));
%     AddSig=random('norm',meanN,stdN,length(ArtI),1);
%     AddSig=AddSig(:);
%     Data{i}.Data(ArtI)=AddSig;
%     l(i)=length(Data{i}.Data);
end


% Data{1}.Data=zscore(Data{1}.Data(1:l));
% Data{2}.Data=zscore(Data{2}.Data(1:l));
% 







if ntw==1
[WCOH,WCS,CWT_S1,CWT_S2]=wcoherLU(Data{1}.Data,Data{2}.Data,scales,wname);
else
[WCOH,WCS,CWT_S1,CWT_S2]=wcoherLU(Data{1}.Data,Data{2}.Data,scales,wname,'ntw',ntw,'nsw',nsw);
end



NeedIndex=find(F>=WaveParam.Freq(1)&F<=WaveParam.Freq(2));
NeedIndex=length(F)-NeedIndex+1;

% imagesc(abs(WCOH(NeedIndex,:)))
Csore=mean(abs(WCOH(NeedIndex,:)));
Pscore1=mean(abs(CWT_S1(NeedIndex,:)));
Pscore2=mean(abs(CWT_S2(NeedIndex,:)));

Time=0:(1/Samplingrate):(length(Csore)-1)/Samplingrate;

Csore(ArtI)=[];
Pscore1(ArtI)=[];
Pscore2(ArtI)=[];
Time(ArtI)=[];

  

[adfreq, NumPos, ts, fn, PosX] =nex_cont2(fileName, 'PosXSmooth');
[adfreq, NumPos, ts, fn, PosY] =nex_cont2(fileName, 'PosYSmooth');

Lag=ts;

fileimage=p.fileimage;
arena=imread(fileimage);


%     figure;
%     ImageSize=DayTr.Track(i).ImageSize;
%     ImageX=[1:512]*ImageSize(1)/512;
% %     ImageY=[512:-1:1]*ImageSize(2)/512;
%     ImageY=[1:512]*ImageSize(2)/512;
ImageSize=p.ImageSize;
ImageX=[1:512]*ImageSize(1)/512;
ImageY=[1:512]*ImageSize(2)/512;

[cols,rows,vals]=find(arena(:,:,1)<15&arena(:,:,2)<15&arena(:,:,3)<15);

rows=rows*ImageSize(1)/512;
cols=cols*ImageSize(2)/512;



Xstart=min(rows);Xend=max(rows);
Ystart=min(cols);Yend=max(cols);
Center=[(Xstart+Xend)/2;(Ystart+Yend)/2];
xEnd=Xend;yEnd=Yend;
xStart=Xstart;yStart=Ystart;
center_arena_x=Center(1);
center_arena_y=Center(2);

RX=Xend-Xstart;
RY=Yend-Ystart;

xLength = xEnd-xStart;
yLength = yEnd-yStart;

% Number of bins in each direction of the map
numColBins = ceil(xLength/p.binWidth);
numRowBins = ceil(yLength/p.binWidth);

rowAxis = zeros(numRowBins,1);
for ii = 1:numRowBins
    rowAxis(numRowBins-ii+1) = yStart+p.binWidth/2+(ii-1)*p.binWidth;
end
colAxis = zeros(numColBins, 1);
for ii = 1:numColBins
    colAxis(ii) = xStart+p.binWidth/2+(ii-1)*p.binWidth;
end

maxBins = max([numColBins, numRowBins]);

mapC = zeros(numRowBins, numColBins);
mapS1 = zeros(numRowBins, numColBins);
mapS2 = zeros(numRowBins, numColBins);

posPdf = zeros(numRowBins, numColBins);


binPosX = (xStart+p.binWidth/2);


[x,y,t]=SpeedThreshold(PosX,PosY, ((1:NumPos)-1)*p.sampleTime+Lag,p.lowSpeedThreshold, p.highSpeedThreshold);

% [occ_map, rawMap, xAxis, yAxis]=Occupancy_map(x,y,Xstart,Ystart,Xend,Yend,p);
% yAxis=ImageSize(2)-yAxis;
% figure;subplot(1,2,1);imagesc(xAxis, yAxis,rawMap);subplot(1,2,2);imagesc(xAxis, yAxis,occ_map);hold on;

[spkx,spky,spkInd] = spikePos(Time,x,y,t);
% [aMap, rawMap, aRowAxis, aColAxis] = rateMap(x,y,spkx,spky,p.binWidth,p.binWidth,Xstart,Ystart,Xend,Yend,p.sampleTime, p);
                          
% Calculate rate map with adaptive smoothing
shape(1)=2;
shape(2)=100;

% xBinWidth=p.binWidth;
% yBinWidth=p.binWidth;
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
% mapC=spikeMap;
% mapS1=spikeMap;
% mapS2=spikeMap;
% 
% 
% xAxis = zeros(numBinsX,1);
% yAxis = zeros(numBinsY,1);
% 
% 
% 
% spkx_bin_idx = floor(((spkx - xStart) / xBinWidth)) + 1;
% spky_bin_idx = floor(((spky - yStart) / yBinWidth)) + 1;
% timex_bin_idx = floor(((spkx - xStart) / xBinWidth)) + 1;
% timey_bin_idx = floor(((spky - yStart) / yBinWidth)) + 1;
% for n=1:length(spkx_bin_idx)
%     ii = spkx_bin_idx(n);
%     jj = spky_bin_idx(n);
%     if ( ii>0 && ii<=numBinsX && jj>0 && jj<=numBinsY)
%         spikeMap((numBinsY-jj+1),ii) = spikeMap((numBinsY-jj+1),ii) + 1;
%         
%         mapC((numBinsY-jj+1),ii) = mapC((numBinsY-jj+1),ii) + Csore(n);
%         mapS1((numBinsY-jj+1),ii) = mapS1((numBinsY-jj+1),ii) + Pscore1(n);
%         mapS2((numBinsY-jj+1),ii) = mapS2((numBinsY-jj+1),ii) + Pscore2(n);
% 
%     end
% end
% 
% 
% 
% mapC=mapC./spikeMap; 
% mapS1=mapS1./spikeMap; 
% mapS2=mapS2./spikeMap; 
% 






    for ii = 1:numColBins
        
        binPosY = (yStart + p.binWidth/2);
        for jj = 1:numRowBins
            currentPosition = sqrt((binPosX-center_arena_x)^2 + (binPosY-center_arena_y)^2);
            if currentPosition > shape(2)/2
                map(numRowBins-jj+1,ii) = NaN;
                posPdf(numRowBins-jj+1,ii) = NaN;
            else
                n = 0;
                s = 0;
                    index = insideBinIndex(binPosX, binPosY, p.binWidth, spkx,spky);
                    n=length(index);

                % Set the rate for this bin
                if n~=0
                   
                mapC(jj,ii) = sum(Csore(index))/n;
                mapS1(jj,ii) = sum(Pscore1(index))/n;
                mapS2(jj,ii) = sum(Pscore2(index))/n;
                posPdf(jj,ii) = n*p.sampleTime;
                end
                
            end
            binPosY = binPosY + p.binWidth;
        end 
        binPosX = binPosX + p.binWidth;
    end

mapC(posPdf<0.100) = NaN;
mapS1(posPdf<0.100) = NaN;
mapS2(posPdf<0.100) = NaN;

mapC(mapC==0) = NaN;
mapS1(mapS1==0) = NaN;
mapS2(mapS2==0) = NaN;




posPdf = posPdf / nansum(nansum(posPdf));














%     for ii = 1:numColBins
%         
%         
%         binPosY = (yStart + p.binWidth/2);
%         for jj = 1:numRowBins
%             currentPosition = sqrt((binPosX-center_arena_x)^2 + (binPosY-center_arena_y)^2);
%             if currentPosition > shape(2)/2
%                 map(numRowBins-jj+1,ii) = NaN;
%                 posPdf(numRowBins-jj+1,ii) = NaN;
%             else
%                 n = 0;
%                 s = 0;
%                 r=1;
%                 for r = 1:maxBins
%                     % Set the current radius of the circle
%                     radius = r * p.binWidth;
%                     % Number of samples inside the circle
% %                     n = insideCircle(binPosX, binPosY, radius, posx, posy);         
%                     % Number of spikes inside the circle
% %                     s = insideCircle(binPosX, binPosY, radius, spkx, spky);
%                     
%                     index = insideCircleIndex(binPosX, binPosY, radius, spkx,spky);
%                     n=length(index);
% 
%                     if r >= p.alphaValue/n^2         
%                         break;
%                     end
% % 
%                 end
%                 % Set the rate for this bin
%                 if n~=0
%                 mapC(jj,ii) = sum(Csore(index))/n/r;
%                 mapS1(jj,ii) = sum(Pscore1(index))/n/r;
%                 mapS2(jj,ii) = sum(Pscore2(index))/n/r;
% 
%                 posPdf(jj,ii) = n*p.sampleTime;
%                 end
%                 
%             end
%             binPosY = binPosY + p.binWidth;
%         end 
% 
%         binPosX = binPosX + p.binWidth;
%     end

% mapC(posPdf<0.100) = NaN;
% mapS1(posPdf<0.100) = NaN;
% mapS2(posPdf<0.100) = NaN;
% 
% mapC(mapC==0) = NaN;
% mapS1(mapS1==0) = NaN;
% mapS2(mapS2==0) = NaN;
% 



% posPdf = posPdf / nansum(nansum(posPdf));

aRowAxis=rowAxis;
aColAxis=colAxis;
aRowAxis=ImageSize(2)-aRowAxis;
MapSpec.mapC=mapC;
MapSpec.mapS1=mapS1;
MapSpec.mapS2=mapS2;


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

function index = insideCircleIndex(cx, cy, radius, pointX, pointY)

radius = radius^2;
dist = (pointX-cx).^2 + (pointY-cy).^2;
index = find(dist <= radius);



function index = insideBinIndex(cx, cy, Tbinwidth, pointX, pointY)

dist = (pointX-cx).^2 + (pointY-cy).^2;
indexX=find(abs(pointX-cx)<(Tbinwidth/2));
indexY=find(abs(pointY-cy)<(Tbinwidth/2));
index = intersect(indexX,indexY);





function cmap = getCmap()

% Set the number of colors to scale the image with
numLevels = 256;

% set the colormap using the jet color map (The jet colormap is associated 
% with an astrophysical fluid jet simulation from the National Center for 
% Supercomputer Applications.)
cmap = colormap(jet(numLevels));