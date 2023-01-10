function [aMap,posPDF,RotationTS,AlloDirTS,DirMap]=SpatialShuffle_Nex(filename,cellName,timerange,p,ShuffleNum,ShuffleRange)
% % [aMap, posPDF, aRowAxis, aColAxis, rawData,rawMap]=RateMap_Nex(filename,cellName,timerange,p)


%%%shuffle the spikes in Shuffle Range for ShuffleNum times, to generate
%%%surgrate data for firing maps, headdirection analysis and self-motion
%%%analysis


% filename='F:\Lu Data\Mouse008\step3\ldl\27052013\NaviReward-M08-270513002-f.nex';
% cellName='Ch13Cell1';
%p.fileimage='F:\DataTrack Lu\M07\Zone\step3.tif'
%p.ImageSize=[132.99 132.99];
% p.sampleTime=1/adfreq;
% p.binWidth=2;
% p.minBinTime=0.02;
% p.smoothfactor=[1 1];
% p.lowSpeedThreshold=5;
% p.highSpeedThreshold=0;
% p.RawminBinTime=0.1;
% p.alphaValue=1000;
if iscell(cellName)
    Spikes=[];
    for i=1:length(cellName)
    [n, Spikestemp] = nex_ts2(filename, cellName{i});
     Spikes=[Spikes;Spikestemp(:)];
    
    end
    Spikes=sort(Spikes);
    n=length(Spikes);
else
[n, Spikes] = nex_ts2(filename, cellName);
end


Spikes=Spikes(:);
     temp_sig=[];
     for i=1:length(timerange(1,:))
         temp_sig=[temp_sig;Spikes(timerange(1,i)<Spikes&Spikes<timerange(2,i))];
     end
     
Spikes=temp_sig;

[adfreq, NumPos, ts, fn, PosX] =nex_cont2(filename, 'PosXSmooth');
[adfreq, NumPos, ts, fn, PosY] =nex_cont2(filename, 'PosYSmooth');

rawData.Trace=[PosX(:) PosY(:)];

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

%     ImageX=[1:512];
%     ImageY=[1:512];
    
% imagesc(ImageX,ImageY,arena);hold on
% temp=double(arena);

[cols,rows,vals]=find(arena(:,:,1)<15&arena(:,:,2)<15&arena(:,:,3)<15);

rows=rows*ImageSize(1)/512;
cols=cols*ImageSize(2)/512;


% figure;
% imagesc(ImageX,ImageY,arena);hold on
% plot(PosX,PosY,'g');hold on
% plot(rows,cols,'r.');hold on

Xstart=min(rows);Xend=max(rows);
Ystart=min(cols);Yend=max(cols);
Center=[(Xstart+Xend)/2;(Ystart+Yend)/2];
% plot(Center(1),Center(2),'b*');hold on;
% plot([Xstart Xstart],[Ystart Yend],'r:');hold on;
% plot([Xend Xend],[Ystart Yend],'r:');hold on;
% plot([Xstart Xend],[Ystart Ystart],'r:');hold on;
% plot([Xstart Xend],[Yend Yend],'r:');hold on;
% 
% axis xy

RX=Xend-Xstart;
RY=Yend-Ystart;



[x,y,t]=SpeedThreshold(PosX,PosY, ((1:NumPos)-1)*p.sampleTime+Lag,p.lowSpeedThreshold, p.highSpeedThreshold);
% [x,y,t]=SpeedThreshold(PosX,PosY, ((1:NumPos)-1)*p.sampleTime-0.8,p.lowSpeedThreshold, p.highSpeedThreshold);

% [occ_map, rawMap, xAxis, yAxis]=Occupancy_map(x,y,Xstart,Ystart,Xend,Yend,p);
% yAxis=ImageSize(2)-yAxis;
% figure;subplot(1,2,1);imagesc(xAxis, yAxis,rawMap);subplot(1,2,2);imagesc(xAxis, yAxis,occ_map);hold on;
% sum(isnan(x))
RawSpikes=Spikes;


    %%%%%%%%%%%%%%Lag permutation according to Moser's group way
 ShuffleLag = random('uni',ShuffleRange(1),ShuffleRange(2),ShuffleNum,1);
    %%%%%%%%%%%%%%Lag permutation according to Moser's group way

for Shufflei=1:ShuffleNum

    %%%%%%%%%%%%%%Lag permutation according to Moser's group way
    Spikes=RawSpikes+ShuffleLag(Shufflei);
    Spikes=sort(rem(Spikes,max(timerange(2,:))));
    Spikes=unique(Spikes);
    %%%%%%%%%%%%%%Lag permutation according to Moser's group way

%     %%%%%%%%%%%%%%ISI shuffle
%     Spikes=[0;RawSpikes];isi=diff(Spikes);
%     resample_index=1:length(isi);
%     resample1=randperm(length(isi),length(isi));
%     isi_new=isi(resample1);
%     Spikes=Spikes(1)+cumsum(isi_new);
%     %%%%%%%%%%%%%%ISI shuffle
% 
    
    
[spkx,spky,spkInd] = spikePos(Spikes,x,y,t);
% [aMap, rawMap, aRowAxis, aColAxis] = rateMap(x,y,spkx,spky,p.binWidth,p.binWidth,Xstart,Ystart,Xend,Yend,p.sampleTime, p);
                          
% Calculate rate map with adaptive smoothing
shape(1)=2;
shape(2)=100;
% [aMap{Shufflei}, posPDF{Shufflei}, ~, ~]  = ratemapAdaptiveSmoothing(x, y, spkx, spky,Xstart,Ystart,Xend,Yend, p.sampleTime,p, shape, Center(1), Center(2)); %%%%%traditional spatial map;place cell
[posPDF{Shufflei},~,DirMap{Shufflei},~,~]=TsTriMotionMap(spkInd,x,y,t,spkx,spky,Xstart,Ystart,Xend,Yend,p);  %%%%spike-triggered direction motion map
aMap=[];
RotationTS=[];
AlloDirTS=[];
% posPDF=[];
% [RotationTS{Shufflei},AlloDirTS{Shufflei}]=TsDirMotion(spkInd,x,y);   %%%%%headdirection,rotationdirection unning

rawData.TSpos=[spkx(:) spky(:)];
rawData.Trace=[x(:) y(:)];


end





