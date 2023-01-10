function barplot(Xstart,Ystart,Xwidth,Ywidth,color,alpha)


for i=1:length(Xstart)
    fill([Xstart(i) Xstart(i)+Xwidth(i) Xstart(i)+Xwidth(i) Xstart(i) Xstart(i)],[Ystart(i) Ystart(i) Ystart(i)+Ywidth(i) Ystart(i)+Ywidth(i) Ystart(i)],color);
    h=get(gca,'children');
    set(h(1),'edgecolor',color,'edgealpha',0,'facealpha',alpha);
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


