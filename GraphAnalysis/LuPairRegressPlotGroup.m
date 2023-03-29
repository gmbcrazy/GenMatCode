
function [OutPut,r,p]=LuPairRegressPlotGroup(data1,data2,Pth,varargin)    

if nargin==3
   Param.NodeColor=[0.1 0.1 0.1];
   Param.Marker='circle';
   Param.MarkerSize=2;
   Param.Rtype='pearson';
   Param.xLim=[min(data1) max(data1)];
   Param.yLim=[min(data2) max(data2)];
   Param.xLabel=[];
   Param.yLabel=[];
   Param.SubjIDColor=[0.6 0.6 0.6];
   Param.SubjID=zeros(size(DataGroup,1),1)+1;
elseif nargin==4
   Param=varargin{1};
else

end

SubjGroup=unique(Param.SubjID);

hold on;
% scatter(data1,data2);
for iSG=1:length(SubjGroup)
    Ip=Param.SubjID==SubjGroup(iSG);
    scatter(data1(Ip),data2(Ip),Param.MarkerSize,Param.SubjIDColor(iSG,:),'filled');
end
% scatter(data1,data2,Param.MarkerSize,Param.NodeColor,'filled',Param.Marker);hold on;
% plot(data1,data2,'color',Param.Color,'linestyle','none','marker',Param.Marker,'markersize',Param.MarkerSize);hold on;
[B,BINT,R,RINT,STATS]=regress(data2,[ones(length(data1),1) data1]);
OutPut.B=B;
OutPut.BINT=BINT;
OutPut.R=R;
OutPut.RINT=RINT;
OutPut.STATS=STATS;


