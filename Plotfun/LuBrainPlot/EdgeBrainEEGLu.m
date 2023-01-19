function EdgeBrainEEGLu(ChanPos,AdjWeight,EdgeTh,ColorP)

if size(AdjWeight,2)==2
   EdgeList=AdjWeight;
else
   EdgeList=Adj2WeightList(AdjWeight,EdgeTh);
end


if nargin==4
   ColorP=varargin{1};
   if size(ColorP,1)==1
      ColorP=repmat(ColorP,size(EdgeList,1),1);  
   end
else            %%%%%%%%%Red for positive link, Blue for Negative link
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





radius=5;
x(:,1)=ChanPos.Y;
x(:,2)=ChanPos.X;
x(:,3)=ChanPos.Z;

% % if AppNode==1
% %    x(:,1)=x(:,1)-100; 
% % end
% % 
   


N1=x(EdgeList(:,1),:);
N2=x(EdgeList(:,2),:);


for i=1:size(EdgeList,1)
    plot3([N1(i,1) N2(i,1)],[N1(i,2) N2(i,2)],[N1(i,3) N2(i,3)],'color',ColorP(i,:),'linewidth',max(1,abs(EdgeList(i,3))));hold on; 
end
    
