function [ShowEdge, ShowNode]=Adj2Cyto(adj,NodeNames,varargin)

% % Data='D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat';
% % load('D:\FMRI\AALMeta\TaiwanLinRemoveMetaEarlyPhase\AALall\Onset0.0-1200.0\site5metaResult.mat');

if nargin==3
    savepath=varargin{1};
    NodeType=ones(size(adj,1),1);
elseif nargin==4
    savepath=varargin{1};
    NodeType=varargin{2};
else
    NodeType=ones(size(adj,1),1);
end
% % % [numric,txt,raw]=xlsread('D:\FMRI\AAL\AALDescri.xlsx',[1 4 5]);
% % % RegionName=raw(:,1);
% % % LobleID=numric(:,3);
% % % LobleName=raw(:,4);

%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link
[i1,i2,~]=find(adj>0);

i1=i1;
i2=i2;
% % % Valid=find([i2-i1]>0);
% % % i1=i1(Valid);
% % % i2=i2(Valid);
    ShowEdge{1,1}='source';
    ShowEdge{1,2}='target';
    ShowEdge{1,3}='Fre';

for ii=1:length(i1)

    ShowEdge{ii+1,1}=NodeNames{i1(ii)};
    ShowEdge{ii+1,2}=NodeNames{i2(ii)};
    ShowEdge{ii+1,3}=adj(i1(ii),i2(ii));
end
%%%%%%%%%%%%%%%%%%%%%%%%%plot positive Link


    ShowNode{1,1}='Node';
    ShowNode{1,2}='NodeType';


% index=find(nansum(abs(adj))~=0);
for ii=1:length(NodeNames)
ShowNode{ii+1,1}=[NodeNames{ii}];
ShowNode{ii+1,2}=NodeType(ii);
end

if nargin>2
% fileID = fopen([savepath 'cytoNode' 'Node.txt'],'w');
xlswrite([savepath 'cytoNode.xls'],ShowNode);
xlswrite([savepath 'cytoEdge.xls'],ShowEdge);
end
