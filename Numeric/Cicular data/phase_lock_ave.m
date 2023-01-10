function [pefer,std_value,ste_value]=phase_lock_ave(data)

%%%%%%%%%the input parameter data is a vector of phase like [230 110 115 226 350];


angle_data=(data-180)*pi/180;
or_data=exp(angle_data*i);
pefer_data=mean(or_data);
R=abs(pefer_data);
pefer=(angle(pefer_data)+pi)*180/pi;
std_value=abs(data-pefer);
index_invalid=find(std_value>180);
std_value(index_invalid)=360-std_value(index_invalid);
std_value=(sum(std_value.*std_value)/length(data))^0.5;

ste_value=std_value/(length(data)^0.5);

