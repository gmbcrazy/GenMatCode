function CircosGE(Data,PathData,varargin)

%%%%%Creat node, links, histogram, heatmap files for circos plot.
%%%%%Lu Zhang 2016


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


fileID = fopen([PathData 'circosNode.txt'],'w');
Show(1,:)='                                              ';
for i=1:length(LobleID)
    temptext=['chr - al' num2str(i) ' ' RegionName{i} ' 0 4 LUgroup' num2str(LobleID(i))];
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
% %     temptext=['al' num2str(LobTemp(i)) ' ' num2str(IDTemp(i)-step) ' ' num2str(IDTemp(i)) ' ' RegionName{i}];
% %     Show(i,1:length(temptext))=temptext;
% % end
% % for i=1:length(Show(:,1))
% %     fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
% % end
% % fclose(fileID);
% % clear Show


clear Show
HistNum=nansum(abs(sig));
fileID = fopen([PathData 'circosHist.txt'],'w');
Show(1,:)='                                              ';
for i=1:length(LobleID)
    temptext=['al' num2str(i) ' 0 4 ' num2str(HistNum(i)) ' fill_color=LUgroup' num2str(LobleID(i))];
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
clear Show



sigP=sig;
sigP(sigP<=0)=0;
sigN=sig;
sigN(sigN>=0)=0;

if EdgeGroupPlotP==0
%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link
[i1,i2,~]=find(sigP>0);
Valid=find([i2-i1]>=0);
i1=i1(Valid);
i2=i2(Valid);
clear Show
Show1(1,:)='                                              ';

for ii=1:length(Valid)
    temptext=['al' num2str(i1(ii)) ' 2 3 ' 'al' num2str(i2(ii)) ' 2 3 ' 'color=PosLink'];
    Show1(ii,1:length(temptext))=temptext;
end

[i1,i2,~]=find(sigN<0);
Valid=find([i2-i1]>=0);
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
    temptext=['al' num2str(i1(ii)) ' 2 3 ' 'al' num2str(i2(ii)) ' 2 3 ' 'color=' EdgeGroupPlot{i}];
    ShowTemp(ii,1:length(temptext))=temptext;
    end
else
for ii=1:length(Valid)
    temptext=['al' num2str(i1(ii)) ' 2 3 ' 'al' num2str(i2(ii)) ' 2 3 ' 'color=Community' num2str(Candi(i))];
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




