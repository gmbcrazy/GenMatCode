function CircosGE2(Data,PathData,varargin)

%%%%%Creat node, links, histogram, heatmap files for circos plot.
%%%%%Lu Zhang 2019


%%%%%Data is the n*n adjcent matrix of n nodes
%%%%%PathData is the path/file name where output file is saved
%%%%%varargin{1} LobleID is 1*n cell with node names defined
%%%%%varargin{2} RegionName defines the names of nodes
%%%%%varargin{3} PlotAll=1 then creat circos file for all nodes; otherwise only nodes
%%%%%with >1 links were ploted


sig=Data;

n=size(sig,1);
switch nargin
    case 2
    for i=1:n
        RegionName{i}=['Node' showNum(i,0)];
    end
    LobleID=zeros(1,n)+1;
    PlotAll=1;
    EdgeGroupPlotP=0;
    case 3
     LobleID=varargin{1};
     EdgeGroupPlotP=0;
    for i=1:n
        RegionName{i}=['Node' showNum(i,0)];
    end
    PlotAll=1;
    case 4
     LobleID=varargin{1};
     RegionName=varargin{2};
     EdgeGroupPlotP=0;
    PlotAll=1;
    case 5
     LobleID=varargin{1};
     RegionName=varargin{2};
     PlotAll=varargin{3};
     EdgeGroupPlotP=0;
    case 6
     LobleID=varargin{1};
     RegionName=varargin{2};
     PlotAll=varargin{3};
     EdgeGroupPlot=varargin{4};
     if iscell(EdgeGroupPlot)
         EdgeGroupPlotP=1;
     else
         EdgeGroupPlotP=EdgeGroupPlot;
     end
end


[LobleID,Index]=sort(LobleID);
sig=sig(Index,Index);
RegionName=RegionName(Index);
% i1=intersect(EdgeMetaNeed(:,1),Index)

if PlotAll~=1
   Index=find(nansum(abs(sig))>0);
   sig=sig(Index,Index);
   RegionName=RegionName(Index);
   LobleID=LobleID(Index);
end

maxC=max(max(abs(sig)));
IntC=maxC/8;

% % [UL,UI]=unique(LobleID);
% % ULN=LobleName(UI);
stepL=10;
InterstepL=2;
IDTemp=[1:length(LobleID)]*stepL;
LinkWidth=4;

fileID = fopen([PathData 'circosNode.txt'],'w');
Show(1,:)='                                              ';
for i=1:length(LobleID)
%     temptext=['chr - al' num2str(i) ' ' RegionName{i} ' 0 4 LUgroup' num2str(LobleID(i))];
    temptext=['chr - al' num2str(i) ' ' RegionName{i} ' ' num2str(InterstepL/2) ' ' num2str(stepL-InterstepL/2) ' LUgroup' num2str(LobleID(i))];
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);


%%%%%%%%%%%%%%%%%%%%%%%%%
% % clear Show
% % HistNum=nansum(abs(sig));
% % fileID = fopen([PathData 'circosTick.txt'],'w');
% % Show(1,:)='                                              ';
% % for i=1:size(LobleID,1)
% %     temptext=['al' num2str(i) ' ' num2str(IDTemp(i)-step) ' ' num2str(IDTemp(i)) ' ' RegionName{i}];
% %     Show(i,1:length(temptext))=temptext;
% % end
% % for i=1:length(Show(:,1))
% %     fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
% % end
% % fclose(fileID);
% % clear Show
sigP=sig;
sigP(sigP<=0)=0;
sigN=sig;
sigN(sigN>=0)=0;
sigN=abs(sigN);

clear Show
HistNum=nansum(abs(sigP));
fileID = fopen([PathData 'circosHistP.txt'],'w');
Show(1,:)='                                              ';
for i=1:length(LobleID)
    temptext=['al' num2str(i) ' ' num2str(InterstepL/2) ' ' num2str(stepL-InterstepL/2) ' ' num2str(HistNum(i)) ' fill_color=Pos19'];
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
clear Show

clear Show
HistNum=nansum(abs(sigN));
fileID = fopen([PathData 'circosHistN.txt'],'w');
Show(1,:)='                                              ';
for i=1:length(LobleID)
    temptext=['al' num2str(i) ' ' num2str(InterstepL/2) ' ' num2str(stepL-InterstepL/2) ' ' num2str(HistNum(i)) ' fill_color=Neg19'];
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
clear Show


%%%%%%%%%%%%%%%%%%%%%%%%%
clear Show
HistNum=nansum(abs(sig));
fileID = fopen([PathData 'circosTick.txt'],'w');
Show(1,:)='                                              ';
for i=1:length(LobleID)
    temptext=['al' num2str(i) ' ' num2str(InterstepL/2) ' ' num2str(stepL-InterstepL/2) ' ' RegionName{i}];
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
clear Show


