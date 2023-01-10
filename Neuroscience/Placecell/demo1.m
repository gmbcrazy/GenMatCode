
clear all;close all
filename='F:\Lu Data\Mouse008\step3\ldl\27052013\NaviReward-M08-270513002-f.nex';

cellName='Ch13Cell2';
[n, Spikes] = nex_ts2(filename, cellName);

[adfreq, NumPos, ts, fn, PosX] =nex_cont2(filename, 'PosX');
[adfreq, NumPos, ts, fn, PosY] =nex_cont2(filename, 'PosY');



fileimage='F:\DataTrack Lu\M07\Zone\step3.tif';
arena=imread(fileimage);


%     figure;
%     ImageSize=DayTr.Track(i).ImageSize;
%     ImageX=[1:512]*ImageSize(1)/512;
% %     ImageY=[512:-1:1]*ImageSize(2)/512;
%     ImageY=[1:512]*ImageSize(2)/512;
ImageSize=[132.99 132.99];
    ImageX=[1:512]*ImageSize(1)/512;
    ImageY=[1:512]*ImageSize(2)/512;

%     ImageX=[1:512];
%     ImageY=[1:512];
    
imagesc(ImageX,ImageY,arena);hold on

temp=double(arena);

[cols,rows,vals]=find(arena(:,:,1)<15&arena(:,:,2)<15&arena(:,:,3)<15);

rows=rows;
cols=cols;
rows=rows*ImageSize(1)/512;
cols=cols*ImageSize(2)/512;


figure;
imagesc(ImageX,ImageY,arena);hold on
plot(PosX,PosY,'g');hold on
plot(rows,cols,'r.');hold on

Xstart=min(rows);Xend=max(rows);
Ystart=min(cols);Yend=max(cols);
Center=[(Xstart+Xend)/2;(Ystart+Yend)/2];
plot(Center(1),Center(2),'b*');hold on;
plot([Xstart Xstart],[Ystart Yend],'r:');hold on;
plot([Xend Xend],[Ystart Yend],'r:');hold on;
plot([Xstart Xend],[Ystart Ystart],'r:');hold on;
plot([Xstart Xend],[Yend Yend],'r:');hold on;

axis xy

RX=Xend-Xstart;
RY=Yend-Ystart;

p.sampleTime=1/adfreq;
p.binWidth=2;
p.minBinTime=0.02;
p.smoothfactor=[1 1];
p.lowSpeedThreshold=5;
p.highSpeedThreshold=0;
p.RawminBinTime=0.1;
p.alphaValue=1000;


[x,y,t]=SpeedThreshold(PosX,PosY, ((1:NumPos)-1)*p.sampleTime,p.lowSpeedThreshold, p.highSpeedThreshold);

[occ_map, rawMap, xAxis, yAxis]=Occupancy_map(x,y,Xstart,Ystart,Xend,Yend,p);
yAxis=ImageSize(2)-yAxis;
figure;subplot(1,2,1);imagesc(xAxis, yAxis,rawMap);subplot(1,2,2);imagesc(xAxis, yAxis,occ_map);hold on;


[spkx,spky,spkInd] = spikePos(Spikes,x,y,((1:NumPos)-1)*p.sampleTime);


 figure;
 plot(spkx,spky,'r.');hold on; plot(rows,cols,'r.')
 
 [map, rawMap, xAxis, yAxis] = rateMap(x,y,spkx,spky,p.binWidth,p.binWidth,Xstart,Ystart,Xend,Yend,p.sampleTime, p);
 figure;
 imagesc(xAxis, yAxis,map,[0 25]);hold on

 plot(spkx,spky,'r.');hold on; plot(rows,cols,'r.')

 plot(rows,cols,'r.');
                          
% Calculate rate map with adaptive smoothing
shape(1)=2;
shape(2)=100;
[aMap, posPDF, aRowAxis, aColAxis]  = ratemapAdaptiveSmoothing(x, y, spkx, spky,Xstart,Ystart,Xend,Yend, p.sampleTime,p, shape, Center(1), Center(2));
aRowAxis=ImageSize(2)-aRowAxis;

figure;
h=imagesc(aColAxis,aRowAxis,aMap,[0 25]);hold on
set(h,'alphadata',~isnan(aMap));
plot(spkx,spky,'r.');hold on;
% plot(rows,cols,'r.');hold on;
plot(PosX,PosY,'g');hold on;

h=imagesc(ImageX,ImageY,arena);
set(h,'alphadata',(~(arena(:,:,1)>230&arena(:,:,2)>230&arena(:,:,3)>230))*0.7);
set(gca,'xlim',[0 120],'ylim',[0 120])

% figure;
% h=imagesc(aColAxis,aRowAxis, posPDF,[0 0.002]);hold on
% set(h,'alphadata',~isnan( posPDF));
% plot(spkx,spky,'r.');hold on;
% plot(rows,cols,'r.');hold on;
% plot(PosX,PosY,'g');hold on
% 
% 
 
%  [map, aMap, xAxis, yAxis, aRowAxis, aColAxis, maxPlotRate, posPDF]=Compute_rate_map(Spikes,x,y,((1:NumPos)-1)*p.sampleTime,Xstart,Ystart,Xend,Yend,p,1);
%  imagesc(map)












