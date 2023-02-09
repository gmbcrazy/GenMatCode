function FC_BrainEEGLu(ChanPos,AdjWeight,NodeWeight,EdgeTh,NodeTh,EdgeColor,NodeColor,varargin)

x=ChanPos.ColinCoord;
xstep=(max(x)-min(x))/8;
xrange=[min(x)-xstep;max(x)+xstep];
hold on;     
patch('Vertices',ChanPos.Cortex.vertices,'Faces',ChanPos.Cortex.faces,...
      'FaceColor',[0.5 0.5 0.5], 'FaceAlpha',0.05,'EdgeAlpha',0);    %%%%%%%%% Plot scalp map %%%%%%%%%
xlim(xrange(:,1))
ylim(xrange(:,2))
zlim(xrange(:,3))

   axis off;
   view([-90 90]);

if size(AdjWeight,2)==2
   EdgeList=AdjWeight;
else
   EdgeList=Adj2WeightList(AdjWeight,EdgeTh);
end
if isempty(EdgeList)
   disp('No Edge Detected');
   return;
end
if nargin==8
   ScaleF=varargin{1};
   EdgeList(:,3)=EdgeList(:,3)/ScaleF;
end

if isempty(NodeWeight)
NormAdj=zeros(size(AdjWeight));
for iEdge=1:size(EdgeList,1)
    NormAdj(EdgeList(iEdge,1),EdgeList(iEdge,2))=EdgeList(iEdge,3);
end
NormAdj=triu(NormAdj);
NormAdj=NormAdj+NormAdj';
Degree=sum(sum(NormAdj),1);
Degree=Degree/length(ChanPos.X);

else
Degree=NodeWeight;
end


if nargin==5
   EdgeColor=varargin{1};
   if size(EdgeColor,1)==1
      EdgeColor=repmat(EdgeColor,size(EdgeList,1),1);  
   end
else            %%%%%%%%%Red for positive link, Blue for Negative link
   EdgeColor=repmat([0.9 0.1 0.1],size(EdgeList,1),1); 
   if isempty(EdgeList)
      return
   end
   IndexN=find(EdgeList(:,3)<0);
   if ~isempty(IndexN)
   for i=1:length(IndexN)
       EdgeColor(IndexN(i),:)=[0.1 0.1 0.9];
   end
   end
end


   
% % x(:,1)=ChanPos.Y;
% % x(:,2)=ChanPos.X;
% % x(:,3)=ChanPos.Z;




N1=x(EdgeList(:,1),:);
N2=x(EdgeList(:,2),:);


hold on;
for i=1:size(EdgeList,1)
    plot3([N1(i,1) N2(i,1)],[N1(i,2) N2(i,2)],[N1(i,3) N2(i,3)],'color',EdgeColor(i,:),'linewidth',max(1,abs(EdgeList(i,3)))); 
end
    
NodeColor=ChanPos.LobColor(ChanPos.LobID(1,:),:);
NodeBrainEEGLu(ChanPos,Degree,NodeTh,NodeColor);

 hold off;
 light;
 

