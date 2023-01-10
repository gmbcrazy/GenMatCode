function CircosAALYeoHist(Data,PathData,Pth,MCcorrection,PlotAll,varargin)

YeoM=0;
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


   'AAL2 120 region is used';
   load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\LuAAL120OldNewName.mat')
   EdgeGroupPlot=0;
   
   
      if nargin==5
         a='AAL'
         CCLim=[min(min(abs(Data))) max(max(abs(Data)))];
      elseif nargin==6
         a=varargin{1};
         CCLim=[min(min(abs(Data))) max(max(abs(Data)))];

      elseif nargin==7
         a=varargin{1};
         CCLim=varargin{2};
      else
      end

   a=varargin{1};
   b=strfind(a,'Yeo');
   if b
       YeoM=1;
       Yeo2011(Yeo2011==-1)=0;
      LobleID=YeoLu;
      LobleNameT{1}='Visual';
      LobleNameT{2}='Somatomotor';
      LobleNameT{3}='D-Att';
      LobleNameT{4}='V-Att';
      LobleNameT{5}='Limbic';
      LobleNameT{6}='Frontoparietal';
      LobleNameT{7}='Default';
      LobleNameT{8}='Subcortical';
      LobleNameT{9}='Cerebellar';
      for i=1:length(LobleName)
          LobleName{i}=LobleNameT{YeoLu(i)};
      end
   end
   

[LobleID,Index]=sort(LobleID);
Yeo2011=Yeo2011(Index,:);
Yeo2011Rat=round(Yeo2011Rat(Index,:)*100);

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
[UL,UI]=unique(LobleID);
ULN=LobleName(UI);
step=20;
LinkWidth=12;
for i=1:length(UL)
    LobleNum(i)=length(find(LobleID==UL(i)));
    if YeoM==1   
       temptext=['chr - al' num2str(i) ' ' num2str(ULN{i}) ' 0 '  num2str(LobleNum(i)*step) ' Yeo' num2str(UL(i))];
    else
       temptext=['chr - al' num2str(i) ' ' num2str(ULN{i}) ' 0 '  num2str(LobleNum(i)*step) ' lob' num2str(UL(i))];

    end
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(UL)
    for ii=1:(LobleNum(i))
        if YeoM==1
           temptext=['band al' num2str(i) ' p' num2str(ii) ' p' num2str(ii) ' ' num2str((ii-1)*step) ' ' num2str(ii*step) ' Yeo' num2str(UL(i))]; 
        else
        temptext=['band al' num2str(i) ' p' num2str(ii) ' p' num2str(ii) ' ' num2str((ii-1)*step) ' ' num2str(ii*step) ' lob' num2str(UL(i))]; 
        end
        Show(end+1,1:length(temptext))=temptext;

    end
end
for i=1:length(Show(:,1))
    
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);


%%%%%%%%%%%%%%%%%%%%%%%%%
% if YeoM==1
% 
% for j=1:size(Yeo2011)
% fileID = fopen([PathData 'YeoNode' num2str(j) '.txt'],'w');
% Show(1,:)='                                              ';
% [UL,UI]=unique(Yeo2011(:,j));
% ULN=LobleName(UI);
% step=20;
% LinkWidth=12;
% for i=1:length(UL)
%     LobleNum(i)=length(find(LobleID==UL(i)));
%     if YeoM==1   
%        temptext=['chr - al' num2str(i) ' ' num2str(ULN{i}) ' 0 '  num2str(LobleNum(i)*step) ' Yeo' num2str(UL(i))];
%     else
%        temptext=['chr - al' num2str(i) ' ' num2str(ULN{i}) ' 0 '  num2str(LobleNum(i)*step) ' lob' num2str(UL(i))];
% 
%     end
%     Show(i,1:length(temptext))=temptext;
% end
% for i=1:length(UL)
%     for ii=1:(LobleNum(i))
%         if YeoM==1
%            temptext=['band al' num2str(i) ' p' num2str(ii) ' p' num2str(ii) ' ' num2str((ii-1)*step) ' ' num2str(ii*step) ' Yeo' num2str(UL(i))]; 
%         else
%         temptext=['band al' num2str(i) ' p' num2str(ii) ' p' num2str(ii) ' ' num2str((ii-1)*step) ' ' num2str(ii*step) ' Yeo' num2str(UL(i))]; 
%         end
%         Show(end+1,1:length(temptext))=temptext;
% 
%     end
% end
% for i=1:length(Show(:,1))
%     
%     fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
% end
% fclose(fileID);
% 
% end
% end

