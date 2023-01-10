function [ShowEdge]=AlteredEdgeInfo(Data,P,varargin)

% % Data='D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat';
% % load('D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat');
load(Data);
RegionList=1:116;
sig=sign(Z_wei);
if isfield(P,'correction')
  switch P.correction
      case 'fdr'
          pth=Thfdr_Pmatrix(pval_meta,P.pth)+0.00000001;
      case 'bf'
          l=size(sig,1);
          pth=P.pth/l/(l-1)*2;
  end
else
  pth=P.pth;
end
sig(pval_meta>pth)=0;

if nargin>2
    savepath=varargin{1};
end
% % % [numric,txt,raw]=xlsread('D:\FMRI\AAL\AALDescri.xlsx',[1 4 5]);
% % % RegionName=raw(:,1);
% % % LobleID=numric(:,3);
% % % LobleName=raw(:,4);
load('Z:\Users\LuZhang\AAL\LuAAL.mat')
% [LobleID,Index]=sort(LobleID);
% RegionID=RegionList(Index);
% LobleName=LobleName(Index);
% RegionName=RegionName(Index);
% sig=sig(Index,Index);
% Z_wei=Z_wei(Index,Index);
% pval_meta=pval_meta(Index,Index);
% Pvalue=Pvalue(Index,Index,:);

%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link
[i1,i2,~]=find(abs(sig)>0);
Valid=find([i2-i1]>0);
i1=i1(Valid);
i2=i2(Valid);
for ii=1:length(Valid)
    ShowEdge{ii,1}=RegionName{i1(ii)};
    ShowEdge{ii,2}=RegionName{i2(ii)};
    ShowEdge{ii,3}=pval_meta(i1(ii),i2(ii));

    ShowEdge{ii,4}=LobleName{i1(ii)};
    ShowEdge{ii,5}=LobleName{i2(ii)};
    
    ShowEdge{ii,6}=Z_wei(i1(ii),i2(ii));
    ShowEdge{ii,7}=Z_weiNor(i1(ii),i2(ii));
    ShowEdge{ii,8}=Z_weiPat(i1(ii),i2(ii));

    ll=size(Pvalue,3);
    for j=1:ll
        ShowEdge{ii,8+j}=CPDiffAll(i1(ii),i2(ii),j); 
    end
    ShowEdge{ii,8+ll+1}=RegionList(i1(ii));
    ShowEdge{ii,8+ll+2}=RegionList(i2(ii));
    ShowEdge{ii,8+ll+3}=p_hete(i1(ii),i2(ii));

end
%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link



if nargin>2
% fileID = fopen([savepath 'cytoNode' 'Node.txt'],'w');
xlswrite([savepath 'AlteredInfo.xls'],ShowEdge);
end
