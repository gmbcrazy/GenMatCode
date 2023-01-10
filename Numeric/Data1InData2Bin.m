function [Data1Bin,Data1BinAve,Edges]=Data1InData2Bin(Data1,Data2,Time,Data2Edge,Timerange)

%%%%%%%%%Data1 and Data2 are time series sharing the same sampling-time variable Time.
%%%%%%%%%Timerange is a variable define analysis period, could be multi
%%%%%%%%%time segments. Timerange(1,j) is starting time of jth period while Time(2, j)is the ending time.
%%%%%%%%%Data2Edge defines the bins seperate the Data2, consider help information in discretize.m in matlab.

%%%%%%%%%Output Data1BinAve would be the mean value of Data1 within specfic
%%%%%%%%%bin defined in Data2.

%%Example
%%[~,SpeedMap,Edges]=Data1InData2Bin(Speed,Position,SamplingTime,SpatialBin,Timerange);
%%


[~,Index1]=TsInTimerange(Time,Timerange);
Data1=Data1(Index1);
Data2=Data2(Index1);


[BinI,Edges] = discretize(Data2,Data2Edge);


for i=1:length(Edges)
    Index=find(BinI==i);
    if ~isempty(Index)    
       Data1Bin{i}=Data1(Index);
       Data1BinAve(1,i)=nanmean(Data1Bin{i});

       Data1Bin{i}(isnan(Data1Bin{i}))=[];
    else
       Data1Bin{i}=[];
       Data1BinAve(1,i)=nan;
       
    end
end

