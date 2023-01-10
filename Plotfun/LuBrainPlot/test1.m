function MultiSliceGraph(Adj,Layer,ColorF,Rot,varargin)

NodeN=size(Adj{1},1);
if nargin==5
   AllAdj=varargin{1};
else
   AllAdj=repmat(zeros(size(Adj{1})),length(Adj),length(Adj));
end
alphaF=0.02;
% Layer=[0:200:400];
% ColorF=[1 0 0;0 1 0;0 0 1;];
% Rot=[-pi/6 pi/2;0 pi/2;pi/6 pi/2]
EdgeTh=0.5;
% NodeN=120;
% % % Adj{1}=zeros(NodeN,NodeN);Adj{1}(1,40)=1;
% % % Adj{2}=zeros(NodeN,NodeN);Adj{2}(94,5)=1;
% % % Adj{3}=zeros(NodeN,NodeN);Adj{3}(44,110)=1;Adj{3}(44,94)=1;
% % InterAdj{1,2}=zeros(NodeN,NodeN);InterAdj{1,2}(4,10)=1;
% % InterAdj{2,3}=zeros(NodeN,NodeN);InterAdj{2,3}(10,10)=1;
% % l=max(size(InterAdj,1),size(InterAdj,2));
% % AllAdj=repmat(zeros(NodeN,NodeN),length(Adj),length(Adj));
for i=1:length(Adj)
%     DegreeInter{i}=zeros(1,NodeN);
    for j=1:length(Adj)
%         InterAdj{i,j}=sign(InterAdj{i,j}+InterAdj{i,j}');
%         if ~isempty(InterAdj{i,j})
        r1=((i-1)*NodeN+1):(i*NodeN);
        r2=((j-1)*NodeN+1):(j*NodeN);     
        AllAdj(r1,r2)=InterAdj{i,j};
        InterAdj{i,j}=AllAdj(r1,r2);
    end
    
end
% AllAdj=AllAdj+AllAdj';
for i=1:l
    r1=((i-1)*NodeN+1):(i*NodeN);
    DegreeInter{i}=sum(AllAdj(r1,:)');
end


for i=1:length(Adj)
    Adj{i}=sign(Adj{i}+Adj{i}');
end

for i=1:length(Adj)
    DegreeIntra{i}=sum(sign(Adj{i}+Adj{i}'));
end

figure;
for i=1:length(Layer)
    
subplot('position',[0 0 1 1])
Degree=DegreeIntra{i}+sign(DegreeInter{i});
IndexAAL=find(Degree>0);
WeightNode=Degree(IndexAAL);
SurfaceBrainLu([Layer(i) 0 0],ColorF(i,:),alphaF,Rot(i,:));hold on;
Coor(i).x=NodeBrainLuML(IndexAAL,Layer(i),WeightNode,Rot(i,:),NodeN);hold on;

EdgeList=Adj2WeightList(Adj{i},EdgeTh);
EdgeBrainLuML(Coor(i).x,EdgeList,[1 0 0]);hold on;

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
EdgeBrainLuML([Coor(i).x Coor(j).x],EdgeList,[0 1 0]);hold on;
end 
end
end
light('position',[0 -600 30],'style','local');lighting gouraud
view([0 -400 Rot(1,2)*200]);grid off
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[0.99 0.99 0.99],'ycolor',[0.99 0.99 0.99],'zcolor',[0.99 0.99 0.99])

