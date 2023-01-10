function MultiMatrix2DPlot(Data,PlotP,varargin)
%%%%%%%%Data is 3D matrix, each sample is Data(:,:,i)

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


if nargin==4
   X=varargin{1};
   Y=varargin{2};
elseif nargin==5
   X=varargin{1};
   Y=varargin{2};
   P=varargin{3};
    
else
   X=1:size(Data(:,:,1),1);
   Y=1:size(Data(:,:,1),2);
 
end
%# plot each slice as a texture-mapped surface (stacked along the Z-dimension)
for k=1:size(Data,3)
    subplot('position',[xLeft+(PlotP(k)-1)*(xWidth+xInt),yBelow,xWidth,yWidth])
%     surface('XData',floor(Z.*XPlot(k)*size(Z,1)/2), 'YData',X, 'ZData',Y, ...
%         'CData',squeeze(Data(:,:,k)), 'CDataMapping','direct', ...
%         'EdgeColor','none', 'FaceColor','texturemap');
    imagesc(X,Y,squeeze(Data(:,:,k))') 
%     box off
% set(gca,'xlim',[0 size(Data,1)],'ylim',[0 size(Data,2)],'xtick',[],'ytick',[])
axis xy
if nargin==5
    set(gca,'xlim',[min(X) max(X)],'ylim',[min(Y) max(Y)],'xtick',[],'ytick',[],'yticklabel',[]);

   if k==1
      ylabel(P.Ylabel);
      set(gca,'ytick',P.Ytick,'yticklabel',P.Yticklabel);
      
      else
      set(gca,'ytick',P.Ytick,'yticklabel',[]);
   end
   
   if k>floor(size(Data,3)/2)&&k<=ceil(size(Data,3)/2)
      xlabel(P.Xlabel);

   end
   
   
%       set(gca,'ytick',P.Ytick,'yticklabel',P.Yticklabel);
      set(gca,'xtick',P.Xtick,'xticklabel',P.Xticklabel);
      set(gca,'xlim',[min(P.Xtick) max(P.Xtick)],'xticklabel',P.Xticklabel,'box','off','clim',P.Clim);

      if isfield(P,'CbarYLabel')
          if k==round(size(Data,3)/2)
      xlabel(P.Xlabel)
          end
      B=colorbar;
      set(B,'position',[1-xRight*4/5 yBelow+yWidth/3 xRight/8 yWidth/3],'xtick',[],'ytick',P.Clim)
      ylabel(B,P.CbarYLabel);
      end
      
      if isfield(P,'CbarYLabel')
          if k==round(size(Data,3)/2)
      xlabel(P.Xlabel)
          end
      B=colorbar;
      set(B,'position',[1-xRight*4/5 yBelow+yWidth/3 xRight/8 yWidth/3],'xtick',[],'ytick',P.Clim)
      ylabel(B,P.CbarYLabel);
      end
      
   if isfield(P,'ColText')
       if iscell(P.ColText)
          text(max(P.Xlim),max(P.Ylim),P.ColText{k},'horizontalalignment','right','verticalalignment','bottom','fontsize',6);
       elseif isnumeric(P.ColText)
          text(max(P.Xlim),max(P.Ylim),num2str(P.ColText(k)),'horizontalalignment','right','verticalalignment','bottom','fontsize',6);
       else
       end
   end

      
      
      
else
%     set(gca,'xlim',[min(X) max(X)],'ylim',[min(Y) max(Y)],'xtick',[],'ytick',[],'yticklabel',[],'clim',[0 max(max(max(Data)))]);
%     set(gca,'xlim',[min(X) max(X)],'ylim',[min(Y) max(Y)],'xtick',[],'ytick',[],'yticklabel',[],'clim',[0 max(max(max(Data)))]);

end

% set(gca,'visible','off')
end
% a=colorbar;
% set(a,'xtick',[],'ytick',-1:0.5:1,'yticklabel',[],'position',[1-xRight+0.02 yBelow+yWidth/4 0.01 yWidth/2],'box','on');
% colormap(cmap)
% axis tight square
% set(gca, 'YDir','reverse', 'ZLim',[1 size(Data,3)])
