function [AngleShift, AngleCorr]=PlaceFieldAngularShift(filename1,filename2, Angle_inc)
%function PlaceFieldAngularShift(filename1,filename2, Angle_inc,p)
parameters;
load xyLimits.mat
xStart = xStart - p.binWidth*3*p.smoothfactor(1);
yStart = yStart - p.binWidth*3*p.smoothfactor(2);
xEnd = xEnd + p.binWidth*3*p.smoothfactor(1);
yEnd = yEnd + p.binWidth*3*p.smoothfactor(2);
% conversion from degrees to radians
Angle_inc = Angle_inc * 2 * pi / 360;


M=load ('481_121105_s17.mat') ;
x1=M.x;
y1=M.y;
t1=M.t;
ts1=M.ts;
[spkx1,spky1,spkInd1] = spikePos(ts1,x1,y1,t1);


[map1, rawMap, xAxis, yAxis, timeMap] = rateMap(x1,y1,spkx1,spky1,p.binWidth,p.binWidth,xStart,yStart,xEnd,yEnd,p.sampleTime,p);
% figure, h=imagesc(xAxis,yAxis,map1);
% set(h,'alphadata',~isnan(map1))


N=load ('481_121105_s18.mat') ;
x2=N.x;
y2=N.y;
t2=N.t;
ts2=N.ts;

Rot=[];
k=1;
for tAngle=0:Angle_inc:(2 * pi)
    
    figure, plot(x1,y1);
    hold on;
    
    [newX2,newY2] = rotatePath(x2,y2,tAngle);
    x_diff=min(newX2)-min(x2);
    y_diff=min(newY2)-min(y2);
    newX2=newX2-x_diff;
    newY2=newY2-y_diff;
    plot(newX2,newY2, 'r')
    
    [spkx2,spky2,spkInd2] = spikePos(ts2,newX2,newY2,t2);
    [map2, rawMap, xAxis, yAxis, timeMap] = rateMap(newX2,newY2,spkx2,spky2,p.binWidth,p.binWidth,xStart,yStart,xEnd,yEnd,p.sampleTime,p);
    R = zeroLagCorrelation(map1,map2);
    tAngle_d=tAngle/ 2 / pi * 360;
    Rot=[Rot; tAngle_d R];
    RotationTable{k,1}=tAngle_d;
    RotationTable{k,2}=R;
    k=k+1;
end
[C,I,]=max(Rot(:,2));
AngleShift=Rot(I,1);
AngleCorr=Rot(I,2);
Rotation={'Angle','Correlation'};
RotationTable=[Rotation; RotationTable];
%AngTableName=[mouse_date '_s' num2str(firstsession_nb) '_' unit_name '_ang.xls'];
% TO BE MODIFIED
AngTableName=[filename1(1:(end-4)) '_ang.xls'];
xlswrite(AngTableName, RotationTable); 

