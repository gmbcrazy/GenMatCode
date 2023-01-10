function wavePlot(AP,npw,color,alpha,varargin)

l=0;
s=1;

if nargin==5
linestyle=varargin{1};
linewidth=1;

elseif nargin==6
linewidth=varargin{2};
else
    linestyle='-';
    linewidth=1;
end


for i=1:4
    
    error_area([1:npw(i)]+l,mean(AP(:,s:(s+npw(i)-1))),std(AP(:,s:(s+npw(i)-1))),color,alpha,linestyle,linewidth);hold on;
    TmaxA(i)=max(mean(AP(:,s:(s+npw(i)-1)))+std(AP(:,s:(s+npw(i)-1))));
    TminA(i)=min(mean(AP(:,s:(s+npw(i)-1)))-std(AP(:,s:(s+npw(i)-1))));
    l=l+npw(i)+1;
    s=s+npw(i);

end

Ylim=[min(TminA)-0.01 max(TmaxA)+0.01];

set(gca,'tickdir','out', 'FontSize',9,'FontUnits','points','xtick',[],'ytick',[]);
set(gca,'xlim',[0 sum(npw)+8],'ylim',Ylim,'box','off','xcolor',[0.99 0.99 0.99],'ycolor',[0.99 0.99 0.99],'fontsize',8);

hold on;
adfreq=20000;
Ltimebar=0.001;
Ltimebar=Ltimebar*adfreq;

plot([sum(npw)-Ltimebar,sum(npw)],[Ylim(1)+0.01,Ylim(1)+0.01],'k','linewidth',2);hold on
text(sum(npw)-Ltimebar/2,Ylim(1)+diff(Ylim)/20,'1 ms','fontsize',8);hold on

plot([sum(npw)+5,sum(npw)+5],[Ylim(2)-0.01,Ylim(2)-0.01-0.05],'k','linewidth',2);hold on
text(sum(npw)+9,Ylim(2)-0.01,'0.05 mV','fontsize',8,'rotation',-90);hold on

% diff(Ylim-0.02)

