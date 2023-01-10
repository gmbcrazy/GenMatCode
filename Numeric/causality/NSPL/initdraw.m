function initdraw(fig,handles)
%This fucntion is used to initial the screen

heigthtotalscaleinwin=0.85;
widthperplot=0.9;

plotpos=[0.05 0.15 widthperplot heigthtotalscaleinwin*0.95];
subplot(fig,'Position',plotpos);
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
%set(gca,'Visible','off');