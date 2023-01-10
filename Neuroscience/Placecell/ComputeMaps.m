function ComputeMaps(file_name1,file_name2)

close all;
%parameters contains all the parameters of the experiment
parameters;

%file_name1 contains the position and timestamp
%of the tracked points
fid=fopen(file_name1,'r');
t=[];
x=[];
y=[];

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
end

% %we start x from 0;
% x=x-min(x);
% y=y-min(y);

fclose(fid);

%filename2 contains the raster
alldata=importdata(file_name2);
try
    ts=alldata.data(:,3);
catch
    ts=alldata(:,3);
end

%condition marseille
%remove artefacts outside tracking area
%conversion to centimeter
x=x*p.x_calibration;
y=y*p.y_calibration;
% 
%  i=(x<6);
%  x(i)=[];
%  y(i)=[];
%  t(i)=[];
% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%        Compute occupancy Map
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x, y] = KalmanFilterTrajectory(x,y,0.04,'0.01');

%because acquisition is made in us 
%we scale in second 
t=t*1e-6;
cmap = getCmap;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%        Compute occupancy Map
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%first we compute the occupancy map
[occ_map, xAxis, yAxis]=Occupancy_map(x,y,p);
drawOccupancyMap(occ_map, xAxis, yAxis, cmap)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%        Compute and display rate Map
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[map, aMap, xAxis, yAxis, aRowAxis, aColAxis, maxPlotRate, posPDF]=Compute_rate_map(ts,x,y,t,p);

%To display adaptive filtered map (EN COURS)which has been calculated in
%the fct 'Compute_rate_map'
% aMap=map;
% drawAdaptativeRateMap(aMap, xAxis, yAxis, cmap, maxPlotRate);

drawGlobalRateMap(map, xAxis, yAxis, cmap, maxPlotRate);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%        find place field and display  Map
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[nFieldsA,fieldProp,fieldBinsA]=Compute_placefield_map(map,p,xAxis, yAxis);

choice1 = questdlg(['We found ' num2str(nFieldsA) ' place field display them ?'],...
            'Yes', ...
            'No');
        
switch choice1
    case 'Yes'
        %we plot the    
        for ii = 1:nFieldsA
        
            choice = questdlg(['Shall we display place field number' num2str(ii)  ' ?'], ...
                'Yes', ...
                'No');
            % Handle response
            switch choice
                case 'Yes'
                    drawRateMap(map, xAxis, yAxis, cmap, maxPlotRate,fieldProp(ii));
                    % Adjust axis to the image format
                    %axis('image')
                    title(['Rate Map for placefield number' num2str(ii)...
                        ', Peak=' num2str(fieldProp(ii).peakRate)...
                        ' Hz, Avg Rate=' num2str(fieldProp(ii).avgRate) ' Hz']);

                    % Make a plot of the placefields
                    hold on
                    rowBins = fieldBinsA{ii,1};
                    colBins = fieldBinsA{ii,2};
                    %original plot
                    %plot(xAxis(colBins),yAxis(rowBins),'w.');  
                    plot(colBins,rowBins,'w.');
                    hold off
                case 'No'
                    break;
            end
        end
    case 'No'
    
end

    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%        Box coverage
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

