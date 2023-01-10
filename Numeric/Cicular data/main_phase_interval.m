function [mean_std,data_skewness,data_kurtosis]=main_phase_interval(data,hist_num,main_num)


temp_data=data;
[m,n]=hist(temp_data,hist_num);

for i=1:main_num
    [temp_n,temp_m(i)]=max(m);
    m(temp_m(i))=-1;
end
temp_m=sort(temp_m); 
bin_width=360/hist_num;

[invalid,invalid_position]=max(diff(temp_m));
if invalid<floor(hist_num/3)
    main_data=[];
    for i=1:length(temp_m)
        main_data=[main_data,temp_data(find(temp_data>=bin_width*(temp_m(i)-1)&temp_data<temp_m(i)*bin_width))];
    end
else
    main_data=[];
    for i=1:invalid_position
        main_data=[main_data,temp_data(find(temp_data>=bin_width*(temp_m(i)-1)&temp_data<temp_m(i)*bin_width))];
    end
    
    main_data=main_data+360;
    for i=(invalid_position+1):length(temp_m)
        main_data=[main_data,temp_data(find(temp_data>=bin_width*(temp_m(i)-1)&temp_data<temp_m(i)*bin_width))];
    end
end


interval(1)=mean(main_data)-180;
interval(2)=mean(main_data)+180;


data_needed=[temp_data,temp_data+360];
if interval(1)>0;
    data_needed(find(interval(1)>data_needed|data_needed>=interval(2)))=[];
else
    interval=interval+360;
    data_needed(find(interval(1)>data_needed|data_needed>=interval(2)))=[];
end
data_skewness=skewness(data_needed);
data_kurtosis=kurtosis(data_needed);
mean_std(1)=mean(data_needed);
mean_std(2)=std(data_needed);