function [OutPut,r,p]=LuPairRegressPlot(data1,data2,varargin)    

if nargin==2
   Param.Color=[0.1 0.1 0.1];
   Param.Marker='s';
   Param.MarkerSize=2;
   Param.Rtype='pearson';
   Param.xLim=[min(data1) max(data1)];
   Param.yLim=[min(data2) max(data2)];
   Param.xLabel=[];
   Param.yLabel=[];
   
elseif nargin==3
   Param=varargin{1};
else

end

scatter(data1,data2,Param.MarkerSize,Param.Color,'filled',Param.Marker)
% plot(data1,data2,'color',Param.Color,'linestyle','none','marker',Param.Marker,'markersize',Param.MarkerSize);hold on;
[B,BINT,R,RINT,STATS]=regress(data2,[ones(length(data1),1) data1]);
OutPut.B=B;
OutPut.BINT=BINT;
OutPut.R=R;
OutPut.RINT=RINT;
OutPut.STATS=STATS;


x=[min(data1(:)) max(data1(:))]';
y=[[1 1]' x]*B;
[r,p]=corr(data1,data2,'rows','complete','type',Param.Rtype);
%%%%%%%%Red for positive correlaiton, Blue for negative correlation, with p%%%%%%%%< 0.05;
if r>0
   PColor=[1 0 0];
    
elseif r<0
   PColor=[0 0 1];

else
end
%%%%%%%%Red for positive correlaiton, Blue for negative correlation, with p%%%%%%%%< 0.05;

if p < 0.05
text(Param.xLim(1),Param.yLim(2),['r = ' showNum(r,3) ', p' showPvalue(p,3)],'color',PColor,'fontsize',10,'horizontalalignment','left','verticalalignment','bottom','fontname','Times New Roman');
hold on;
% plot(x,y,'-','color',PColor,'linewidth',2); 
a=lsline;
a.LineWidth=2;
a.Color=PColor;
else 
hold on;
% plot(x,y,'-','color',Param.Color,'linewidth',1); 
text(Param.xLim(1),Param.yLim(2),['r = ' showNum(r,3) ', p' showPvalue(p,3)],'color',[0.01 0.01 0.01],'fontsize',10,'horizontalalignment','left','verticalalignment','bottom','fontname','Times New Roman');
end
%           set(gca,'xlim',[-1.1 1.1],'ylim',[-1.1 1.1])

set(gca,'xscale','linear','yscale','linear','xlim',Param.xLim,'ylim',Param.yLim)
xlabel(Param.xLabel);
ylabel(Param.yLabel);

