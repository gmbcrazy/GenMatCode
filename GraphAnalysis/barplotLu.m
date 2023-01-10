function barplotLu(Xstart,Ystart,Xwidth,Ywidth,color,alpha)

if length(Ywidth)==1
   Ywidth=repmat(Ywidth,length(Xstart),1);
end
if length(Ystart)==1
   Ystart=repmat(Ystart,length(Xstart),1);
end
if length(Xwidth)==1
   Xwidth=repmat(Xwidth,length(Xstart),1);
end

if size(color,1)==1
   color=repmat(color,length(Xstart),1);
end



for i=1:length(Xstart)
    h(i)=fill([Xstart(i) Xstart(i)+Xwidth(i) Xstart(i)+Xwidth(i) Xstart(i) Xstart(i)],[Ystart(i) Ystart(i) Ystart(i)+Ywidth(i) Ystart(i)+Ywidth(i) Ystart(i)],color(i,:));
%     set(h(1),'edgecolor',color,'edgealpha',0,'facealpha',alpha);
hold on;
end
%     h=get(gca,'children');

for i=1:length(h)
set(h(i),'edgecolor',color(i,:),'edgealpha',0,'facealpha',alpha);
hold on;
end

% fill([X(1) X(1:end) fliplr([X(1:end) X(end)])],[Yabove(1) Yabove fliplr([Ylow Ylow(end)])],color);
% hold on;
% plot(X,Y,'color',color);
% h=get(gca,'children');
% set(h(2),'facealpha',alpha,'linestyle','-');
% set(h(2),'edgecolor',color,'edgealpha',alpha);
% set(h(1),'linestyle','-');
% 


