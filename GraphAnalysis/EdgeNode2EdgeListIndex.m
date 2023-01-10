function IndexList=EdgeNode2EdgeListIndex(EdgeNode,NodeNum)
%%%%%%%given nodes of edge EdgeNode,IndexList is the index in edge list
adj=zeros(NodeNum,NodeNum)-1;
for i=1:size(EdgeNode,1)
    adj(EdgeNode(i,1),EdgeNode(i,2))=2;
end
adj=adj+adj';

adj=tril(adj,-1);
adj=adj(:);

adj(adj==0)=[];
IndexList=find(adj==1);

