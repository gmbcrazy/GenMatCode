function EdgeBrainLuML(NodeCoord,EdgeList,varargin)

if nargin==3
   ColorP=varargin{1};
   if size(ColorP,1)==1
      ColorP=repmat(ColorP,size(EdgeList,1),1); 
   end
else
   ColorP=repmat([0.9 0.1 0.1],size(EdgeList,1),1); 
   if isempty(EdgeList)
      return
   end
   IndexN=find(EdgeList(:,3)<0);
   if ~isempty(IndexN)
   for i=1:length(IndexN)
       ColorP(IndexN(i),:)=[0.1 0.1 0.9];
   end
   end
end



if size(NodeCoord,2)==3
   NodeCoord=[NodeCoord NodeCoord]; 
end

if size(ColorP,1)==1
   ColorP=repmat(ColorP,size(EdgeList,1),1);
end


N1=NodeCoord(EdgeList(:,1),1:3);
N2=NodeCoord(EdgeList(:,2),4:6);


for i=1:size(EdgeList,1)
    plot3([N1(i,1) N2(i,1)],[N1(i,2) N2(i,2)],[N1(i,3) N2(i,3)],'color',ColorP(i,:),'linewidth',max(1,abs(EdgeList(i,3))));hold on; 
end
%     plot3([N1(i,1) N2(i,1)],[N1(i,2) N2(i,2)],[N1(i,3) N2(i,3)]);hold on; 


for i=1:size(EdgeList,1)
    plot3([N2(i,1) N1(i,1)],[N2(i,2) N1(i,2)],[N2(i,3) N1(i,3)],'color',ColorP(i,:),'linewidth',max(1,abs(EdgeList(i,3))));hold on; 
end

