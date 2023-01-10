function [power_all,lag_time,filterAD_all,power_AD]=Spec_theta(path_filename,AD_name,reference_name,timerange,fre_range,band_width,band_step,half_show_range)

[raw_AD,time]=rate_historam(path_filename,AD_name,timerange,0.001,0.001);
[ref,time]=rate_historam(path_filename,reference_name,timerange,0.001,0.001);

% plot(raw_AD(1:3000));
% hold on;plot(ref(1:3000),'r')
freq_need=fre_range(1):band_step:fre_range(2);
hf_num=round(half_show_range/0.001);
all_num=hf_num*2+1;


ref_index=find(ref>0);
start_index=ref_index-hf_num;
over_index=ref_index+hf_num;

invalid1=find(start_index<=0);
invalid2=find(over_index>length(raw_AD));
invalid=union(invalid1,invalid2);

start_index(invalid)=[];
over_index(invalid)=[];


for i=1:(length(freq_need)-1)
    tic
lowf=freq_need(i);
highf=freq_need(i)+band_width;
freq=1000;
% fz=freq/2;
% [b,a]=ellip(4,3,50,[lowf/fz highf/fz]);
% [b,a]=ellip(4,3,50,[lowf/fz highf/fz]);
% 
% filterAD=filtfilt(b,a,raw_AD);


% [filterAD,filtwts] = eegfilt(raw_AD,freq,lowf,highf,0,max(3*fix(freq/lowf),24),0);
[filterAD,filtwts] = eegfilt(raw_AD,freq,lowf,highf,0,100,0);

% filterAD=zscore(filterAD);
% filterAD_all(i,:)=filterAD';
% 
% analytic_sf=hilbert(filterAD);
% power_AD(i,:)=abs(analytic_sf)'.^2;


filterAD=filterAD;
filterAD_all(i,:)=filterAD;

analytic_sf=hilbert(filterAD);
power_AD(i,:)=abs(analytic_sf).^2;

toc
end

power_all=zeros(length(freq_need)-1,all_num);
for i=1:length(start_index)
    power_all=power_all+power_AD(:,start_index(i):over_index(i));  
end
power_all=power_all/length(start_index);
lag_time=((1:all_num)-hf_num)*0.001;