boxType=2; % 2 = cylinder, 1 = box 
radius=50; % radius of the boxType in centimeter
coverage = boxCoverage(x, y, p.binWidth, boxType, radius / 2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%        Field coherence
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

z = fieldcohere(aMap);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%        spatial information, sparsity,
%%%%        selectivity
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[information,sparsity,selectivity] = mapstat(aMap,posPDF);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%        spatial information rate
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

information_rate = spatialInformationRate(aMap, posPDF);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%        Display information
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

text=strvcat(['Coverage = ' num2str(coverage) ' %'],...
      ['Field coherence = ' num2str(z)],...
      ['Spatial information = ' num2str(information)],...
      ['Sparsity = ' num2str(sparsity)],...
      ['Selectivity = ' num2str(selectivity)],...
      ['Spatial information rate =' num2str(information_rate)]);
  
msgbox(text); 
  
function drawOccupancyMap(occ_map, xAxis, yAxis, cmap)


% % Set the number of colors to scale the image with. This value must be the
% % same as the number of levels set in the getCmap function.
% numLevels = 256;
% 
% % Size of rate map
% [numRows,numCols] = size(map);
% 
% % Allocate memory for the image
% plotMap = ones(numRows,numCols,3);
% 
% % Peak rate of the map
% peakOcc = max(nanmax(map));
% 
% % set color of each bin scaled according to the peak rate, bins with NaN
% % will be plotted as white RGB = [1,1,1].
% for r = 1:numRows
%     for c = 1:numCols
%         if ~isnan(map(r,c))
%             % Set the color level for this bin
%             level = round((map(r,c) / peakOcc) * (numLevels-1)) + 1;
%             plotMap(r,c,:) = cmap(level,:);
%         end
%     end
% end

%%%%%%
%%% Original display
%%%%%%
% Display the image in the current figure window. (window must be created
% before calling this function
% image(xAxis,yAxis,plotMap,'CDataMapping','scaled');
% % Adjust axis to the image format
% caxis([0 ceil(peakOcc)]);
% colorbar;

peakOcc = max(nanmax(occ_map));
[numRows,numCols] = size(occ_map);
[x,y]=meshgrid (1:numCols,1:numRows);
surf(x,y,occ_map);
view([0 0 -1]);
% shading interp;
shading flat;
colorbar
caxis([0 ceil(peakOcc)]);
title('Occupancy Map')


function drawRateMap(map, xAxis, yAxis, cmap, maxPlotRate,field_properties)

map(map>maxPlotRate) = maxPlotRate;

% Set the number of colors to scale the image with. This value must be the
% same as the number of levels set in the getCmap function.
numLevels = 256;

% Size of rate map
[numRows,numCols] = size(map);

% % Allocate memory for the image
% plotMap = ones(numRows,numCols,3);

% Peak rate of the map
peakRate = max(nanmax(map));

% set color of each bin scaled according to the peak rate, bins with NaN
% will be plotted as white RGB = [1,1,1].
% for r = 1:numRows
%     for c = 1:numCols
%         if ~isnan(map(r,c))
%             % Set the color level for this bin
%             level = round((map(r,c) / peakRate) * (numLevels-1)) + 1;
%             plotMap(r,c,:) = cmap(level,:);
%         end
%     end
% end

%%%%%%
%%% Original display
%%%%%%
% figure;
% % Display the image in the current figure window. (window must be created
% % before calling this function
% % colorbar;
% image(xAxis,yAxis,plotMap,'CDataMapping','scaled');
% caxis([0 ceil(peakRate)]);
% colorbar;

% figure;
% [x,y]=meshgrid (1:numCols,1:numRows);
% rateMap=double(sum(plotMap,3));
% rateMap(rateMap==3)=NaN;
% surf(x,y,(rateMap./(max(rateMap(:))))*peakRate);
% view([0 0 -1]);
% shading interp;
% colorbar
% title('Rate Map')


figure;
[x,y]=meshgrid (1:numCols,1:numRows);
% rateMap=double(sum(plotMap,3));
% rateMap(rateMap==3)=NaN;
% [rateMap2,Cmap] = rgb2ind(plotMap,256);
% rateMap2=double(rateMap2);
% surf(x,y,(rateMap./(max(rateMap(:))))*peakRate);
surf(x,y,map);
view([0 0 -1]);
% shading interp;
shading flat;
colorbar
caxis([0 peakRate]);
title('Rate Map');



function drawGlobalRateMap(map, xAxis, yAxis, cmap, maxPlotRate)

map(map>maxPlotRate) = maxPlotRate;

% Set the number of colors to scale the image with. This value must be the
% same as the number of levels set in the getCmap function.
numLevels = 256;

% Size of rate map
[numRows,numCols] = size(map);

% % Allocate memory for the image
% plotMap = ones(numRows,numCols,3);
% 
% % Peak rate of the map
peakRate = max(nanmax(map));
% 
map_temp=map;
%we remove the nan 
map_temp(isnan(map_temp))=[];
avgRate= mean(map_temp(:));
% % set color of each bin scaled according to the peak rate, bins with NaN
% % will be plotted as white RGB = [1,1,1].
% for r = 1:numRows
%     for c = 1:numCols
%         if ~isnan(map(r,c))
%             % Set the color level for this bin
%             level = round((map(r,c) / peakRate) * (numLevels-1)) + 1;
%             plotMap(r,c,:) = cmap(level,:);
%         end
%     end
% end
% 
% %%%%%%
%%% Original display
%%%%%%
% figure;
% Display the image in the current figure window. (window must be created
% before calling this function
% image(xAxis,yAxis,plotMap,'CDataMapping','scaled');
% % colorbar('YTick',linspace(0,peakRate,6));
% % Adjust axis to the image format
% % axis image
% caxis([0 ceil(peakRate)]);
% colorbar;


figure;
[x,y]=meshgrid (1:numCols,1:numRows);
% rateMap=double(sum(plotMap,3));
% rateMap(rateMap==3)=NaN;
% [rateMap2,Cmap] = rgb2ind(plotMap,256);
% rateMap2=double(rateMap2);
% surf(x,y,(rateMap./(max(rateMap(:))))*peakRate);
surf(x,y,map);
view([0 0 -1]);
% shading interp;
shading flat;
colorbar
caxis([0 peakRate]);
title(['Global rate map, Peak=' num2str(peakRate) ' Hz, Avg Rate=' num2str(avgRate) ' Hz']);


function drawAdaptativeRateMap(map, xAxis, yAxis, cmap, maxPlotRate)

map(map>maxPlotRate) = maxPlotRate;

% Set the number of colors to scale the image with. This value must be the
% same as the number of levels set in the getCmap function.
numLevels = 256;

% Size of rate map
[numRows,numCols] = size(map);

% % Allocate memory for the image
% plotMap = ones(numRows,numCols,3);

% Peak rate of the map
peakRate = max(nanmax(map));

map_temp=map;
%we remove the nan 
map_temp(isnan(map_temp))=[];
avgRate= mean(map_temp(:));
% % set color of each bin scaled according to the peak rate, bins with NaN
% % will be plotted as white RGB = [1,1,1].
% for r = 1:numRows
%     for c = 1:numCols
%         if ~isnan(map(r,c))
%             % Set the color level for this bin
%             level = round((map(r,c) / peakRate) * (numLevels-1)) + 1;
%             plotMap(r,c,:) = cmap(level,:);
%         end
%     end
% end

%%%%%%
%%% Original display
%%%%%%
% figure;
% Display the image in the current figure window. (window must be created
% before calling this function
% image(xAxis,yAxis,plotMap,'CDataMapping','scaled');
% % colorbar('YTick',linspace(0,peakRate,6));
% % Adjust axis to the image format
% % axis image
% caxis([0 ceil(peakRate)]);
% colorbar;


% figure;
% [x,y]=meshgrid (1:numCols,1:numRows);
% rateMap=double(sum(plotMap,3));
% rateMap(rateMap==3)=NaN;
% surf(x,y,(rateMap./(max(rateMap(:))))*peakRate);
% view([0 0 -1]);
% shading interp;
% colorbar
% title(['Adaptative rate map, Peak=' num2str(peakRate) ' Hz, Avg Rate=' num2str(avgRate) ' Hz']);

figure;
[x,y]=meshgrid (1:numCols,1:numRows);
% rateMap=double(sum(plotMap,3));
% rateMap(rateMap==3)=NaN;
% [rateMap2,Cmap] = rgb2ind(plotMap,256);
% rateMap2=double(rateMap2);
% surf(x,y,(rateMap./(max(rateMap(:))))*peakRate);
surf(x,y,map);
view([0 0 -1]);
shading interp;
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