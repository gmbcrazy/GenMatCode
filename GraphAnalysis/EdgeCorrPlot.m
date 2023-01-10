function EdgeCorrPlot(PathFileName,EdgeIndex,colorMap,varargin)

if ~iscell(PathFileName)
load(PathFileName);
PZ=PZ_wei(EdgeIndex,EdgeIndex);
NZ=NZ_wei(EdgeIndex,EdgeIndex);
else
PZ=PathFileName{1};
NZ=PathFileName{2};
end

if nargin==4
   group=varargin{1};
else
    group=[];
end

figure;
subplot('position',[0.1 0.05 0.4 0.9])
imagesc(1:length(EdgeIndex),1:length(EdgeIndex),PZ);


if ~isempty(group)
    hold on;
    xvalue=-16;
%     xvalue=(-[1:length(group)]);
   for i=1:length(group)
       temp=group(i).Index;
       [~,i1,~]=intersect(EdgeIndex,group(i).Index);
       for j=1:length(i1)
           
           barplotLu(xvalue,i1(j)-1,16,1,group(i).color,0.3);
%            plot(xvalue(i),i1(j),'color',group(i).color,'linestyle','none','Marker',group(i).marker,'markersize',2);
           %            plot([xvalue(i) xvalue(i)],[i1(j)-1,i1(j)],'color',group(i).color,'linestyle','none','Marker',group(i).marker,'markersize',6);

%            plot([xvalue(i) xvalue(i)],[i1(j)-1,i1(j)],'color',group(i).color,'linestyle','none','Marker',group(i).marker,'markersize',6);
       end
   end

end
   set(gca,'clim',[-0.8 0.8],'yticklabel',{},'xtick',[],'ytick',[],'xlim',[-length(group)*8 length(EdgeIndex)],'ycolor',[0.99 0.99 0.99],'xcolor',[0.99 0.99 0.99]);axis xy

% for i=1:length(EdgeNeed)
%    b=text(-15,i,EdgeNeed{i});hold on
%    set(b,'fontsize',4)
% end
colormap(colorMap)

subplot('position',[0.55 0.05 0.4 0.9])
imagesc(1:length(EdgeIndex),1:length(EdgeIndex),NZ);
   set(gca,'clim',[-0.8 0.8],'yticklabel',{},'xtick',[],'ytick',[],'xlim',[-length(group)*8 length(EdgeIndex)],'ycolor',[0.99 0.99 0.99],'xcolor',[0.99 0.99 0.99]);axis xy
% for i=1:length(EdgeNeed)
%    b=text(-15,i,EdgeNeed{i});hold on
%    set(b,'fontsize',4)
% end
colormap(colorMap)
b=colorbar;set(b,'position',[0.96 0.05 0.01 0.9],'ytick',[-1:0.5:1]);