x=[min(data1(:)) max(data1(:))]';
y=[[1 1]' x]*B;
[r,p]=corr(data1,data2,'rows','pairwise','type',Param.Corr);
if isfield(Param,'ColorMap')&&isfield(Param,'Clim')
Clim=Param.Clim;
ColorMapC=Param.ColorMap;
ClimN=size(ColorMapC,1);
ColorID=1:ClimN;
[B1,E1]=discretize(Clim,ClimN);
[ColorM1I,~] = discretize(r,E1);
Param.EdgeColor=ColorMapC(ColorM1I,:);
end

%%%%%%%%Red for positive correlaiton, Blue for negative correlation, with p%%%%%%%%< 0.05;
if isfield(Param,'EdgeColor')
PColor=Param.EdgeColor;
else
if r>0
   PColor=[1 0 0];
    
elseif r<0
   PColor=[0 0 1];

else
end
end
if r>0
   PTColor=[1 0 0];
    
elseif r<0
   PTColor=[0 0 1];

else
end

%%%%%%%%Red for positive correlaiton, Blue for negative correlation, with p%%%%%%%%< 0.05;

if p < Pth
text(Param.xLim(1),Param.yLim(2),[Param.ShowName 'r = ' showNum(r,3) ', p' showPvalue(p,3)],'color',PTColor,'fontsize',10,'horizontalalignment','left','verticalalignment','bottom','fontname','Times New Roman');
hold on;
plot(x,y,'-','color',PColor,'linewidth',2); 
% a=lsline;
% a.LineWidth=2;
% a.Color=PColor;
else 
hold on;
% plot(x,y,'-','color',Param.Color,'linewidth',1); 
text(Param.xLim(1),Param.yLim(2),[Param.ShowName 'r = ' showNum(r,3) ', p' showPvalue(p,3)],'color',[0.01 0.01 0.01],'fontsize',10,'horizontalalignment','left','verticalalignment','bottom','fontname','Times New Roman');
end
%           set(gca,'xlim',[-1.1 1.1],'ylim',[-1.1 1.1])

set(gca,'xscale','linear','yscale','linear','xlim',Param.xLim,'ylim',Param.yLim)
xlabel(Param.xLabel);
ylabel(Param.yLabel);
       end

           

function [G,p,varargout]=GT_CirBundleHeatPlotLastNodeTop(Adj,Degree,ComColor,NodeName,ColorMapC,Clim)

Dim1=size(Adj,1);
temp1M=ones(Dim1)/Dim1;
temp1C=ones(size(Degree))/Dim1;

[G,p,AngP]=GT_CirBundlePlotLastNodeTop(Adj,Degree,ComColor,NodeName);
clear temp1M temp1C;

M1=G.Edges.Weight;
M1(M1>Clim(2))=Clim(2);
M1(M1<Clim(1))=Clim(1);

ClimN=size(ColorMapC,1);
ColorID=1:ClimN;
% % Clim=[-0.1 0.1];
% % ClimN=10;
[B1,E1]=discretize(Clim,ClimN);
% % X=[-0.3 0.05 0.01 0.09 0.02 -0.03 0.01]
[ColorM1I,~] = discretize(M1,E1);
% [ColorC1I,~] = discretize(C1,E1);
% ColorM2I=reshape(ColorM1I,[Dim1,Dim1]);


for i=1:ClimN
      [s] = find(ColorM1I==ColorID(i));
     if ~isempty(s)
       Gtemp = digraph(G.Edges(s,:),G.Nodes);
       highlight(p,Gtemp,'edgecolor',ColorMapC(ColorM1I(s(1)),:));
     end
     
     
     
     
end


% AngRotate=pi/2-AngP(end);
% 
% AngP=AngP+AngRotate;
if nargout==3
    varargout{1}=AngP;
end

% p.XData=cos(AngP);
% p.YData=sin(AngP);

p.NodeLabel=NodeName;
end

function varargout=GT_CirBundlePlotLastNodeTop(Adj,Degree,ComColor,NodeName)

%%%%%[G,p]=MarkovState_Plot(Adj,ComColor,Param)
if isempty(Adj)
   varargout{1}=[];
   varargout{2}=[];
   return;
end

Adj=triu(Adj,1);

[i1,i2,Edgeweight]=find(Adj);

Adj(isnan(Adj))=0;
X=squeeze(Adj);
% X=Adj;
n=size(X,1);
AngDiff=2*pi/(size(Adj,2));

AngP=[0:(size(Adj,2)-1)]*AngDiff;


%%%%%%%%Make the last Node at top of graph
AngRotate=pi/2-0.01-AngP(end);
AngP=AngP+AngRotate;
%%%%%%%%Make the last Node at top of graph


xi=cos(AngP);
yi=sin(AngP);
% zi=zeros(size(xi));


XX=X+X';
if isempty(Degree)
Degree=sum(abs(X),2)/sum(sum(abs(X)));
% Degree=Degree/sum(Degree);
end

for i=1:size(X,1)
    X(i,:)=X(i,:)/sum(X(i,:)); 
end

G = digraph(i1,i2,(Edgeweight),length(Degree));
G.Edges.Weight(isnan(G.Edges.Weight))=0;
weights=abs(G.Edges.Weight);
varargout{1}=G;
if nargout==2||nargout==3
% % figure;
p=plot(G,'Layout','force','EdgeColor',[0.5 0.5 0.5],'ArrowSize',5);

if exist('ComColor')
   if size(ComColor,1)==1
      ComColor=repmat(ComColor,n,1);
   end
else
   ComColor=repmat([0 0 0],n,1);

end
% p.LineWidth=(weights-min(weights)+0.1)*15;
% p.LineWidth=(weights-min([0.2,min(weights)])+0.1)*4;  %%%%%%%%Previously used;

tempweights=(weights-0.1)*2;
tempweights(tempweights<=0)=0.1;
p.LineWidth=tempweights+1;

% p.Marker='^';
Degree(isnan(Degree))=0;
p.MarkerSize=(Degree-min([0.2,min(Degree)])+0.1)*20;

% p.MarkerSize=abs(Degree)*400;

p.NodeLabel=[];
p.EdgeLabel=[];
p.XData=xi;
p.YData=yi;

LabelPos=[xi(:) yi(:)]*1.15;
% for i=1:length(NodeName)
%      if abs(AngP(i))>pi
%     
% %        a=text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',6,'rotation',((AngP(i)/pi*180)-180)/2,'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
%        a=text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',5,'rotation',((AngP(i)/pi*180)+90),'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
% 
%     else
% %        a= text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',6,'rotation',((AngP(i))/pi*180)/2,'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
%        a=text(LabelPos(i,1),LabelPos(i,2),NodeName{i},'fontsize',5,'rotation',((AngP(i)/pi*180)-90),'HorizontalAlignment','center','fontweight','bold','fontname','Times New Roman');    
% 
%     end
% end

varargout{2}=p;
set(gca,'xlim',[-1.2 1.2],'ylim',[-1.2 1.2],'xtick',[],'ytick',[],'xcolor',[0.99 0.99 0.99],'ycolor',[0.99 0.99 0.99])

% highlight(p,[1:n],'NodeColor',ComColor(1:n,:));
for iN=1:n
highlight(p,iN,'NodeColor',ComColor(iN,:));
end
% axes('Color','none','XColor','none');
end
p.EdgeAlpha=1;
p.ArrowSize=0;

% AdjUp=triu(Adj,1);
% [i1Up,i2Up,EdgeweightUp]=find(AdjUp);
% 
% G1=digraph(i1Up,i2Up,EdgeweightUp);
varargout{1}=G;

% % highlight(p,G1,'EdgeColor',[0.7 0.7 0.7]);
varargout{2}=p;
varargout{3}=AngP;
end