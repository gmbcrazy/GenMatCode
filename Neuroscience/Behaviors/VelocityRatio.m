function [RatioAll RatioAverage]=VelocityRatio(raster,rastertime,Range)
%Range(1,:)=[-1.5 -1];
%Range(2,:)=[-1 -0.5];

if length(raster(:,1))>1
index1=find(rastertime>Range(1,1)&rastertime<Range(1,2));
index2=find(rastertime>Range(2,1)&rastertime<Range(2,2));

RatioAll=(mean(raster(:,index1)')-mean(raster(:,index2)'))./mean(raster(:,index2)');
RatioAverage=(mean(mean(raster(:,index1)))-mean(mean(raster(:,index2))))/mean(mean(raster(:,index2)));
elseif length(raster(:,1))==1
RatioAll=(mean(raster(:,index1))-mean(raster(:,index2)))/mean(raster(:,index2));
RatioAverage=RatioAll;
else
RatioAll=[];
RatioAverage=[];
end