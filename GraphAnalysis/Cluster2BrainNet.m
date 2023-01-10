function EdgeMatrix=Cluster2BrainNet(Path,File,EdgeIndex,Cluster,write2BrainNet)

%%%%


NodeNum=116;
load('Z:\Users\LuZhang\AAL\AAL116_BrainNetView.mat');
load('Z:\Users\LuZhang\AAL\AAL.mat');



EdgeNum=NodeNum*(NodeNum-1)/2;
EdgeEdgeNum=EdgeNum*(EdgeNum-1)/2;

EdgeRow=zeros(NodeNum,NodeNum);
EdgeCol=zeros(NodeNum,NodeNum);


for ii=1:NodeNum
    EdgeRow(ii,:)=ii;
    EdgeCol(:,ii)=ii;
end
EdgeRow=triu(EdgeRow,1)';
EdgeRow=EdgeRow(:);
EdgeRow(EdgeRow==0)=[];

EdgeCol=triu(EdgeCol,1)';
EdgeCol=EdgeCol(:);
EdgeCol(EdgeCol==0)=[];


temp1=EdgeRow(EdgeIndex);
temp2=EdgeCol(EdgeIndex);

EdgeMatrix=zeros(NodeNum,NodeNum);
for i=1:length(temp1)
    EdgeMatrix(temp1(i),temp2(i))=Cluster(i);
end

EdgeMatrix=abs(-EdgeMatrix'+EdgeMatrix);

if write2BrainNet==0
   return; 
end

SCellNode=table2array(NodeAAL116(:,1:5));
SCellNodeName=table2array(NodeAAL116(:,6));
SCellNode(:,5)=0;
SCellNode(:,4)=1;
SCellNode(:,5)=sum(abs(EdgeMatrix))';



% writetable(cell2table(SCellNode),'Z:\Users\LuZhang\Sch\Chengwei4Ddata\Meta\SigNode.txt')


fid = fopen([Path '\' File '.NODE'],'w');
for i = 1:size(EdgeMatrix,1)
    fprintf(fid,'%.0f\t%.0f\t%.0f\t',SCellNode(i,1:3));
    fprintf(fid,'%.0f\t%.0f\t',SCellNode(i,4),SCellNode(i,5));
    fprintf(fid,'%s\n',SCellNodeName{i});
end
fclose(fid);

fid = fopen([Path '\' File '.EDGE'],'w');
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