if EdgeGroupPlotP==0
%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link
[i1,i2,~]=find(sigP>0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
clear Show
Show1(1,:)='                                              ';

for ii=1:length(Valid)
    tempC=ceil(sigP(i1(ii),i2(ii))/IntC);
    tempC=max(tempC,1);
    W1=InterstepL/2+LinkWidth/2;
    W2=W1+max(ceil(abs(sigP(i1(ii),i2(ii)))/maxC*LinkWidth),1);
    
    W3=InterstepL/2+LinkWidth/2;
    W4=W3+max(ceil(abs(sigP(i1(ii),i2(ii)))/maxC*LinkWidth),1);

%     temptext=['al' num2str(i1(ii)) ' ' num2str(IDTemp(i1(ii))-stepL/2-2) ' ' num2str(IDTemp(i1(ii))-stepL/2+2) ' al' num2str(i2(ii)) ' ' num2str(IDTemp(i2(ii))-stepL/2-2) ' ' num2str(IDTemp(i2(ii))-stepL/2+2) ' color=PosLink'];
    temptext=['al' num2str(i1(ii)) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(i2(ii)) ' ' num2str(W3) ' ' num2str(W4) ' color=Pos1' num2str(tempC)];
    Show1(ii,1:length(temptext))=temptext;
end

[i1,i2,~]=find(sigN>0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
clear Show
Show2(1,:)='                                              ';


for ii=1:length(Valid)
    tempC=ceil(sigN(i1(ii),i2(ii))/IntC);
    tempC=max(tempC,1);

    W1=InterstepL/2;
    W2=W1+ceil(abs(sigN(i1(ii),i2(ii)))/maxC*LinkWidth);
    
    W3=InterstepL/2;
    W4=W3+ceil(abs(sigN(i1(ii),i2(ii)))/maxC*LinkWidth);
    temptext=['al' num2str(i1(ii)) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(i2(ii)) ' ' num2str(W3) ' ' num2str(W4) ' color=Neg1' num2str(tempC)];

%     temptext=['al' num2str(i1(ii)) ' ' num2str(IDTemp(i1(ii))-stepL/2) ' ' num2str(IDTemp(i1(ii))-stepL/2+4) ' al' num2str(i2(ii)) ' ' num2str(IDTemp(i2(ii))-stepL/2) ' ' num2str(IDTemp(i2(ii))-stepL/2+4) ' color=NegLink'];
    Show2(ii,1:length(temptext))=temptext;
end

Show=[Show1;Show2];
fileID = fopen([PathData 'circosLink.txt'],'w');


for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link




%%%%%%%%%%%%%heat map of positive links
SigPHeat=nanmean(sigP);
fileID = fopen([PathData 'circosHeatP.txt'],'w');
ShowCHeat(1,:)='                                              ';
for ii=1:length(LobleID)
    tempC=ceil(SigPHeat(ii)/IntC);
    tempC=max(tempC,1);
    temptext=['al' num2str(ii) ' ' num2str(InterstepL/2) ' ' num2str(stepL-InterstepL/2) ' ' num2str(SigPHeat(ii)) ' fill_color=Pos1' num2str(tempC)];
    ShowCheat(ii,1:length(temptext))=temptext;
end
for ii=1:length(LobleID)
    fprintf(fileID,'%s\r\n',deblank(ShowCheat(ii,:)));
end
fclose(fileID);
clear ShowCheat
%%%%%%%%%%%%%heat map of positive links

%%%%%%%%%%%%%heat map of negative links
SigNHeat=nanmean(sigN);
fileID = fopen([PathData 'circosHeatN.txt'],'w');
ShowCHeat(1,:)='                                              ';
for ii=1:length(LobleID)
    tempC=ceil(SigNHeat(ii)/IntC);
    tempC=max(tempC,1);
    temptext=['al' num2str(ii) ' ' num2str(InterstepL/2) ' ' num2str(stepL-InterstepL/2) ' ' num2str(SigNHeat(ii)) ' fill_color=Neg1' num2str(tempC)];
    ShowCheat(ii,1:length(temptext))=temptext;
end
for ii=1:length(LobleID)
    fprintf(fileID,'%s\r\n',deblank(ShowCheat(ii,:)));
end
fclose(fileID);
clear ShowCheat
%%%%%%%%%%%%%heat map of negative links




%%%%%%%%%%%%%%%%%%%%%%%%plot Link by Community
else
    
    SigP=sig;
    Candi=unique(SigP(:));
    Candi(Candi==0)=[];
    clear Show
    Show(1,:)='                                              ';

    for i=1:length(Candi)
        
[i1,i2,~]=find(SigP==Candi(i));
Valid=find([i2-i1]>=0);
i1=i1(Valid);
i2=i2(Valid);
ShowTemp(1,:)='                                              ';
if exist('EdgeGroupPlot')
    for ii=1:length(Valid)
    temptext=['al' num2str(i1(ii)) num2str(InterstepL/2) ' ' num2str(stepL-InterstepL/2) 'al' num2str(i2(ii)) num2str(InterstepL/2) ' ' num2str(stepL-InterstepL/2) 'color=' EdgeGroupPlot{i}];
    ShowTemp(ii,1:length(temptext))=temptext;
    end
else
for ii=1:length(Valid)
    temptext=['al' num2str(i1(ii)) num2str(InterstepL/2) ' ' num2str(stepL-InterstepL/2) 'al' num2str(i2(ii)) num2str(InterstepL/2) ' ' num2str(stepL-InterstepL/2) 'color=Community' num2str(Candi(i))];
    ShowTemp(ii,1:length(temptext))=temptext;
end
end
clear i1 i2
Show=[Show;ShowTemp];
clear ShowTemp
Show(1,:)=[];

SigHeat=SigP;
SigHeat(SigP~=Candi(i))=0;
SigHeatH=sum(SigHeat);
fileIDH = fopen([PathData 'circosHeat' num2str(Candi(i)) '.txt'],'w');
ShowCHeat(1,:)='                                              ';
for ii=1:length(LobleID)
    temptext=['al' num2str(i) ' 0 4 '  num2str(SigHeatH(ii)) ' fill_color=' EdgeGroupPlot{i}];
    ShowCheat(ii,1:length(temptext))=temptext;
end
for ii=1:size(LobleID)
    fprintf(fileIDH,'%s\r\n',deblank(ShowCheat(ii,:)));
end
fclose(fileIDH);
clear ShowCheat




    end

fileID = fopen([PathData 'circosLink.txt'],'w');


for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
%%%%%%%%%%%%%%%%%%%%%%%%plot Link by Community





    
    
end




