function Timestamps=mixall_ts(data)
%data is a struct data that we need data.final and data.final
%this function is to make data of several files into one
cic_end=length(data);
Timestamps=[];
add_time=0;
for i=1:cic_end
    
    Timestamps=[Timestamps;(data(i).final.Spike_origin+add_time)];
    add_time=add_time+data(i).final.TimeSpan;

end
