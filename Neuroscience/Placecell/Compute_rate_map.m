function [map, aMap, xAxis, yAxis, aRowAxis, aColAxis, maxPlotRate, posPDF]=Compute_rate_map(ts,x,y,t,xStart,yStart,xEnd,yEnd,p,i)

% Calculate the spike positions
[spkx,spky,spkInd] = spikePos(ts,x,y,t);

xLength = xEnd-xStart;
yLength = yEnd-yStart;

%FOR ADAPTIVE SMOOTHING
shape(1)=2;% because our arena is a cylinder
%Define Arena center coordinates % Julie 07.11.2012
center_arena_x = xEnd-(xLength/2);
center_arena_y = yEnd-(yLength/2);
shape(2)=50;
% OR  Julie 07.11.2012
% shape(2)= (xLength+yLength)/2
% arena_diameter_x=nanmax(x)-nanmin(x);
% arena_diameter_y=nanmax(y)-nanmin(y);
% shape(2)= max(arena_diameter_x, arena_diameter_y);

% PLOT PATH WITH SPIKES
%figure;
subplot(3,5,5+i);%  Julie12.09.2012
%This 3D plot is required to correctly plot the spkikes onto the path with
% the mode "opengl neverselect" (needed for NaN transparency  with  imagesc)
z=ones(size(x,1),1);
plot3(x, y,z,'k','LineWidth',p.pathLineWidth)
view ([0 0 1])
hold on
spkz=2*ones(size(spkx,1),1);
plot3(spkx, spky,spkz,'.r','markerSize',p.spikeDotSize)
set(gca, 'XLim',[xStart xEnd]);
set(gca, 'YLim',[yStart yEnd]);
set(gca, 'XTick', [],'YTick', [])
box on
%hold off
%title('Spikes');%  Julie12.09.2012
axis square;


% Calculate the rate map
[map, rawMap, xAxis, yAxis] = rateMap(x,y,spkx,spky,p.binWidth,...
                        p.binWidth,xStart,yStart,xEnd,yEnd,p.sampleTime, p);
                          
% attention, calcul pour l'adaptive smoothing
% xStart = nanmin(x);
% yStart = nanmin(y);

% Calculate rate map with adaptive smoothing
[aMap, posPDF, aRowAxis, aColAxis]  = ratemapAdaptiveSmoothing(x, y, spkx, spky,...
                       xStart,yStart,xEnd,yEnd, p.sampleTime,...
                                p, shape, center_arena_x, center_arena_y);

% Plot the rate map
if p.maxPlotRate == 0
    maxPlotRate = nanmax(nanmax(map));
else
    maxPlotRate = p.maxPlotRate;
end


% Gaussian boxcar template 5 x 5
function box = boxcarTemplate2D()

% Gaussian boxcar template
box = [0.0025 0.0125 0.0200 0.0125 0.0025;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0200 0.1000 0.1600 0.1000 0.0200;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0025 0.0125 0.0200 0.0125 0.0025;];

box = single(box);
   

