minX = [];
minY = [];
maxX = [];
maxY = [];
for i=1:5
    file_name1=[mouse_date '_s' num2str(firstsession_nb+(i-1)) 'track.txt'];
    [x,y,t] = ExtractTrajectory(file_name1);
    %figure, plot(x,y);
    minX = [minX min(x)];
    minY = [minY min(y)];
    maxX = [maxX max(x)];
    maxY = [maxY max(y)];

end
xStart = min(minX);
yStart = min(minY);
xEnd = max(maxX);
yEnd = max(maxY);

save xyLimits  xStart yStart xEnd yEnd