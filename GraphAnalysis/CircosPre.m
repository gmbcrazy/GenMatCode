function CircosPre(EdgeMetaNeed,PathData,EdgeCommunity)



sig=zeros(116,116);
load('D:\FMRI\AAL\LuAAL.mat')
[LobleID,Index]=sort(LobleID);
LobleName=LobleName(Index);
sig=sig(Index,Index);
RegionName=RegionName(Index);
% EdgeCommunity=EdgeCommunity(Index);
% i1=intersect(EdgeMetaNeed(:,1),Index)

for i=1:size(EdgeMetaNeed,1)
i1(i)=find(Index==EdgeMetaNeed(i,1));
i2(i)=find(Index==EdgeMetaNeed(i,2));
end

for i=1:size(EdgeMetaNeed,1)
    sig(i1(i),i2(i))=1;
end
sig=sig+sig';

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



sigP=sig;

%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link
% [i1,i2,~]=find(sigP>0);
% Valid=find([i2-i1]>0);
% i1=i1(Valid);
% i2=i2(Valid);
clear Show
Show(1,:)='                                              ';

for ii=1:length(i1)
    temptext=['al' num2str(i1(ii)) ' 2 3 ' 'al' num2str(i2(ii)) ' 2 3 color=Community' showNum(EdgeCommunity(ii),0)];
    Show(ii,1:length(temptext))=temptext;
end

fileID = fopen([PathData 'circosLink.txt'],'w');


for i=1:length(Show(:,1))
    fprintf(fileID,'%s\r\n',deblank(Show(i,:)));
end
fclose(fileID);

%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link




