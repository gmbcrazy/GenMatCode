function [Rotation,DirAng,Motion_Vector,directVector,accerVector]=BehaviorEgo_Nex(filename,timerange,p)
% % [aMap, posPDF, aRowAxis, aColAxis, rawData,rawMap,spikeMap]=RateMap_Nex(filename,cellName,timerange,p)

% filename='F:\Lu Data\Mouse008\step3\ldl\27052013\NaviReward-M08-270513002-f.nex';
%p.fileimage='F:\DataTrack Lu\M07\Zone\step3.tif'
%p.ImageSize=[132.99 132.99];
% p.sampleTime=1/adfreq;
% p.binWidth=2;
% p.minBinTime=0.02;
% p.smoothfactor=[1 1];
% p.lowSpeedThreshold=5;
% p.highSpeedThreshold=0;
% p.RawminBinTime=0.1;


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

RX=Xend-Xstart;
RY=Yend-Ystart;

posTime=((1:NumPos)-1)*p.sampleTime+Lag;
     validIndex=[];
     for i=1:length(timerange(1,:))
         validIndex=[validIndex;find(timerange(1,i)<posTime&posTime<timerange(2,i))];
     end
     
     PosX=PosX(validIndex);
     PosY=PosY(validIndex);
     posTime=posTime(validIndex);

% NormTrace=NORMtrace([PosX(:) PosY(:)],p);
% NormTrace=NORMtrace([PosX(:) PosY(:)],p);

% rawData.Trace=NormTrace;

[x,y,t]=SpeedThreshold(PosX,PosY, posTime,p.lowSpeedThreshold, p.highSpeedThreshold);

% [x,y,t]=SpeedThreshold(PosX,PosY, ((1:NumPos)-1)*p.sampleTime-0.8,p.lowSpeedThreshold, p.highSpeedThreshold);

% [occ_map, rawMap, xAxis, yAxis]=Occupancy_map(x,y,Xstart,Ystart,Xend,Yend,p);
% yAxis=ImageSize(2)-yAxis;

x=x(:);
y=y(:);

% NormTrace=NORMtrace([x y],p);
% x=NormTrace(:,1);
% y=NormTrace(:,2);

vectorPosition=[diff(x) diff(y)];
Motion_Vector=vectorPosition;
directVector = vectorPosition./[sqrt(vectorPosition(:,1).^2+vectorPosition(:,2).^2)  sqrt(vectorPosition(:,1).^2+vectorPosition(:,2).^2)]; % devision by each vector-length
accerVector=diff(Motion_Vector);

[DirAng,~]=cart2pol(directVector(:,1),directVector(:,2));
V1=directVector(1:(end-1),:);
V2=directVector(2:end,:);
Rotation=-asin(V1(:,1).*V2(:,2)-V2(:,1).*V1(:,2))+pi/2;
%%%%%%%%if Rotation > 0, conterclockwise, go left
%%%%%%%%if Rotation < 0, clockwise, go right




