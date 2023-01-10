function  FileAveDay=PowerRep(FileData)

if length(FileData.RewardType)~=length(FileData.Sxx(:,1))
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

FileAveDay.All=PowerIndex(FileData,1:length(FileData.RewardType));
FileAveDay.Navi=PowerIndex(FileData,NaviIndex);
FileAveDay.Fore=PowerIndex(FileData,ForeIndex);
FileAveDay.DiNavi=PowerIndex(FileData,DiIndex);
FileAveDay.InDiNavi=PowerIndex(FileData,InDiIndex);

% FileAveDay.All=PowerIndex2(FileData,1:length(FileData.RewardType));
% FileAveDay.Navi=PowerIndex2(FileData,NaviIndex);
% FileAveDay.Fore=PowerIndex2(FileData,ForeIndex);
% FileAveDay.DiNavi=PowerIndex2(FileData,DiIndex);
% FileAveDay.InDiNavi=PowerIndex2(FileData,InDiIndex);
% 


function Data=PowerIndex(input,Index)

if isempty(Index)
   Data.Pxx=[];
   Data.Pyy=[];
   Data.Pxy=[];
   Data.Cxy=[];
   Data.f=[];
   return
end

TPxx=input.Sxx(Index,:);
TPyy=input.Syy(Index,:);
TPxy=input.Sxy(Index,:);

if length(Index)>1
Data.Pxx=mean(TPxx);
Data.Pxy=mean(TPxy);
Data.Pyy=mean(TPyy);
elseif length(Index)==1
   Data.Pxx=(TPxx);
   Data.Pxy=(TPxy);
   Data.Pyy=(TPyy);
else
    
end
esttype='mscohere';

[Data.Pxx,f,xunits] = computepsd(Data.Pxx',input.w,input.options.range,input.options.nfft,input.options.Fs,esttype);
[Data.Pyy,f,xunits] = computepsd(Data.Pyy',input.w,input.options.range,input.options.nfft,input.options.Fs,esttype);
[Data.Pxy,f,xunits] = computepsd(Data.Pxy',input.w,input.options.range,input.options.nfft,input.options.Fs,esttype);


Data.Cxy = (abs(Data.Pxy).^2)./(Data.Pxx.*Data.Pyy); % Cxy
Data.f=f;



function Data=PowerIndex2(input,Index)

if isempty(Index)
   Data.Pxx=[];
   Data.Pyy=[];
   Data.Pxy=[];
   Data.Cxy=[];
   Data.f=[];
   return
end

for i=1:length(Index)
TPxx=input.Sxx(Index(i),:);
TPyy=input.Syy(Index(i),:);
TPxy=input.Sxy(Index(i),:);

esttype='mscohere';

[Data.Pxx(i,:),f,xunits] = computepsd(TPxx',input.w,input.options.range,input.options.nfft,input.options.Fs,esttype);
[Data.Pyy(i,:),f,xunits] = computepsd(TPyy',input.w,input.options.range,input.options.nfft,input.options.Fs,esttype);
[Data.Pxy(i,:),f,xunits] = computepsd(TPxy',input.w,input.options.range,input.options.nfft,input.options.Fs,esttype);


Data.Cxy(i,:) = (abs(Data.Pxy(i,:)).^2)./(Data.Pxx(i,:).*Data.Pyy(i,:)); % Cxy
Data.f=f;
end

if length(Index)==1
else
Data.Cxy=sum(Data.Cxy)/length(Index);
Data.Pxx=sum(Data.Pxx)/length(Index);
Data.Pyy=sum(Data.Pyy)/length(Index);
   
end
