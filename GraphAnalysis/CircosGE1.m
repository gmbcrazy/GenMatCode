function CircosGE1(Data,PathData,varargin)

%%%%%Creat node, links, histogram, heatmap files for circos plot.
%%%%%Lu Zhang 2019 gatech


%%%%%Data is the n*n adjcent matrix of n nodes
%%%%%PathData is the path/file name where output file is saved
%%%%%varargin{1} LobleID is 1*n cell with node names defined
%%%%%varargin{2} LobleName defines the names of lobe
%%%%%varargin{3} RegionName defines the names of nodes
%%%%%varargin{4} PlotAll=1 then creat circos file for all nodes; otherwise only nodes
%%%%%with >1 links were ploted


sig=Data;

n=size(sig,1);
switch nargin
    case 2
    LobleID=zeros(1,n)+1;
    RegionName=[];
    LobleName=[];
    PlotAll=1;
    EdgeGroupPlotP=0;
    case 3
     LobleID=varargin{1};
     LobleName=[];
     RegionName=[];
     EdgeGroupPlotP=0;
     PlotAll=1;
    case 4
     LobleID=varargin{1};
     LobleName=varargin{2};
     RegionName=[];
     EdgeGroupPlotP=0;
    PlotAll=1;
    case 5
     LobleID=varargin{1};
     LobleName=varargin{2};
     RegionName=varargin{3};
     PlotAll=1;
     EdgeGroupPlotP=0;
    case 6
     LobleID=varargin{1};
     LobleName=varargin{2};
     RegionName=varargin{3};
     PlotAll=varargin{4};
     EdgeGroupPlotP=0;
    case 7
     LobleID=varargin{1};
     LobleName=varargin{2};
     RegionName=varargin{3};
     PlotAll=varargin{4};
     EdgeGroupPlot=varargin{5};
 
     if iscell(EdgeGroupPlot)
         EdgeGroupPlotP=1;
     else
         EdgeGroupPlotP=EdgeGroupPlot;
     end
end


[LobleID,Index]=sort(LobleID);
LobleName=LobleName(Index);
sig=sig(Index,Index);
RegionName=RegionName(Index);

if PlotAll~=1
   Index=find(nansum(abs(sig))>0);
   sig=sig(Index,Index);
   LobleName=LobleName(Index);
   RegionName=RegionName(Index);
   LobleID=LobleID(Index);
end


fileID = fopen([PathData 'circosNode.txt'],'w');
Show(1,:)='                                              ';
[UL,UI]=unique(LobleID);
ULN=LobleName(UI);
stepL=10;
InterstepL=2;

LinkWidth=stepL-2;
for i=1:length(UL)
    LobleNum(i)=length(find(LobleID==UL(i)));
    temptext=['chr - al' num2str(i) ' ' num2str(ULN{i}) ' 0 '  num2str(LobleNum(i)*stepL) ' lob' num2str(UL(i))];
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(UL)
    for ii=1:(LobleNum(i))
        temptext=['band al' num2str(i) ' p' num2str(ii) ' p' num2str(ii) ' ' num2str((ii-1)*stepL) ' ' num2str(ii*stepL) ' lob' num2str(UL(i))]; 
        Show(end+1,1:length(temptext))=temptext;

    end
end
for i=1:length(Show(:,1))
    
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);


