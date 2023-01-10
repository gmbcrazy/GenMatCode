function MultiSliceGraphEdgeWeight(Adj,Layer,Rot,PlotPara,varargin)

NodeN=size(Adj{1},1);
if nargin==5
   AllAdj=varargin{1};
else
   AllAdj=repmat(zeros(size(Adj{1})),length(Adj),length(Adj));
end

if isfield(PlotPara,'EdgeCom')
   EdgeCom=PlotPara.EdgeCom(:,2);
   EdgeComC=zeros(length(EdgeCom),3);
   for i=1:max(EdgeCom)
       Index=find(EdgeCom==i);
       if ~isempty(Index)
           EdgeComC(Index,:)=repmat(PlotPara.EdgeComColor(i,:),length(Index),1);
       end
   end
end

if ~isfield(PlotPara,'ShowAng')
   PlotPara.ShowAng=[100 0 0];
end
if ~isfield(PlotPara,'NodeFontColor')
   PlotPara.NodeFontColor=[0.99 0.99 0.99];
end
if size(PlotPara.LayerColor,1)==1
   PlotPara.LayerColor=repmat(PlotPara.LayerColor,length(Adj),1); 
end

alphaF=0.05;
% Layer=[0:200:400];
% ColorF=[1 0 0;0 1 0;0 0 1;];
% Rot=[-pi/6 pi/2;0 pi/2;pi/6 pi/2]
EdgeTh=0.5;
l=length(Adj);
% NodeN=120;
% % % Adj{1}=zeros(NodeN,NodeN);Adj{1}(1,40)=1;
% % % Adj{2}=zeros(NodeN,NodeN);Adj{2}(94,5)=1;
% % % Adj{3}=zeros(NodeN,NodeN);Adj{3}(44,110)=1;Adj{3}(44,94)=1;
% % InterAdj{1,2}=zeros(NodeN,NodeN);InterAdj{1,2}(4,10)=1;
% % InterAdj{2,3}=zeros(NodeN,NodeN);InterAdj{2,3}(10,10)=1;
% % l=max(size(InterAdj,1),size(InterAdj,2));
% % AllAdj=repmat(zeros(NodeN,NodeN),length(Adj),length(Adj));
TotalIntraAdj=zeros(length(Adj{1}));
for i=1:length(Adj)
%     DegreeInter{i}=zeros(1,NodeN);
TotalIntraAdj=TotalIntraAdj+abs(Adj{i});
    for j=1:length(Adj)
%         InterAdj{i,j}=sign(InterAdj{i,j}+InterAdj{i,j}');
%         if ~isempty(InterAdj{i,j})
        r1=((i-1)*NodeN+1):(i*NodeN);
        r2=((j-1)*NodeN+1):(j*NodeN);     
% %         AllAdj(r1,r2)=InterAdj{i,j};
        InterAdj{i,j}=AllAdj(r1,r2);
    end
    
end
% AllAdj=AllAdj+AllAdj';
for i=1:l
    r1=((i-1)*NodeN+1):(i*NodeN);
    DegreeInter{i}=sum(abs(AllAdj(r1,:)'));
end


for i=1:length(Adj)
    Adj{i}=(Adj{i}+Adj{i}');
end

for i=1:length(Adj)
    DegreeIntra{i}=sum(abs(sign(Adj{i}+Adj{i}')));
end
TotalIntraEdgeList=Adj2WeightList(TotalIntraAdj,EdgeTh);

for i=1:length(Layer)
% subplot('position',[0.01 0.01 0.97 0.97])
Degree=DegreeIntra{i}+sign(DegreeInter{i});
IndexAAL=find(Degree>0);
WeightNode=Degree(IndexAAL).^(1/3)/3;
SurfaceBrainLu([Layer(i) 0 0],PlotPara.LayerColor(i,:),alphaF,Rot(i,:));hold on;
Coor(i).x=NodeBrainLuML(IndexAAL,Layer(i),WeightNode,Rot(i,:),NodeN,PlotPara);hold on;

EdgeList=Adj2WeightList(Adj{i},EdgeTh);
if isempty(EdgeList)
   continue 
end
EdgeIndex=EdgeNode2EdgeListIndex(EdgeList(:,1:2),length(Adj{1}));
if isempty(TotalIntraEdgeList)
    a=[];
else
    a=EdgeNode2EdgeListIndex(TotalIntraEdgeList(:,1:2),length(Adj{1}));
end
[~,iC,~]=intersect(a,EdgeIndex);
% EdgeList(EdgeList(:,3),:)==[];
if isfield(PlotPara,'EdgeCom')
   EdgeBrainLuML(Coor(i).x,EdgeList,EdgeComC(iC,:));hold on;
elseif isfield(PlotPara,'EdgeColor')
   EdgeBrainLuML(Coor(i).x,EdgeList,PlotPara.EdgeColor);hold on;

else
    
   EdgeBrainLuML(Coor(i).x,EdgeList);hold on;
end


% % Rot=[0.2 -0.2];
% % IndexAAL=[3:7:NodeN];
% % SurfaceBrainLu([Layer(3) 0 0],ColorF(3,:),alphaF,Rot);hold on;
% % NodeBrainLuML(IndexAAL,Layer(3),zeros(size(IndexAAL))+1,Rot,NodeN)
% % 
% % view([0 4 0])
end

for i=1:size(InterAdj,1)
    for j=1:size(InterAdj,2)
EdgeList=Adj2WeightList(InterAdj{i,j},EdgeTh);
if ~isempty(EdgeList)
    if isfield(PlotPara,'EdgeColor')

   EdgeBrainLuML([Coor(i).x Coor(j).x],EdgeList,PlotPara.EdgeColor);hold on;
    else
   EdgeBrainLuML([Coor(i).x Coor(j).x],EdgeList);hold on;
        
    end
end 
end
end

