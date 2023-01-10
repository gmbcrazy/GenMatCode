%%%%%%%%%%%%%%%%%%%%% forest.m %%%%%%%%%%%%%%
function forest(mean,low,high,metaValue,p,varargin)
% subplot(1,2,1)
mean=mean(:);
low=low(:);
high=high(:);

if isfield(p,'Size')
   MarkerSizeP=p.Size;
else
   MarkerSizeP=zeros(size(mean))+6;
end
    
if nargin==6
   texts=varargin{1}; 
   
   for n=1:length(texts)
    text(-1,n,texts{n});
% %     numbers = sprintf('%6.3f %6.3f %6.3f',mean(n),low(n),high(n));
% %     text(0.5,n,numbers);
   end
else
       for n=1:length(mean)
           texts{n}='';
       end
end

% % high=mean+std;
% % low=mean-std;

% % set(gca,'visible','off')
l=length(mean)
for i=1:length(mean)
%     if mean(i)>0
%        plot([low(i) high(i)],[i,i],'color',[1 0 0]);hold on;
%        plot(mean(i),[1;1]*i,'.','color',[1 0 0],'markersize',8);
% 
%     else
%       plot([low(i) high(i)],[i,i],'color',[0 0 1]);hold on;
%             plot(mean(i),[1;1]*i,'.','color',[0 0 1],'markersize',8);
% 
%     end
plot([low(i) high(i)],[i,i],'color',p.color(i,:));hold on;
plot(mean(i),[1;1]*i,'.','color',p.color(i,:),'markersize',MarkerSizeP(i));
pplot.color=[0 0 0];

end
if metaValue>0
a=plot(metaValue,l+1,'marker','diamond','markerSize',7,'color',[255 102 102]/255,'markerfacecolor',[255 102 102]/255,'markeredgecolor',[255 102 102]/255);
a=plot(metaValue,l+1,'marker','diamond','markerSize',7,'color',[1 1 1]/255,'markerfacecolor',[1 1 1]/255,'markeredgecolor',[1 1 1]/255);

% set(a,'markeredgecolor',[255 102 102]/255)
set(a,'markeredgecolor',[1 1 1]/255)

else
a=plot(metaValue,l+1,'marker','diamond','markerSize',7,'color',[102 237 243]/255,'markerfacecolor',[102 237 243]/255,'markeredgecolor',[102 237 243]/255);
a=plot(metaValue,l+1,'marker','diamond','markerSize',7,'color',[1 1 1]/255,'markerfacecolor',[1 1 1]/255,'markeredgecolor',[1 1 1]/255);

set(a,'markeredgecolor',[102 237 243]/255)
set(a,'markeredgecolor',[1 1 1]/255)

end
set(gca,'ydir','reverse')




% % plot([low,high]',[1;1]*(1:length(mean)),'color',p.color)
% % hold on;
% % plot(mean,[1;1]*(1:length(mean)),'.','color',p.color,'markersize',8);
% % a=plot(metaValue,0,'marker','diamond','markerSize',10,'color',p.color,'markerfacecolor',p.color);
% set(a,'markeredgecolor',p.color)
% % axis([0,1.5,0,length(texts)+1])

set(gca,'ylim',[-0.5 length(mean)+0.5],'ytick',[0:length(mean)],'tickdir','in','xtick',[],'yticklabel',texts);hold off
% axis([1e-2,1e2,0,length(mean)+1])
%%%%%%%%%%%%%%%%%%%%% /forest.m %%%%%%%%%%%%%%