function [Cicular,Timestamps]=mixall_common(data)
%data is a struct data that we need data.final and data.final
%this function is to make data of several files into one
cic_end=length(data);
Cicular=[];
Timestamps=[];
add_time=0;
for i=1:cic_end
    Cicular=[Cicular,data(i).final.Data];
    
    Timestamps=[Timestamps;(data(i).final.Timestamps+add_time)];
    add_time=add_time+data(i).final.TimeSpan;

end