%%%%%%%%%%%%%%%%%%%%%%%%%

for j=1:2

IDTemp=[];
LobTemp=[];
for i=1:length(UL)
    IDTemp=[IDTemp;[1:(LobleNum(i))]'];
    LobTemp=[LobTemp;zeros(LobleNum(i),1)+UL(i)];
end
IDTemp=IDTemp*step;
clear Show
HistNum=nansum(abs(sig));
fileID = fopen([PathData 'circosHist' num2str(j) '.txt'],'w');

Show(1,:)='                                              ';
for i=1:size(LobleID,1)
    temptext=['al' num2str(LobTemp(i)) ' ' num2str(IDTemp(i)-step+1) ' ' num2str(IDTemp(i)-1) ' ' num2str(Yeo2011Rat(i,j)) ' fill_color=Yeo' num2str(Yeo2011(i,j))];
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
clear Show
end
%%%%%%%%%%%%%%%%%%%%%%%%%
clear Show
HistNum=nansum(abs(sig));
fileID = fopen([PathData 'circosTick.txt'],'w');
Show(1,:)='                                              ';
for i=1:size(LobleID,1)
    temptext=['al' num2str(LobTemp(i)) ' ' num2str(IDTemp(i)-step) ' ' num2str(IDTemp(i)) ' ' RegionName{i}];
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
clear Show


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Highlight text
clear Show
HistNum=nansum(abs(sig));
fileID = fopen([PathData 'circosTickHL.txt'],'w');
Show(1,:)='                                              ';
ii=1;
for i=1:size(LobleID,1)
    if HistNum(i)>=1
    temptext=['al' num2str(LobTemp(i)) ' ' num2str(IDTemp(i)-step) ' ' num2str(IDTemp(i)) ' ' RegionName{i}];
    Show(ii,1:length(temptext))=temptext;
    ii=ii+1;
    end
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
clear Show
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Highlight text

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%No Highlight text
clear Show
fileID = fopen([PathData 'circosTickNoHL.txt'],'w');
Show(1,:)='                                              ';
ii=1;

for i=1:size(LobleID,1)
    if HistNum(i)<1
    temptext=['al' num2str(LobTemp(i)) ' ' num2str(IDTemp(i)-step) ' ' num2str(IDTemp(i)) ' ' RegionName{i}];
    Show(ii,1:length(temptext))=temptext;
    ii=ii+1;
    end
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
clear Show
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Highlight text


%%%%%%Within Module Link Refers to Positive; Cross Module Link Refers to
%%%%%%Negative
% % if YeoM==1
% % sig=-abs(sig);
% % for i=1:length(unique(LobleID))
% %     I1=find(LobleID==i);
% %     sig(I1,I1)=abs(sig(I1,I1));
% %     clear I1
% % end
% % end
%%%%%%Within Module Link Refers to Positive; Cross Module Link Refers to
%%%%%%Negative

sigP=sig;
sigP(sigP<=0)=0;
sigN=sig;
sigN(sigN>=0)=0;

maxC=max(max(abs(sig)));
IntC=maxC/5;

NumBinLink=10;
[~,EdgeLink]=discretize(CCLim,NumBinLink);


%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link
[i1,i2,~]=find(sigP>0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
clear Show
Show1(1,:)='                                              ';

maxSigP=nanmax(nanmax(sigP));
minSigP=nanmin(nanmin(sigP(sigP>0)));
maxSigN=nanmax(nanmax(sigN));
minSigN=nanmin(nanmin(sigN(sigN>0)));

for ii=1:length(Valid)
    LinkWeight=sigP(i1(ii),i2(ii));
    if LinkWeight<CCLim(1)
       LinkWeight=CCLim(1);
    elseif LinkWeight>CCLim(2)
       LinkWeight=CCLim(2);
    else
    end
    [tempC,~]=discretize(sigP(i1(ii),i2(ii)),EdgeLink);  %%%
     tempC=tempC-1;  %%%%%%%%%%%%tempC range from 1 to NumBinLink-1
    
    W1=IDTemp(i1(ii))-step;
    W2=W1+ceil(abs(sigP(i1(ii),i2(ii)))/maxC*LinkWidth);
    
    W3=IDTemp(i2(ii))-step;
    W4=W3+ceil(abs(sigP(i1(ii),i2(ii)))/maxC*LinkWidth);

%     temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(IDTemp(i1(ii))-step/2-2) ' ' num2str(IDTemp(i1(ii))-step/2+2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(IDTemp(i2(ii))-step/2-2) ' ' num2str(IDTemp(i2(ii))-step/2+2) ' color=PosLink'];
    if YeoM==0
    temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(W3) ' ' num2str(W4) ' color=Pos1' num2str(tempC)];
    else
    temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(W3) ' ' num2str(W4) ' color=Pos1' num2str(tempC)];
    end
    Show1(ii,1:length(temptext))=temptext;
