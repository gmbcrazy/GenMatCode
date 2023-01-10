function EdgeBrainLu(Edge,ColorP)

if size(ColorP,1)==1
   ColorP=repmat(ColorP,size(Edge,1),1); 
end

if size(Edge,2)==2
   Edge(:,3)=1;      %%%%%%%equal width of links
end

EdgeWeight=Edge(:,3);
Edge=round(Edge(:,1:2));

Invalid=find(EdgeWeight==0);
EdgeWeight(Invalid)=[];
Edge(Invalid,:)=[];

lobColor  = [204,26,128;0,153,230;128,51,204;51,230,153;230,102,26;255,145,247;230,230,51]/255;
load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\LuAAL.mat');
load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\AAL116_BrainNetView.mat');

radius=5;
% Index116=[13 77 91];
% Size=[1 3 7];
for i=1:size(Edge,1)
    N1=[CellNode{Edge(i,1),1} CellNode{Edge(i,1),2} CellNode{Edge(i,1),3}];
    N2=[CellNode{Edge(i,2),1} CellNode{Edge(i,2),2} CellNode{Edge(i,2),3}];
    plot3([N1(1) N2(1)],[N1(2) N2(2)],[N1(3) N2(3)],'linewidth',EdgeWeight(i)*10,'color',ColorP(i,:));
    hold on;
end
hold off