function [VariMap,VariMapSample,VariMapXY,aRowAxis,aColAxis]=EgoMapCont(fileName,Variable,p)



[adfreq1, NumPos, tsX, fn, PosX] =nex_cont2(fileName, 'PosXSmooth');
[adfreq1, NumPos, tsY, fn, PosY] =nex_cont2(fileName, 'PosYSmooth');


[NumStim, nm, nl, TSStim, names, NaviType] = nex_marker2(fileName, 'FirstStim');
S1=TSStim(:)'+p.ArtifactPeriod(1);
S2=TSStim(:)'+p.ArtifactPeriod(2);

InvalidRange=[S1;S2];
Timerange=TimeRangeModify(p.timerange,InvalidRange);
Data=smrORnex_cont(fileName,Variable,Timerange);

p.sampleTime=mean(diff(Data(1).Time));

Time=[];
Vari=[];
for i=1:length(Data)
    Vari=[Vari;Data(i).Data(:)];
    Time=[Time;Data(i).Time(:)];
end
% plot(Time,Vari);

% MapSpec.X=PosX;
% MapSpec.Y=PosY;
% 
Lag=tsX;
% fileimage=p.fileimage;
% arena=imread(fileimage);
% 
% 
% ImageSize=p.ImageSize;
% ImageX=[1:512]*ImageSize(1)/512;
% ImageY=[1:512]*ImageSize(2)/512;
% 
% [cols,rows,vals]=find(arena(:,:,1)<15&arena(:,:,2)<15&arena(:,:,3)<15);
% 
% rows=rows*ImageSize(1)/512;
% cols=cols*ImageSize(2)/512;
% 
% Xstart=min(rows);Xend=max(rows);
% Ystart=min(cols);Yend=max(cols);
% Center=[(Xstart+Xend)/2;(Ystart+Yend)/2];
% 
Xstart=p.EgoRange(1);
Xend=p.EgoRange(2);
Ystart=p.EgoRange(3);
Yend=p.EgoRange(4);
Center=[(Xstart+Xend)/2;(Ystart+Yend)/2];
RX=Xend-Xstart;
RY=Yend-Ystart;


[x,y,t]=SpeedThreshold(PosX,PosY, ((1:NumPos)-1)./adfreq1+Lag,p.lowSpeedThreshold, p.highSpeedThreshold);

[spkx,spky,spkInd,VariInd] = EgoSpikePosLu(Time,x,y,t);
spkx=spkx.*adfreq1;
spky=spky.*adfreq1;

[occ_map,IndexMap,rawMap, aRowAxis, aColAxis] = OccupancyVector_map(spkx,spky,Xstart,Ystart,Xend,Yend,p);

VariMap=occ_map;
VariMap(~isnan(VariMap))=0;

l=length(VariMap(1,:));
r=length(VariMap(:,1));

VariMapSample=IndexMap;
VariMapXY.X=IndexMap;
VariMapXY.Y=IndexMap;

for i=1:r
    for j=1:l
        if length(IndexMap{i,j})==0
        else
           VariMap(i,j)=sum(Vari(VariInd(IndexMap{i,j})))/length(IndexMap{i,j});
           VariMapSample{i,j}=Vari(VariInd(IndexMap{i,j}));
           VariMapXY.X{i,j}=x(spkInd(IndexMap{i,j}));
           VariMapXY.Y{i,j}=y(spkInd(IndexMap{i,j}));

        end
    end
end
