function x=NodeBrainLuML(IndexAAL,Layer,SizeN,AngRot,varargin)

%%%%multilayerPlot

if nargin==5
   AAL=varargin{1};
   PlotPara.NodeFontColor=[0 0 0];
       PlotPara.ShowAng=[100 0 0];
   PlotPara.Yeo=1;
%    AAL=varargin
elseif nargin==6
   AAL=varargin{1};
   PlotPara=varargin{2};
else
    AAL=116;
    PlotPara.NodeFontColor=[0 0 0];
    PlotPara.ShowAng=[100 0 0];

%     PlotPara.NodeFontColor=[0 0 0];
end
    lobColor  = [204,26,128;0,153,230;128,51,204;51,230,153;230,102,26;255,145,247;230,230,51]/255;




if AAL==116||AAL==90
load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\LuAAL.mat');
load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\AAL116_BrainNetView.mat');
    for i=1:AAL
        x(i,:)=[CellNode{i,1} CellNode{i,2} CellNode{i,3}];
    
%     hold on;
    end
    
elseif AAL==264
    load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\LuPower264.mat');
    RegionName=LobleName;
        lobColor = [224 224 224;0 204 225;255 102 0;128 0 128;255 153 204;255 0 0;150 150 150;0 0 255;255 255 0;0 0 0;153 51 0;51 153 102;0 255 0;153 204 255]/255;
        LobleID=LobleID+1;
        LobleID(LobleID==0)=1;
    PlotPara.ShowNodeLabel=0;
else
load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\LuAAL120OldNewName.mat');
% load('C:\Users\lzhang481\ToolboxAndScript\my program\fMRI\AAL\AAL116_BrainNetView.mat');
Coord=Coord(:,1:AAL);

if isfield(PlotPara,'Yeo')
LobleID=YeoLu(1:AAL);
% LobleName=LobleName(1:AAL);
RegionName=RegionName(1:AAL);
lobColor =[120,18,134;70,130,180;0,118,14;196,58,250;220,248,164;230,148,34;205,62,78;128,51,204;230,230,51]/255;

else
LobleID=LobleID(1:AAL);
LobleName=LobleName(1:AAL);
RegionName=RegionName(1:AAL);
 
end

x=Coord(:,:)';


end
radius=5;
% IndexAAL=[13 77 91];
% Size=[1 3 7];
[A1,A2,r]=cart2pol(x(:,1),x(:,2),x(:,3));
A1=A1+AngRot(1);
% A2=A2+AngRot(2);
[x(:,1),x(:,2),x(:,3)]=pol2cart(A1,A2,r);


x(:,1)=x(:,1)+Layer;



% if AppNode==1
%    x(:,1)=x(:,1)-100; 
% end

   
    SpherePlot(x(IndexAAL,:),radius,lobColor(LobleID(IndexAAL),:),SizeN);
    
   tempPos=random('uniform',-10,10,3,length(IndexAAL));
    
if PlotPara.NodeLabelShow==1
    Index=find(SizeN>=0);
    for i=1:length(Index)
%         i
temp=RegionName{IndexAAL(Index(i))};
temp(findstr(temp,'_'))='';
        text(x(IndexAAL(Index(i)),1)+tempPos(1,i)+(PlotPara.ShowAng(1)),x(IndexAAL(Index(i)),2)+tempPos(2,i)+PlotPara.ShowAng(2),x(IndexAAL(Index(i)),3)+tempPos(3,i)+PlotPara.ShowAng(3),...
        deblank(temp),'fontsize',5,'color', PlotPara.NodeFontColor,'fontweight','bold','fontname','Times New Roman') 
    end
end
%     view([0,0,1]), camlight, lighting gouraud
% hold off
% light('position',[6 6 3],'style','local')
% light('position',[2 2 4],'style','infinite');
    
