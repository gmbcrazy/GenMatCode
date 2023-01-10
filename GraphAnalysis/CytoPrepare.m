function [ShowEdge, ShowNode]=CytoPrepare(Data,P,varargin)

% % Data='D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat';
% % load('D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat');
load(Data);
sig=sign(Z_wei);
pth=P.pth;
sig(pval_meta>pth)=0;

if nargin>2
    savepath=varargin{1};
end
% % % [numric,txt,raw]=xlsread('D:\FMRI\AAL\AALDescri.xlsx',[1 4 5]);
% % % RegionName=raw(:,1);
% % % LobleID=numric(:,3);
% % % LobleName=raw(:,4);
load('Z:\Users\LuZhang\AAL\LuAAL.mat')
[LobleID,Index]=sort(LobleID);
LobleName=LobleName(Index);
RegionName=RegionName(Index);
sig=sig(Index,Index);


if P.PlotAll~=1
   Index=find(nansum(abs(sig))>0);
   sig=sig(Index,Index);
   LobleName=LobleName(Index);
   RegionName=RegionName(Index);
   LobleID=LobleID(Index);
end
sigP=sig;
sigP(sigP<=0)=0;
sigN=sig;
sigN(sigN>=0)=0;

%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link
[i1,i2,~]=find(sigP>0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
for ii=1:length(Valid)
    ShowEdge{ii,1}=RegionName{i1(ii)};
    ShowEdge{ii,2}=RegionName{i2(ii)};
    ShowEdge{ii,3}=2;

end
%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link


%%%%%%%%%%%%%%%%%%%%%%%%%plot negative Link
[i1,i2,~]=find(sigN<0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
for ii=1:length(Valid)
    ShowEdge{end+1,1}=RegionName{i1(ii)};
    ShowEdge{end,2}=RegionName{i2(ii)};
    ShowEdge{end,3}=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%plot negative Link

index=find(nansum(abs(sig))~=0);
for ii=1:length(index)
ShowNode{ii,1}=[RegionName{index(ii)}];
ShowNode{ii,2}=LobleID(index(ii));
end

if nargin>2
% fileID = fopen([savepath 'cytoNode' 'Node.txt'],'w');
xlswrite([savepath 'cytoNode.xls'],ShowNode);
xlswrite([savepath 'cytoEdge.xls'],ShowEdge);
end
