function CircosPlot(Data,PathData,Pth,MCcorrection,PlotAll,varargin)


if ischar(Data)
   load(Data);
sig=sign(Z_wei);

   if ~isempty(strfind(MCcorrection,'FWER'))
   pth=pth/(size(sig,1)*(size(sig,1)-1)/2);   %%%%%%%%%%%%%bonforni corection
elseif ~isempty(strfind(MCcorrection,'FDR'))  %%%%%%%%%%%%%Fdr corection
   pth=Thfdr_Pmatrix(pval_meta,Pth)+0.0000000000001;
else                      
   pth=Pth;
end
sig(pval_meta>pth)=0;



else
   sig=Data;
end

if nargin==6
   'AAL2 120 region is used';
   load('D:\FMRI\AAL\LuAAL120OldName.mat')
   EdgeGroupPlot=0;

elseif nargin==7
   load('D:\FMRI\AAL\LuAAL120OldName.mat')
   EdgeGroupPlot=varargin{2};
else
   'AAL2 116 region is used';
   load('D:\FMRI\AAL\LuAAL.mat')
   EdgeGroupPlot=0;


end

[LobleID,Index]=sort(LobleID);
LobleName=LobleName(Index);
sig=sig(Index,Index);
RegionName=RegionName(Index);
% i1=intersect(EdgeMetaNeed(:,1),Index)

if PlotAll~=1
   Index=find(nansum(abs(sig))>0);
   sig=sig(Index,Index);
   LobleName=LobleName(Index);
   RegionName=RegionName(Index);
   LobleID=LobleID(Index);
end


fileID = fopen([PathData 'circosNode.txt'],'w');
Show(1,:)='                                              ';
for i=1:size(LobleID)
    temptext=['chr - al' num2str(i) ' ' RegionName{i} ' 0 4 lob' num2str(LobleID(i))];
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);

clear Show
HistNum=nansum(abs(sig));
fileID = fopen([PathData 'circosHist.txt'],'w');
Show(1,:)='                                              ';
for i=1:size(LobleID)
    temptext=['al' num2str(i) ' 0 4 ' num2str(HistNum(i)) ' fill_color=lob' num2str(LobleID(i))];
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
clear Show




if  EdgeGroupPlot==0
sigP=sig;
sigP(sigP<=0)=0;
sigN=sig;
sigN(sigN>=0)=0;

%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link
[i1,i2,~]=find(sigP>0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
clear Show
Show1(1,:)='                                              ';

for ii=1:length(Valid)
    temptext=['al' num2str(i1(ii)) ' 2 3 ' 'al' num2str(i2(ii)) ' 2 3 ' 'color=PosLink'];
    Show1(ii,1:length(temptext))=temptext;
end

[i1,i2,~]=find(sigN<0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
clear Show
Show2(1,:)='                                              ';


for ii=1:length(Valid)
    temptext=['al' num2str(i1(ii)) ' 2 3 ' 'al' num2str(i2(ii)) ' 2 3 ' 'color=NegLink'];
    Show2(ii,1:length(temptext))=temptext;
end

Show=[Show1;Show2];
fileID = fopen([PathData 'circosLink.txt'],'w');


for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);








%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link

else    %%%%%%%%%%%%%%%%%%%%%%%%plot Link by Community

    SigP=sig;
    Candi=unique(SigP(:));
    Candi(Candi==0)=[];
    clear Show
    Show(1,:)='                                              ';

    CandiAll=EdgeGroupPlot;

    for i=1:length(Candi)
        
[i1,i2,~]=find(SigP==Candi(i));


Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
ShowTemp(1,:)='                                              ';

for ii=1:length(Valid)
    temptext=['al' num2str(i1(ii)) ' 2 3 ' 'al' num2str(i2(ii)) ' 2 3 ' 'color=Com' num2str(i) '9'];
    ShowTemp(ii,1:length(temptext))=temptext;
end

clear i1 i2
Show=[Show;ShowTemp];
clear ShowTemp
Show(1,:)=[];    
    end

fileID = fopen([PathData 'circosLink.txt'],'w');


for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);



SigP=sig;
    for i=1:length(CandiAll)

clear SigPHist
SigPHist=zeros(size(SigP));
SigPHist(find(SigP==CandiAll(i)))=1;
SigPHist=sum(SigPHist);

fileID = fopen([PathData 'circosHistC' num2str(i) '.txt'],'w');
ShowChist(1,:)='                                              ';
for ii=1:size(LobleID)
    temptext=['al' num2str(ii) ' 0 4 ' num2str(SigPHist(ii)) ' fill_color=Com' num2str(i)];
    ShowChist(ii,1:length(temptext))=temptext;
end
for ii=1:length(ShowChist(:,1))
    fprintf(fileID,'%s\r\n',deblank(ShowChist(ii,:)));
end
fclose(fileID);
clear ShowChist
    end
    
    end
    







%%%%%%%%%%%%%%%%%%%%%%%%plot Link by Community

    




