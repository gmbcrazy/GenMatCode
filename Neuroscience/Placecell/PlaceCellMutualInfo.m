function [Entr,Info]=PlaceCellMutualInfo(Data,RasterTime,Timerange)

%%Data(iZone).Raster  noted iZone iZone session
%%Data(iZone).CorrectIn
%%Data(iZone).RefTS
Raster=[];
TimeIndex=find(RasterTime>=Timerange(1)&RasterTime<=Timerange(2));
Pt=zeros(length(Data),length(TimeIndex));
Entr=0;
for iZone=1:length(Data)
%     PZone(iZone)=size(Data(iZone).Raster,1);
    PZone(iZone)=sum(sum(Data(iZone).Raster));
end
PZone=PZone/sum(PZone);
for iZone=1:length(Data)
    if PZone(iZone)~=0
        temp=RowAve(Data(iZone).Raster(:,TimeIndex));
        Pt(iZone,:)=temp/sum(temp);
        Raster=[Raster;Data(iZone).Raster(:,TimeIndex)];

    else
        Pt(iZone,:)=0;
    end
    t1=find(Pt(iZone,:)>0);
    Entr=Entr-PZone(iZone)*sum(Pt(iZone,t1).*log2(Pt(iZone,t1)));
end

temp=RowAve(Raster);
PtALL=temp./sum(temp);
PtALL(PtALL==0)=[];
TempR=-sum(PtALL.*log2(PtALL));

Info=TempR-Entr;

for iZone=1:length(Data)
%     PZone(iZone)=size(Data(iZone).Raster,1);
    PZoneT(iZone,:)=zeros(1,length(TimeIndex));
    if isempty(Data(iZone).Raster)
    
    else    
    PZoneT(iZone,:)=(RowAve(Data(iZone).Raster(:,TimeIndex)))*length(TimeIndex);
    end
    
end
PZoneT=PZoneT/sum(sum(PZoneT));

PZone=repmat(sum(PZoneT')',1,size(PZoneT,2));
PT=repmat(sum(PZoneT),size(PZoneT,1),1);

Index=find(PZoneT~=0);
Info=sum(sum(PZoneT(Index).*log2(PZoneT(Index)./PZone(Index)./PT(Index))));

Info=-sum(sum(PZoneT(Index).*log2(PZone(Index))));
% sum(sum(PZoneT(Index).*log2(PZoneT(Index)./PZone(Index)./PT(Index))));









