function  FileAveDay=CauRep(FileData)

if length(FileData.RewardType)~=length(FileData.F1to2(:,1))
   'some trials missing'
FileAveDay.All=PowerIndex(FileData,FileData.ValidIndex);
FileAveDay.Navi=[];
FileAveDay.Fore=[];
FileAveDay.DiNavi=[];
FileAveDay.InDiNavi=[];
    return
end

NaviIndex=intersect(find(FileData.RewardType==1),FileData.ValidIndex);
ForeIndex=intersect(find(FileData.RewardType==2),FileData.ValidIndex);

DiIndex=intersect(find(FileData.NormDist<=(pi/2)),FileData.ValidIndex);
InDiIndex=intersect(find(FileData.NormDist>(pi/2)),FileData.ValidIndex);

DiIndex=intersect(NaviIndex,DiIndex);
InDiIndex=intersect(NaviIndex,InDiIndex);

FileAveDay.All=CauIndex(FileData,1:length(FileData.RewardType));
FileAveDay.Navi=CauIndex(FileData,NaviIndex);
FileAveDay.Fore=CauIndex(FileData,ForeIndex);
FileAveDay.DiNavi=CauIndex(FileData,DiIndex);
FileAveDay.InDiNavi=CauIndex(FileData,InDiIndex);




function Data=CauIndex(input,Index)

if isempty(Index)
   Data.Pxx=[];
   Data.Pyy=[];
   Data.Pxy=[];
   Data.Cxy=[];
   Data.f=[];
   return
end

Data.F1to2=mean(input.F1to2(Index,:));
Data.F2to1=mean(input.F2to1(Index,:));
Data.I1to2=mean(input.I1to2(Index,:));
Data.I2to1=mean(input.I2to1(Index,:));
Data.Coh=mean(input.Coh(Index,:));
Data.F=input.F;