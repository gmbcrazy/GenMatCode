function [x,y,t] = ExtractTrajectory(file_name1,i)

%parameters contains all the parameters of the experiment
parameters;
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
t=t*1e-6;

% Remove artifacts outside tracking area
inclusion_zone=6;
[x,y] = RemoveRearingArtifacts (x,y,zone,p.sampleTime, inclusion_zone);


%condition marseille
%remove artefacts outside tracking area
%conversion to centimeter
x=x*p.x_calibration;
y=y*p.y_calibration;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%
%%%%        Compute occupancy Map
%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[x, y] = KalmanFilterTrajectory(x,y,0.04,'0.01');

%because acquisition is made in us 
%we scale in second 

Msavefile=[file_name1(1:(end-9)) '.mat'];
save (Msavefile, 'x', 'y', 't');
