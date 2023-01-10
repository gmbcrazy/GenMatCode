function MultiMatrix2DMatPlot(Data,varargin)
%%%%%%%%Data is 3D matrix, each sample is Data(:,:,i)

% % xLeft=0.08;
% % xInt=0.02;
% % xRight=0.09;
% % xNum=max(PlotP);
% % xWidth=(1-xLeft-xRight-xInt*(xNum-1))/xNum;
% % 
% % yAbove=0.03;
% % % yInt=0.02;
% % yBelow=0.15;
% % % yNum=size(Data,3);
% % yWidth=(1-yAbove-yBelow);
% % 

if nargin==3
   X=varargin{1};
   Y=varargin{2};
   
   
elseif nargin==4
   X=varargin{1};
   Y=varargin{2};
   P=varargin{3};
    
else
   X=1:size(Data(:,:,1,1),1);
   Y=1:size(Data(:,:,1,1),2);
 
end
%# plot each slice as a texture-mapped surface (stacked along the Z-dimension)
PMat=size(Data);


for i=1:size(Data,3)

for k=1:size(Data,4)
    
    if sum(sum(isnan(Data(:,:,i,k))))==PMat(1)*PMat(2);
       continue;
    end
    
    if nargin==3
   P.xLeft=0.06;
   P.xRight=0.02;
   P.yTop=0.02;
   P.yBottom=0.06;
   P.xInt=0.02;
   P.yInt=0.02;
    end
    subplotLU(PMat(3),PMat(4),i,k,P);
%     else
%     subplotLU(PMat(3),PMat(4),i,k,P)
%     end

%     subplot('position',[xLeft+(PlotP(k)-1)*(xWidth+xInt),yBelow,xWidth,yWidth])
%     surface('XData',floor(Z.*XPlot(k)*size(Z,1)/2), 'YData',X, 'ZData',Y, ...
%         'CData',squeeze(Data(:,:,k)), 'CDataMapping','direct', ...
%         'EdgeColor','none', 'FaceColor','texturemap');
    imagesc(X,Y,squeeze(Data(:,:,i,k))'); 
%     box off
% set(gca,'xlim',[0 size(Data,1)],'ylim',[0 size(Data,2)],'xtick',[],'ytick',[])
axis xy
if nargin==4
    set(gca,'xlim',[min(P.Xlim) max(P.Xlim)],'ylim',[min(P.Ylim) max(P.Ylim)],'xtick',P.Xtick,'ytick',P.Ytick,'xticklabel',[],'yticklabel',[],'box','off','clim',P.Clim,'visible',true);

   if isfield(P,'ColText')
   if k==1
      text(max(P.Xlim),max(P.Ylim),num2str(P.ColText{k}),'horizontalalignment','right','verticalalignment','bottom','fontsize',8); 
       
   end
   end
   if isfield(P,'RowText')
   if k==1
      text(min(P.Xlim),max(P.Ylim),num2str(P.RowText{i}),'horizontalalignment','right','verticalalignment','bottom','fontsize',8) 
       
   end
   end

   
    
   if k==1&&i==round(size(Data,3)/2)
      ylabel(P.Ylabel);
      set(gca,'ytick',P.Ytick,'yticklabel',P.Yticklabel);
   elseif k==1&&i~=round(size(Data,3)/2)
      set(gca,'ytick',P.Ytick,'yticklabel',P.Yticklabel);

   else
%       set(gca,'ytick',P.Ytick,'yticklabel',[]);

   end
   
   
      if k==round(size(Data,4)/2)&&i==size(Data,3)
         xlabel(P.Xlabel);
         set(gca,'xtick',P.Xtick,'xticklabel',P.Xticklabel);
      elseif k~=round(size(Data,4)/2)&&i==size(Data,3)
         set(gca,'xtick',P.Xtick,'xticklabel',P.Xticklabel);
      else
          
      end
%       if isfield(P,'CbarYLabel')
%           if k==round(size(Data,3)/2)
%       xlabel(P.Xlabel)
%           end
%       B=colorbar;
%       set(B,'position',[1-xRight*4/5 yBelow+yWidth/3 xRight/8 yWidth/3],'xtick',[],'ytick',P.Clim)
%       ylabel(B,P.CbarYLabel);
%       end
      
      if isfield(P,'CbarYLabel')
      B=colorbar;
      colNum=size(Data,4);
      rowNum=size(Data,3);
      xWidth=(1-P.xLeft-P.xRight-P.xInt*(colNum-1))/colNum;
      yWidth=(1-P.yTop-P.yBottom-P.yInt*(rowNum-1))/rowNum;

      set(B,'position',[1-P.xRight*4/5 P.yBottom+yWidth/3 P.xRight/8 yWidth/3],'xtick',[],'ytick',P.Clim);
      ylabel(B,P.CbarYLabel);
      end

   if isfield(P,'GravityCenter')
      hold on;
      plot(P.GravityCenter(i,k,1),P.GravityCenter(i,k,2),'^','color',P.GravityColor(k,:),'MarkerFaceColor',P.GravityColor(k,:),'MarkerSize',4);
   end


      
      
else
%     set(gca,'xlim',[min(X) max(X)],'ylim',[min(Y) max(Y)],'xtick',[],'ytick',[],'yticklabel',[],'clim',[0 max(max(max(Data)))]);
%     set(gca,'xlim',[min(X) max(X)],'ylim',[min(Y) max(Y)],'xtick',[],'ytick',[],'yticklabel',[],'clim',[0 max(max(max(Data)))]);
      set(gca,'ytick',[],'yticklabel',[],'xticklabel',[]);

end

% set(gca,'visible','off')
end
end
% colormap(jet)
% a=colorbar;
% set(a,'xtick',[],'ytick',-1:0.5:1,'yticklabel',[],'position',[1-xRight+0.02 yBelow+yWidth/4 0.01 yWidth/2],'box','on');
% colormap(cmap)
% axis tight square
% set(gca, 'YDir','reverse', 'ZLim',[1 size(Data,3)])