IDTemp=[];
LobTemp=[];
for i=1:length(UL)
    IDTemp=[IDTemp;[1:(LobleNum(i))]'];
    LobTemp=[LobTemp;zeros(LobleNum(i),1)+UL(i)];
end
IDTemp=IDTemp*stepL;
clear Show
HistNum=nansum(abs(sig));
fileID = fopen([PathData 'circosHist.txt'],'w');

Show(1,:)='                                              ';
for i=1:length(LobleID)
    temptext=['al' num2str(LobTemp(i)) ' ' num2str(IDTemp(i)-stepL+1) ' ' num2str(IDTemp(i)-1) ' ' num2str(HistNum(i)) ' fill_color=lob' num2str(LobleID(i))];
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
    temptext=['al' num2str(LobTemp(i)) ' ' num2str(IDTemp(i)-stepL) ' ' num2str(IDTemp(i)) ' ' RegionName{i}];
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

maxC=max(max(abs(sig)));
IntC=maxC/8;

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
    W1=IDTemp(i1(ii))-stepL+InterstepL/2;
    W2=W1+max(ceil(abs(sigP(i1(ii),i2(ii)))/maxC*LinkWidth),1);
    
    W3=IDTemp(i2(ii))-stepL+InterstepL/2;
    W4=W3+max(ceil(abs(sigP(i1(ii),i2(ii)))/maxC*LinkWidth),1);

%     temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(IDTemp(i1(ii))-stepL/2-2) ' ' num2str(IDTemp(i1(ii))-stepL/2+2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(IDTemp(i2(ii))-stepL/2-2) ' ' num2str(IDTemp(i2(ii))-stepL/2+2) ' color=PosLink'];
    temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(W3) ' ' num2str(W4) ' color=Pos1' num2str(tempC)];
    Show1(ii,1:length(temptext))=temptext;
end

[i1,i2,~]=find(sigN<0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
clear Show
Show2(1,:)='                                              ';


for ii=1:length(Valid)
    tempC=ceil(sigN(i1(ii),i2(ii))/IntC);
    tempC=max(tempC,1);

    W1=IDTemp(i1(ii))-stepL+InterstepL/2;
    W2=W1+ceil(abs(sigN(i1(ii),i2(ii)))/maxC*LinkWidth);
    
    W3=IDTemp(i2(ii))-stepL+InterstepL/2;
    W4=W3+ceil(abs(sigN(i1(ii),i2(ii)))/maxC*LinkWidth);
    temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(W3) ' ' num2str(W4) ' color=Neg1' num2str(tempC)];

%     temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(IDTemp(i1(ii))-stepL/2) ' ' num2str(IDTemp(i1(ii))-stepL/2+4) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(IDTemp(i2(ii))-stepL/2) ' ' num2str(IDTemp(i2(ii))-stepL/2+4) ' color=NegLink'];
    Show2(ii,1:length(temptext))=temptext;
end

Show=[Show1;Show2];
fileID = fopen([PathData 'circosLink.txt'],'w');


for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);


sigP=sig;
sigP(sigP<=0)=0;
sigN=sig;
sigN(sigN>=0)=0;
sigN=abs(sigN);

%%%%%%%%%%%%%heat map of positive links
SigPHeat=sum(sigP);
fileID = fopen([PathData 'circosHeatP.txt'],'w');
ShowCHeat(1,:)='                                              ';
for ii=1:length(LobleID)
    tempC=ceil(SigPHeat(ii)/IntC);
    tempC=max(tempC,1);

    temptext=['al' num2str(LobTemp(ii)) ' ' num2str(IDTemp(ii)-stepL+InterstepL/2) ' ' num2str(IDTemp(ii)-InterstepL/2) ' ' num2str(SigPHeat(ii)) ' fill_color=Pos1' num2str(tempC)];
    ShowCheat(ii,1:length(temptext))=temptext;
end
for ii=1:length(LobleID)
    fprintf(fileID,'%s\r\n',deblank(ShowCheat(ii,:)));
end
fclose(fileID);
clear ShowCheat
%%%%%%%%%%%%%heat map of positive links

%%%%%%%%%%%%%heat map of negative links
SigNHeat=sum(sigN);
fileID = fopen([PathData 'circosHeatN.txt'],'w');
ShowCHeat(1,:)='                                              ';
for ii=1:length(LobleID)
    tempC=ceil(SigNHeat(ii)/IntC);
    tempC=max(tempC,1);

    temptext=['al' num2str(LobTemp(ii)) ' ' num2str(IDTemp(ii)-stepL+InterstepL/2) ' ' num2str(IDTemp(ii)-InterstepL/2) ' ' num2str(SigNHeat(ii)) ' fill_color=Neg1' num2str(tempC)];
    ShowCheat(ii,1:length(temptext))=temptext;
end
for ii=1:length(LobleID)
    fprintf(fileID,'%s\r\n',deblank(ShowCheat(ii,:)));
end
fclose(fileID);
clear ShowCheat
%%%%%%%%%%%%%heat map of negative links







