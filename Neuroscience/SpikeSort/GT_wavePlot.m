function GT_wavePlot(AP,Ch,varargin)

% l=0;
% s=1;

% subplot('position',[0.05 0.05 0.94 0.94]);
WL=size(AP,2);
if nargin==3
   ColorP=varargin{1};
   for i=1:size(AP,1)
    PlotI=[1:WL]+(i-1)*(WL+1);
    if i==(Ch)
       plot(PlotI,AP(i,:),'color',ColorP(i,:),'linewidth',1);hold on
       plot(PlotI(1),0,'k*');hold on
   
    else
       plot(PlotI,AP(i,:),'color',ColorP(i,:),'linewidth',1);hold on
    end
   end
  
elseif nargin==1
    
   for i=1:size(AP,1)
       PlotI=[1:WL]+(i-1)*(WL+1);
       plot(PlotI,AP(i,:),'k','linewidth',1);hold on
   end
    

else
    

for i=1:size(AP,1)
    PlotI=[1:WL]+(i-1)*(WL+1);
    if i~=(Ch)
       plot(PlotI,AP(i,:),'k');hold on
    else
       plot(PlotI,AP(i,:),'r','linewidth',1);hold on
    end
end


end

plot([max(PlotI) max(PlotI)],[max(max(AP(:,:))) max(max(AP(:,:)))-2],'k','linewidth',1);hold on


set(gca,'xlim',[0 max(PlotI)],'xtick',[],'ytick',[],'ylim',[min(min(AP(:,:)))-1 max(max(AP(:,:)))+1],'box','off');

% 
% if nargin==5
% linestyle=varargin{1};
% linewidth=1;
% 
% elseif nargin==6
% linewidth=varargin{2};
% else
%     linestyle='-';
%     linewidth=1;
% end
% 
% 
% for i=1:4
%     
%     error_area([1:npw(i)]+l,mean(AP(:,s:(s+npw(i)-1))),std(AP(:,s:(s+npw(i)-1))),color,alpha,linestyle,linewidth);hold on;
%     TmaxA(i)=max(mean(AP(:,s:(s+npw(i)-1)))+std(AP(:,s:(s+npw(i)-1))));
%     TminA(i)=min(mean(AP(:,s:(s+npw(i)-1)))-std(AP(:,s:(s+npw(i)-1))));
%     l=l+npw(i)+1;
%     s=s+npw(i);
% 
% end
% 
% Ylim=[min(TminA)-0.01 max(TmaxA)+0.01];
% 
% set(gca,'tickdir','out', 'FontSize',9,'FontUnits','points','xtick',[],'ytick',[]);
% set(gca,'xlim',[0 sum(npw)+8],'ylim',Ylim,'box','off','xcolor',[0.99 0.99 0.99],'ycolor',[0.99 0.99 0.99],'fontsize',8);
% 
% hold on;
% adfreq=20000;
% Ltimebar=0.001;
% Ltimebar=Ltimebar*adfreq;
% 
% plot([sum(npw)-Ltimebar,sum(npw)],[Ylim(1)+0.01,Ylim(1)+0.01],'k','linewidth',2);hold on
% text(sum(npw)-Ltimebar/2,Ylim(1)+diff(Ylim)/20,'1 ms','fontsize',8);hold on
% 
% plot([sum(npw)+5,sum(npw)+5],[Ylim(2)-0.01,Ylim(2)-0.01-0.05],'k','linewidth',2);hold on
% text(sum(npw)+9,Ylim(2)-0.01,'0.05 mV','fontsize',8,'rotation',-90);hold on
% 
% diff(Ylim-0.02)

