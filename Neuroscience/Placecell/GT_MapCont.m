function [VariMap,VariMapSample,VariMapXY,aRowAxis,aColAxis]=GT_MapCont(PosX,PosY,Time,ContiData,ContiTime,Xinterval,Yinterval,p)

%%%%%%%%%%calcualte the spatial distribution of continous signal: ContiData 
%%%%%%%%%%Time is sample time of PosX and PosY
%%%%%%%%%%TimeConti is sample time of and ContiData

p.sampleTime=mean(diff(Time));
adfreq1=round(1/p.sampleTime);
NumPos=length(PosX);

Lag=Time(1);
Xstart=min(Xinterval);Xend=max(Xinterval);
Ystart=min(Yinterval);Yend=max(Yinterval);
Center=[(Xstart+Xend)/2;(Ystart+Yend)/2];


RX=Xend-Xstart;
RY=Yend-Ystart;


[x,y,t]=SpeedThreshold(PosX,PosY,Time,p.lowSpeedThreshold, p.highSpeedThreshold);
[spkx,spky,spkInd,VariInd] = spikePosLu(ContiTime,x,y,Time);
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
           VariMap(i,j)=nansum(ContiData(VariInd(IndexMap{i,j})))/length(IndexMap{i,j});
           VariMapSample{i,j}=ContiData(VariInd(IndexMap{i,j}));
           VariMapXY.X{i,j}=x(spkInd(IndexMap{i,j}));
           VariMapXY.Y{i,j}=y(spkInd(IndexMap{i,j}));

        end
    end
end
