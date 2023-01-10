function ParamTable=ComputeMapsJu2(file_name1,file_name2,ParamTable,i)

%close all; Julie : required to build a single figure per manip

%parameters contains all the parameters of the experiment
parameters;
format bank

load xyLimits.mat
xStart = xStart - p.binWidth*3*p.smoothfactor(1);
yStart = yStart - p.binWidth*3*p.smoothfactor(2);
xEnd = xEnd + p.binWidth*3*p.smoothfactor(1);
yEnd = yEnd + p.binWidth*3*p.smoothfactor(2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        Extract Data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%file_name1 contains the position and timestamp
%of the tracked points
fid=fopen(file_name1,'r');
t=[];
x=[];
y=[];
zone=[];
while ~feof(fid)
    line=fgetl(fid);
    
    if strfind(line,'"Time"')
       %then we find the header of points
       %we read the next 2 lines 
       tab= fscanf(fid,'%i %i');
       t=[t; tab(1,1)];
       x=[x;tab(2,1)];
       y=[y;tab(end,1)];      
    end     
    
     if strfind(line,'"zone #"')
       %then we find the header of points
       %we read the next 2 lines 
       z= fscanf(fid,'%i');
       zone=[zone; z];      
    end     
    
end
fclose(fid);
%because acquisition is made in us we scale in second 
t=t*1e-6;
%conversion to centimeter
x=x*p.x_calibration;
y=y*p.y_calibration;

sampleTime=p.sampleTime;
[x,y,t,zone] = RebuildDataWaveMissingPoints(x,y,t,zone,sampleTime);

rawx=x;
rawy=y;
rawt=t;

%filename2 contains the raster
alldata=importdata(file_name2);
try
    ts=alldata.data(:,3);
catch
    ts=alldata(:,3);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        Compute occupancy Map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Remove artifacts outside tracking area
%inclusion_zone=6;
% to deal with exclusion zones Julie 2012.12.17 
inclusion_zone=5;
included_zones=[1;2;3;4;5;6;7;8];
for iz=1:length(included_zones)
    zone(zone==iz)=5;
end
%[x,y,t] = RemoveRearingArtifacts (x,y,t,zone,p.sampleTime, inclusion_zone);
[x,y] = RemoveRearingArtifacts (x, y, zone, p.sampleTime, inclusion_zone);

[x,y] = KalmanFilterTrajectory(x,y,0.04,'0.0001');

% Downd speed filter % Julie 2012.12.19
[x,y,t]=SpeedThreshold(x,y,t,p.lowSpeedThreshold,p.highSpeedThreshold);



% save the raw and processed data
Msavefile=[file_name2(1:(end-4)) '.mat'];
save (Msavefile, 'x', 'y', 't', 'ts','rawx', 'rawy','rawt');

%%%%
cmap = getCmap;%Julie 12.09.2012 
set(gcf,'Color',[1 1 1]);
positionVector=[10 50 1200 700];%added Julie23.10.2012
set(gcf,'position',positionVector);

%first we compute the occupancy map
[occ_map, rawMap, xAxis, yAxis]=Occupancy_map(x,y,xStart,yStart,xEnd,yEnd,p);
%save([file_name1(1:(end-4)) '_explo.txt'], 'occ_map', '-ascii');
maxPlotOcc = p.maxPlotOcc;
drawOccupancyMap(occ_map, xAxis, yAxis, cmap,i,maxPlotOcc,p)

hdDir = [];
splitDataArray = dataSplit(x, y, t, hdDir);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        Compute and display rate Map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[map, aMap, xAxis, yAxis, aRowAxis, aColAxis, maxPlotRate, posPDF]=Compute_rate_map(ts,x,y,t,xStart,yStart,xEnd,yEnd,p,i);

map_filename=[file_name2(1:(end-4)) '_map' num2str(i) '.txt' ];
save(map_filename, 'map', '-ascii');   

%To display adaptive filtered map (EN COURS)which has been calculated in
%the fct 'Compute_rate_map'
% aMap=map;
% drawAdaptativeRateMap(aMap, xAxis, yAxis, cmap, maxPlotRate);

drawGlobalRateMap(map, xAxis, yAxis, cmap, maxPlotRate,i,p);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        find place field and display  Map
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nFieldsA,fieldProp,fieldBinsA]=Compute_placefield_map(map,p,xAxis, yAxis);

