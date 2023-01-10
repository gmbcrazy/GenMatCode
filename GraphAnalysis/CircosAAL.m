function CircosAAL(Data,PathData,Pth,MCcorrection,PlotAll,varargin)

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

if nargin==6
   'AAL2 120 region is used';
   load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\LuAAL120OldNewName.mat')
   EdgeGroupPlot=0;
%    RegionName=RegionNameNew;
   a=varargin{1};
   b=strfind(a,'AAL');
   if b
      IndexNeed=str2num(a((b+3):end));
      if IndexNeed<120
         load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\LuAAL120OldNameNoCere.mat') 
      end

   end
     b=strfind(a,'Yeo');
   if b
       YeoM=1;
      LobleID=Yeo2011(:,1);
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
          LobleName{i}=LobleNameT{Yeo2011(i,1)};
      end
   end
elseif nargin==7
   load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\LuAAL120OldNewName.mat')
%       RegionName=RegionNameNew;

   EdgeGroupPlot=varargin{2};
   
    if b
      IndexNeed=str2num(a((b+3):end));
      if IndexNeed<120
         load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\LuAAL120OldNameNoCere.mat') 
      end

   end
else
   'AAL2 116 region is used';
   load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\LuAAL.mat')
   EdgeGroupPlot=0;


end

[LobleID,Index]=sort(LobleID);
Yeo2011=Yeo2011(Index,:);
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



IDTemp=[];
LobTemp=[];
for i=1:length(UL)
    IDTemp=[IDTemp;[1:(LobleNum(i))]'];
    LobTemp=[LobTemp;zeros(LobleNum(i),1)+UL(i)];
end
IDTemp=IDTemp*step;
clear Show
HistNum=nansum(abs(sig));
fileID = fopen([PathData 'circosHist.txt'],'w');
Show(1,:)='                                              ';
for i=1:size(LobleID,1)
    temptext=['al' num2str(LobTemp(i)) ' ' num2str(IDTemp(i)-step+1) ' ' num2str(IDTemp(i)-1) ' ' num2str(HistNum(i)) ' fill_color=lob' num2str(LobleID(i))];
    Show(i,1:length(temptext))=temptext;
end
for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);
clear Show


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


%%%%%%Within Module Link Refers to Positive; Cross Module Link Refers to
%%%%%%Negative
if YeoM==1
sig=-abs(sig);
for i=1:length(unique(LobleID))
    I1=find(LobleID==i);
    sig(I1,I1)=abs(sig(I1,I1));
    clear I1
end
end
%%%%%%Within Module Link Refers to Positive; Cross Module Link Refers to
%%%%%%Negative

if  EdgeGroupPlot==0
sigP=sig;
sigP(sigP<=0)=0;
sigN=sig;
sigN(sigN>=0)=0;

maxC=max(max(abs(sig)));
IntC=maxC/5;

%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link
[i1,i2,~]=find(sigP>0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
clear Show
Show1(1,:)='                                              ';

for ii=1:length(Valid)
    tempC=5-ceil(sigP(i1(ii),i2(ii))/IntC);
    tempC=min(tempC,4);
    W1=IDTemp(i1(ii))-step;
    W2=W1+ceil(abs(sigP(i1(ii),i2(ii)))/maxC*LinkWidth);
    
    W3=IDTemp(i2(ii))-step;
    W4=W3+ceil(abs(sigP(i1(ii),i2(ii)))/maxC*LinkWidth);

%     temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(IDTemp(i1(ii))-step/2-2) ' ' num2str(IDTemp(i1(ii))-step/2+2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(IDTemp(i2(ii))-step/2-2) ' ' num2str(IDTemp(i2(ii))-step/2+2) ' color=PosLink'];
    if YeoM==0
    temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(W3) ' ' num2str(W4) ' color=PosLink_a' num2str(tempC)];
    else
    temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(W3) ' ' num2str(W4) ' color=IntraModuleLink'];
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
    tempC=5-ceil(abs(sigN(i1(ii),i2(ii))/IntC));
    tempC=min(tempC,4);

    W1=IDTemp(i1(ii))-step+LinkWidth/2;
    W2=W1+ceil(abs(sigN(i1(ii),i2(ii)))/maxC*LinkWidth);
    
    W3=IDTemp(i2(ii))-step+LinkWidth/2;
    W4=W3+ceil(abs(sigN(i1(ii),i2(ii)))/maxC*LinkWidth);
    if YeoM==0
    temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(W3) ' ' num2str(W4) ' color=NegLink_a' num2str(tempC)];
    else
    temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(W1) ' ' num2str(W2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(W3) ' ' num2str(W4) ' color=InterModuleLink'];
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
    temptext=['al' num2str(LobTemp(ii)) ' ' num2str(IDTemp(ii)-step+1) ' ' num2str(IDTemp(ii)-1) ' ' num2str(SigPHeat(ii)) ' fill_color=Intra'];

        end
    ShowCheat(ii,1:length(temptext))=temptext;
end
for ii=1:size(LobleID)
    fprintf(fileID,'%s\r\n',deblank(ShowCheat(ii,:)));
end
fclose(fileID);
clear ShowCheat
%%%%%%%%%%%%%heat map of positive links

%%%%%%%%%%%%%heat map of positive links
SigNHeat=sum(sigN);
fileID = fopen([PathData 'circosHeatN.txt'],'w');
ShowCHeat(1,:)='                                              ';
for ii=1:size(LobleID)
     if YeoM==0
    temptext=['al' num2str(LobTemp(ii)) ' ' num2str(IDTemp(ii)-step+1) ' ' num2str(IDTemp(ii)-1) ' ' num2str(SigNHeat(ii)) ' fill_color=Pos'];
                else
    temptext=['al' num2str(LobTemp(ii)) ' ' num2str(IDTemp(ii)-step+1) ' ' num2str(IDTemp(ii)-1) ' ' num2str(SigNHeat(ii)) ' fill_color=Inter'];
     end
    ShowCheat(ii,1:length(temptext))=temptext;
end
for ii=1:size(LobleID)
    fprintf(fileID,'%s\r\n',deblank(ShowCheat(ii,:)));
end
fclose(fileID);
clear ShowCheat
%%%%%%%%%%%%%heat map of positive links



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
    temptext=['al' num2str(LobTemp(i1(ii))) ' ' num2str(IDTemp(i1(ii))-step/2-2) ' ' num2str(IDTemp(i1(ii))-step/2+2) ' al' num2str(LobTemp(i2(ii))) ' ' num2str(IDTemp(i2(ii))-step/2-2) ' ' num2str(IDTemp(i2(ii))-step/2+2) ' color=Com' num2str(i) '9'];
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

    temptext=['al' num2str(LobTemp(ii)) ' ' num2str(IDTemp(ii)-step+1) ' ' num2str(IDTemp(ii)-1) ' ' num2str(SigPHist(ii)) ' fill_color=Com' num2str(i)];
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

    




