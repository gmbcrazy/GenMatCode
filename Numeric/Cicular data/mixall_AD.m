function [Power,Theta_phase]=mixall_AD(data)
%data is a struct data that we need data.Data and data.Timestamps
%this function is to make data of several files into one
cic_end=length(data);
Power=[];
Timestamps=[];
Theta_phase=[];
add_time=0;
for i=1:cic_end
    Power=[Power,data(i).Data'];
    Theta_phase=[Theta_phase,data(i).Theta_phase'];
    add_time=add_time+data(i).TimeSpan;

end
