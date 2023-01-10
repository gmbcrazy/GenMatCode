function GT_PlaceField_1DCirPlot(mapO,PlaceField,varargin)
%%%%Calcualted place fields circular linear track;

if nargin==3
   SpaBin=varargin{1};
elseif nargin==4
   SpaBin=varargin{1};
   FieldColor=varargin{2};
else   
   SpaBin=1:length(mapO);
   FieldColor=[0 0 1];

end

plot(SpaBin,mapO,'k','linewidth',0.5);
hold on;
for i=1:length(PlaceField)
    plot(SpaBin(PlaceField(i).PeakIX),mapO(PlaceField(i).PeakIX),'.','color',FieldColor);
    [maxR,maxI]=max(mapO(PlaceField(i).PeakIX));
    plot(SpaBin(PlaceField(i).PeakIX(maxI)),maxR,'r*','markersize',6);
end
hold off;

