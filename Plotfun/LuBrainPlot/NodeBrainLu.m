function NodeBrainLu(Index116,SizeN,varargin)

if nargin==4
   AppNode=varargin{1};
   AAL=varargin
else
   AppNode=0;
end
lobColor  = [204,26,128;0,153,230;128,51,204;51,230,153;230,102,26;255,145,247;230,230,51]/255;
load('D:\FMRI\AAL\LuAAL.mat');
load('D:\FMRI\AAL\AAL116_BrainNetView.mat');

radius=5;
% Index116=[13 77 91];
% Size=[1 3 7];
for i=1:length(Index116)
    x(i,:)=[CellNode{Index116(i),1} CellNode{Index116(i),2} CellNode{Index116(i),3}];
    
%     hold on;
end
if AppNode==1
   x(:,1)=x(:,1)-100; 
end

   
    SpherePlot(x,radius,lobColor(LobleID(Index116),:),SizeN);
    
    Index=find(SizeN>=0.01);
    for i=1:length(Index)
        text(x(Index(i),1)-70,x(Index(i),2),x(Index(i),3),RegionName{Index116(Index(i))}) 
    end
    
    
