function LOOPlist=LoopsFindAALData(Data,P,num_est_loops)

% % Data='D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat';
% % load('D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat');
load(Data);
sig=sign(Z_wei);
pth=P.pth;
sig(pval_meta>pth)=0;
Index1=find(nansum(abs(sig))==1);
sig(Index1,:)=0;
sig(:,Index1)=0;

% if nargin>2
%    num_est_loops=varargin{1};
% else
%     num_est_loops=1000;
% end
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
ShowEdge=[];
for ii=1:length(Valid)
    ShowEdge(ii,:)=[i1(ii) i2(ii)];
    EdgeC(ii)=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link


%%%%%%%%%%%%%%%%%%%%%%%%%plot negative Link
[i1,i2,~]=find(sigN<0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
for ii=1:length(Valid)
    ShowEdge(end+1,:)=[i1(ii) i2(ii)];
    EdgeC(end+1)=-1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%plot negative Link

net = edge_list2net(ShowEdge);
 LOOPLIST=LoopsFind(net,num_est_loops);




