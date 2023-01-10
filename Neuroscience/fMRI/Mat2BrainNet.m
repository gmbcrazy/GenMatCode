% load( PathFilemetaResultPvalue.mat')
function Mat2BrainNet(PathFile,File,Adj,varargin)
load('D:\FMRI\AAL\AAL116_BrainNetView.mat');
% load('D:\OneDrive\PaperUse\Fig4EdgeCorr\CommunityPatNor.mat');
load('D:\FMRI\AAL\LuAAL.mat');
% EdgeMeta=edgeFromMetaResult('D:\OneDrive\PaperUse\Fig_sigEdge\site5metaResult.mat',0.01,'FDR');
% load('D:\OneDrive\PaperUse\SFigPCACluster\4haoji\All6PCACluster.mat');
if nargin==4
   PlotB=1;
   StyleF=varargin{1};
else
    PlotB=0;
end
% EdgeList=EdgeExtract('D:\OneDrive\PaperUse\Fig_sigEdge\site5metaResult.mat',0.01,'fdr');
NodeNum=length(RegionName);
% EdgeMatrix=Adj;
PathFile='D:\OneDrive\PaperUse\SFigPCACluster\4haoji\';
% temp2=zeros(116*115/2,1);
% temp2(EdgeList)=1;
% [Adj,EdgeMeta]=Edge2NodeIndex(NodeNum,temp2);
% 
% EdgeList=EdgeExtract(1-Adj,0.01,'fdr');


% IndexList=EdgeNode2EdgeListIndex(EdgeMeta,NodeNum);
% sum(abs(a1-EdgeList))

% i=1;
% EdgeAll(IndexList)'
% temp2=zeros(NodeNum*(NodeNum-1)/2,1);
% temp2(IndexList)=1;
% 
% Adj=Edge2NodeIndex(NodeNum,temp2);
% imagesc(Adj)
% [b1,b2]=find(Adj>0);
% Va=find((b2-b1)>0);
% [b1(Va) b2(Va)]-EdgeMeta


EdgeMatrix=Adj;
% EdgeMatrix=EdgeMatrix+2;
% EdgeMatrix(EdgeMatrix==2)=0;
NodeIndex=find(sum(abs(EdgeMatrix))>0);


% EdgeMatrix=EdgeMatrix(NodeIndex,NodeIndex);

% SCellNode=CellNode(NodeIndex,:);
% writetable(cell2table(SCellNode), PathFileSigNode.txt')
SCellNode=table2array(NodeAAL116(:,1:5));
SCellNodeName=table2array(NodeAAL116(:,6));
SCellNode(:,5)=0;
SCellNode(:,4)=LobleID(:);
SCellNode(:,5)=sum(abs(EdgeMatrix))';



% writetable(cell2table(SCellNode), PathFileSigNode.txt')


fid = fopen([PathFile File 'Node.NODE'],'w');
for i = 1:size(EdgeMatrix,1)
    fprintf(fid,'%.0f\t%.0f\t%.0f\t',SCellNode(i,1:3));
    fprintf(fid,'%.0f\t%.0f\t',SCellNode(i,4),SCellNode(i,5));
    fprintf(fid,'%s\n',SCellNodeName{i});
end
fclose(fid);

fid = fopen([PathFile File 'Edge.EDGE'],'w');
for i = 1:size(EdgeMatrix,1)
%     fprintf(fid,['%' num2str(size(EdgeMatrix,1)) 'd'],EdgeMatrix(i,:));
    fprintf(fid,['% d'],EdgeMatrix(i,:));

% % %         for j=1:size(EdgeMatrix,1)
% % %          fprintf(fid,'%d',EdgeMatrix(i,j));
% % %  
% % %     end
% % % 
% % %     for j=1:size(EdgeMatrix,1)
% % %          fprintf(fid,'%d',EdgeMatrix(i,j));
% % %  
% % %     end
   fprintf(fid,'\n');
end
fclose(fid);

if PlotB==1
papersizePX=[0 0 15 10];
BrainNet_MapCfg(['D:\matlab plug in\FMRI\BrainNetViewer_20150414\Data\SurfTemplate\BrainMesh_Ch2withCerebellum.nv'],[PathFile 'Node.node'],[PathFile 'Edge.edge'],StyleF);
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));
saveas(gcf,[PathFile 'SigAlteredConn'],'epsc'); 
saveas(gcf,[PathFile 'SigAlteredConn'],'jpg'); 

end







