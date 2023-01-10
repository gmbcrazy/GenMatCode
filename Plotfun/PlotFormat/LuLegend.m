function LuLegend(PosXY,PlotStyle,Labels,Color,varargin)

%%%%PlotStyle:0 = line;1 = dot;2 = circle;
%%%%PosXY(1,:): x coordinate;PosXY(2,:): y coordinate; coordinate of plot
%%%%PosXY(3,:): x coordinate;PosXY(4,:): y coordinate; coordinate of labels
if nargin==5
   fontsize=varargin{1};
else
   fontsize=6;
end
if size(PosXY,1)==2
   PosXY(3,:)=PosXY(1,:);
   PosXY(4,:)=PosXY(2,:);
end

hold on;
if PlotStyle==0
   for i=1:length(Labels)
       plot([PosXY(1,i) PosXY(3,i)],[PosXY(2,i) PosXY(2,i)],'-','color',Color(i,:),'linewidth',1.5);
   end
elseif PlotStyle==1
   for i=1:length(Labels)
       plot(PosXY(1,i),PosXY(2,i),'.','color',Color(i,:),'linewidth',1.5);
   end
else
   for i=1:length(Labels)
       plot(PosXY(1,i),PosXY(2,i),'o','color',Color(i,:),'linewidth',1.5);
   end

end
   for i=1:length(Labels)
       text(PosXY(3,i),PosXY(4,i),Labels{i},'horizontalalignment','left','verticalalignment','middle','fontsize',fontsize);
   end


