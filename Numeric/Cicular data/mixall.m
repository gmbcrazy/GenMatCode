function [Cicular,Timestamps,Ref_TS]=mixall(data)
%data is a struct data that we need data.Data and data.Timestamps
%this function is to make data of several files into one
cic_end=length(data);
Cicular=[];
Timestamps=[];
% Ref_TS=[];
add_time=0;
for i=1:cic_end
    Cicular=[Cicular,data(i).Data];
%     Ref_TS=[Ref_TS,data(i).RefTimestamps+add_time];
    Timestamps=[Timestamps;(data(i).Timestamps+add_time)];
    add_time=add_time+data(i).TimeSpan;

end