% nFieldsA : nb of place fields (we don't care about the letter A)
% fieldProp : structure containing place field properties (center of mass,
% size in bins, average, peak)
% fieldBinsA : cell array containing the coordinates vectors of the pixels
% in the different place fileds

%Save the parameters value in ParamTable  Julie121107
if (size(fieldProp,1))==0
    ParamTable{1,i}=NaN;
    ParamTable{2,i}=NaN;
    ParamTable{3,i}=NaN;
    ParamTable{4,i}=NaN;
    ParamTable{5,i}=NaN;
elseif (size(fieldProp,1))==1
    ParamTable{1,i}=fieldProp(1,1).x;
    ParamTable{2,i}=fieldProp(1,1).y;
    ParamTable{3,i}=fieldProp(1,1).avgRate;
    ParamTable{4,i}=fieldProp(1,1).peakRate;
    ParamTable{5,i}=fieldProp(1,1).size;
else
    % if there are several field, we deal with the first one (max firing
    % rate)
    % NEED TO CARE ABOUT THE OTHER ONES....
    ParamTable{1,i}=fieldProp(1,1).x;
    ParamTable{2,i}=fieldProp(1,1).y;
    ParamTable{3,i}=fieldProp(1,1).avgRate;
    ParamTable{4,i}=fieldProp(1,1).peakRate;
    ParamTable{5,i}=fieldProp(1,1).size;
end

% choice1 = questdlg(['We found ' num2str(nFieldsA) ' place field display them ?'],...
%             'Yes', ...
%             'No');
%         
% switch choice1
%     case 'Yes'
%         %we plot the    
%         for ii = 1:nFieldsA
%         
%             choice = questdlg(['Shall we display place field number' num2str(ii)  ' ?'], ...
%                 'Yes', ...
%                 'No');
%             % Handle response
%             switch choice
%                 case 'Yes'
%                     drawRateMap(map, xAxis, yAxis, cmap, maxPlotRate,fieldProp(ii),p);
%                     % Adjust axis to the image format
%                     %axis('image')
%                     title(['Rate Map for placefield number' num2str(ii)...
%                         ', Peak=' num2str(fieldProp(ii).peakRate)...
%                         ' Hz, Avg Rate=' num2str(fieldProp(ii).avgRate) ' Hz']);
% 
%                     % Make a plot of the placefields
%                     hold on
%                     rowBins = fieldBinsA{ii,1};
%                     colBins = fieldBinsA{ii,2};
%                     %original plot
%                     %plot(xAxis(colBins)+p.binWidth/2,yAxis(rowBins)+p.binWidth/2,'w.');
%                     plot(xAxis(colBins),yAxis(rowBins),'w.');  
%                     %plot(colBins,rowBins,'w.');
%                     hold off
%                 case 'No'
%                     break;
%             end
%         end
%     case 'No'
%     
% end
% 
%     

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        Compute parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

boxType=2; % 2 = cylinder, 1 = box 
radius=50; % radius of the boxType in centimeter
% coverage = boxCoverage(x, y, p.binWidth, boxType, radius / 2); 2 important bugs 
coverage = boxCoverage2(x, y, p.binWidth, boxType, radius / 2);% Julie 25.10.2012
%coverage = boxCoverage3(x, y, p.binWidth, boxType, radius / 2);
ParamTable{6,i}=coverage;

%z_aMap = fieldcohere(aMap);
z = fieldcohere(map); %Julie 24.10.2012
ParamTable{7,i}=z;

%[information,sparsity,selectivity] = mapstat(aMap,posPDF); % cela fonctionne Julie 07.11.2012
posPDF=occ_map./nanmax(nanmax(occ_map));% Julie 08.11.2012
[information,sparsity,selectivity] = mapstat(map,posPDF);% Julie 08.11.2012

ParamTable{8,i}=information;
ParamTable{9,i}=sparsity;
ParamTable{10,i}=selectivity;

[spatialStability] = stability(splitDataArray, x, y, t, ts, p);
ParamTable{11,i}=spatialStability(1);
ParamTable{12,i}=spatialStability(2);

%information_rate = spatialInformationRate(aMap, posPDF); % Julie 07.11.2012
information_rate = spatialInformationRate(map, posPDF);%Julie 08.11.2012

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        Display information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% text=strvcat(['Coverage = ' num2str(coverage) ' %'],...
%       ['Field coherence = ' num2str(z)],...
%       ['Spatial information = ' num2str(information)],...
%       ['Sparsity = ' num2str(sparsity)],...
%       ['Selectivity = ' num2str(selectivity)],...
%       ['Spatial information rate =' num2str(information_rate)]);
%   
% msgbox(text); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%        Save information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TableName=[file_name2(1:(end-4)) '.xls'];
% xlswrite(TableName, ParamTable);
  
function drawOccupancyMap(occ_map, xAxis, yAxis, cmap,i,maxPlotOcc,p)

peakOcc = max(nanmax(occ_map));
[numRows,numCols] = size(occ_map);

subplot(3,5,i); %added by Julie 23.10.2012

h=imagesc(xAxis,yAxis,occ_map);
set(h,'alphadata',~isnan(occ_map))

%colormap('bone');
colormap('hot');
% Impose or not color axis % Julie 11.10.2012
if maxPlotOcc == 0
    caxis([0 ceil(peakOcc)]);
else
    caxis([0 maxPlotOcc]);
end
color_max=caxis;
freezeColors;
h=colorbar('position',[0.07   0.71    0.010    0.22]);% added Julie11.10.2012
cbfreeze(h)
% set(gca, 'XLim',[0 size(occ_map,2)])
% set(gca, 'YLim',[0 size(occ_map,1)])
set(gca, 'XLim',[(xAxis(1)-p.binWidth) xAxis(end)+p.binWidth])
set(gca, 'YLim',[(yAxis(1)-p.binWidth) yAxis(end)+p.binWidth])
set(gca, 'XTick', [],'YTick', [])
%grid on
set(gca, 'Box','on');
axis square
%title('Occupancy Map')
%title(['Occ max ' sprintf('%.0f',color_max(2))]);
title(['Occ max ' sprintf('%.0f',peakOcc)]);

%text(0,0,['S' num2str(i)],'Units','normalized','Position', [-0.5 1.15], 'FontSize',25);
text(0,0,['S' num2str(i)],'Units','normalized','Position', [-0.3 1.20], 'FontSize',25);% Julie 11.10.2012
hold on %added by Julie 12.09.2012


function drawRateMap(map, xAxis, yAxis, cmap, maxPlotRate,field_properties,p)

map(map>maxPlotRate) = maxPlotRate;

% Size of rate map
[numRows,numCols] = size(map);

% % Allocate memory for the image
% plotMap = ones(numRows,numCols,3);

% Peak rate of the map
peakRate = max(nanmax(map));

figure;
set(gca, 'XLim',[(xAxis(1)-p.binWidth) xAxis(end)+p.binWidth])
set(gca, 'YLim',[(yAxis(1)-p.binWidth) yAxis(end)+p.binWidth])
h=imagesc(xAxis,yAxis,map);
set(h,'alphadata',~isnan(map))
colorbar
caxis([0 peakRate]);
title('Rate Map');



function drawGlobalRateMap(map, xAxis, yAxis, cmap, maxPlotRate,i,p)

peakRate_to_plot = max(nanmax(map));% Julie24.10.2012
map(map>maxPlotRate) = maxPlotRate;

% Size of rate map
[numRows,numCols] = size(map);

% % Peak rate of the map
peakRate = max(nanmax(map));
% 
map_temp=map;
%we remove the nan 
map_temp(isnan(map_temp))=[];
avgRate= mean(map_temp(:));

subplot(3,5,10+i);%Julie11.10.2012

h=imagesc(xAxis,yAxis,map);
set(h,'alphadata',~isnan(map))
colormap('jet');
% set(gca, 'XLim',[0 size(map,2)])
% set(gca, 'YLim',[0 size(map,1)])
set(gca, 'XLim',[(xAxis(1)-p.binWidth) xAxis(end)+p.binWidth])
set(gca, 'YLim',[(yAxis(1)-p.binWidth) yAxis(end)+p.binWidth])
set(gca, 'XTick', [],'YTick', [])
set(gca, 'Box','on');
colorbar('position',[0.07    0.11    0.010    0.22]); % Julie 11.10.2012
%impose or not color axis % julie 11.10.2012
if maxPlotRate == 0
    caxis([0 ceil(peakRate)]);
else
    caxis([0 maxPlotRate]);
end
%caxis([0 peakRate]);
axis square
%title(['Peak=' num2str(peakRate) ' Hz, Avg Rate=' num2str(avgRate) ' Hz']);
title(['Peak ' sprintf('%.2f',peakRate_to_plot) ' Hz, Avg ' sprintf('%.2f',avgRate) ' Hz']);


function drawAdaptativeRateMap(map, xAxis,yAxis, ~, cmap, maxPlotRate)

map(map>maxPlotRate) = maxPlotRate;

% Size of rate map
[numRows,numCols] = size(map);

% Peak rate of the map
peakRate = max(nanmax(map));

map_temp=map;
%we remove the nan 
map_temp(isnan(map_temp))=[];
avgRate= mean(map_temp(:));

figure;

h=imagesc(xAxis,yAxis,map);
set(h,'alphadata',~isnan(map))

colorbar
caxis([0 peakRate]);
title(['Adaptative rate map, Peak=' num2str(peakRate) ' Hz, Avg Rate=' num2str(avgRate) ' Hz']);


function cmap = getCmap()

% Set the number of colors to scale the image with
numLevels = 256;

% set the colormap using the jet color map (The jet colormap is associated 
% with an astrophysical fluid jet simulation from the National Center for 
% Supercomputer Applications.)
cmap = colormap(jet(numLevels));