end

[i1,i2,~]=find(sigN<0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
clear Show
Show2(1,:)='                                              ';


for ii=1:length(Valid)
    LinkWeight=sigN(i1(ii),i2(ii));
    if LinkWeight<CCLim(1)
       LinkWeight=CCLim(1);
    elseif LinkWeight>CCLim(2)
       LinkWeight=CCLim(2);
    else
    end
    [tempC,~]=discretize(sigN(i1(ii),i2(ii)),EdgeLink);  %%%
     tempC=tempC-1;  %%%%%%%%%%%%tempC range from 1 to NumBinLink-1

    W1=IDTemp(i1(ii))-step+LinkWidth/2;
    W2=W1+ceil(abs(sigN(i1(ii),i2(ii)))/maxC*LinkWidth);
    
    W3=IDTemp(i2(ii))-step+LinkWidth/2;
    W4=W3+ceil(abs(sigN(i1(ii),i2(ii)))/maxC*LinkWidth);
    if YeoM==0
    temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(W3) ' ' num2str(W4) ' color=Neg1' num2str(tempC)];
    else
    temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(W3) ' ' num2str(W4) ' color=Neg1' num2str(tempC)];
    end

%     temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(IDTemp(i1(ii))-step/2) ' ' num2str(IDTemp(i1(ii))-step/2+4) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(IDTemp(i2(ii))-step/2) ' ' num2str(IDTemp(i2(ii))-step/2+4) ' color=NegLink'];
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
for ii=1:size(LobleID)
        if YeoM==0
    temptext=['al' num2str(LobTemp(ii)) ' ' num2str(IDTemp(ii)-step+1) ' ' num2str(IDTemp(ii)-1) ' ' num2str(SigPHeat(ii)) ' fill_color=Pos'];
            else
    temptext=['al' num2str(LobTemp(ii)) ' ' num2str(IDTemp(ii)-step+1) ' ' num2str(IDTemp(ii)-1) ' ' num2str(SigPHeat(ii)) ' fill_color=Pos'];

        end
    ShowCheat(ii,1:length(temptext))=temptext;
end
for ii=1:size(LobleID)
    fprintf(fileID,'%s\r\n',deblank(ShowCheat(ii,:)));
end
fclose(fileID);
clear ShowCheat
%%%%%%%%%%%%%heat map of positive links

%%%%%%%%%%%%%heat map of negative links
SigNHeat=sum(sigN);
fileID = fopen([PathData 'circosHeatN.txt'],'w');
ShowCHeat(1,:)='                                              ';
for ii=1:size(LobleID)
     if YeoM==0
    temptext=['al' num2str(LobTemp(ii)) ' ' num2str(IDTemp(ii)-step+1) ' ' num2str(IDTemp(ii)-1) ' ' num2str(SigNHeat(ii)) ' fill_color=Pos'];
                else
    temptext=['al' num2str(LobTemp(ii)) ' ' num2str(IDTemp(ii)-step+1) ' ' num2str(IDTemp(ii)-1) ' ' num2str(SigNHeat(ii)) ' fill_color=Neg'];
     end
    ShowCheat(ii,1:length(temptext))=temptext;
end
for ii=1:size(LobleID)
    fprintf(fileID,'%s\r\n',deblank(ShowCheat(ii,:)));
end
fclose(fileID);
clear ShowCheat
%%%%%%%%%%%%%heat map of negative links





Degree=SigPHeat+SigNHeat;











