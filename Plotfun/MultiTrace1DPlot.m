function MultiTrace1DPlot(Data,PlotP,varargin)
%%%%%%%%Data is Cell, each cell is a vector, each sample is Data(:,:,i)

xLeft=0.08;
xInt=0.02;
xRight=0.09;
xNum=max(PlotP);
xWidth=(1-xLeft-xRight-xInt*(xNum-1))/xNum;

yAbove=0.03;
% yInt=0.02;
yBelow=0.15;
% yNum=size(Data,3);
yWidth=(1-yAbove-yBelow);

if nargin==3
   P=varargin{1}; 
end


%# plot each slice as a texture-mapped surface (stacked along the Z-dimension)
for k=1:length(Data)
    subplot('position',[xLeft+(PlotP(k)-1)*(xWidth+xInt),yBelow,xWidth,yWidth])
%     surface('XData',floor(Z.*XPlot(k)*size(Z,1)/2), 'YData',X, 'ZData',Y, ...
%         'CData',squeeze(Data(:,:,k)), 'CDataMapping','direct', ...
%         'EdgeColor','none', 'FaceColor','texturemap');
   X=length(Data{k});

   plot(1:X,Data{k},'k','linewidth',1) 
%     box off
% set(gca,'xlim',[0 size(Data,1)],'ylim',[0 size(Data,2)],'xtick',[],'ytick',[])
axis xy
set(gca,'xlim',[1 X],'ylim',[min(Data{k}) max(Data{k})],'xtick',[],'ytick',[],'box','off')
set(gca,'xcolor',[0.99 0.99 0.99],'ycolor',[0.99 0.99 0.99])

if nargin==3
      set(gca,'ylim',[min(P.Ytick) max(P.Ytick)]);
      hold on;
   if isfield(P,'Xwidth')
      barplotLu(1,max(P.Ytick)-0.2,P.Xwidth,0.1,[0.1 0.1 0.1],1);
   end
if k==length(Data)
       if isfield(P,'Ywidth')
          barplotLu(X-4,max(P.Ytick)-P.Ywidth-0.1,4,P.Ywidth,[0.1 0.1 0.1],1);
       end
end
      
end



end
% a=colorbar;
% set(a,'xtick',[],'ytick',-1:0.5:1,'yticklabel',[],'position',[1-xRight+0.02 yBelow+yWidth/4 0.01 yWidth/2],'box','on');
% colormap(cmap)
% axis tight square
% set(gca, 'YDir','reverse', 'ZLim',[1 size(Data,3)])
