function [y,time]=ratehistogram_TS(data,timerange,bin_width)    

%%%%%%%if step is 

% timerange=timerange/1000;
% bin_width=bin_width/1000;
% step=step/1000;
data=data(:);
tempData=[];
for i=1:length(timerange(1,:))
    temp=data(find(data>=timerange(1,i)&data<timerange(2,i)));
    tempData=[tempData;temp(:)];
end

data=tempData;

    bin_start=[];
    step=bin_width;
    bin_num=round((diff(timerange)-bin_width)/step)+1;
    temp_start=timerange(1):step:(timerange(1)+step*(bin_num-1));
    bin_start=[bin_start;temp_start'];
    clear temp_start;
    bin_over=bin_start+bin_width;

    
    temp_data1=[data;timerange(1);(timerange(2)-bin_width)];
    [temp_num,nonsense]=hist(temp_data1,length(bin_start));
    temp_num(1)=temp_num(1)-1;temp_num(length(temp_num))=temp_num(length(temp_num))-1;
    y=temp_num;


time=(bin_start+bin_over)/2;
