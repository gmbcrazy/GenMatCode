function [Cxy,f,time]=cohere_vs_time2(filename,data_name,timerange,window_length,step,NFFT) 
[data1,time1]=rate_historam(filename,data_name(1).Name,timerange,0.001,0.001);
[data2,time2]=rate_historam(filename,data_name(2).Name,timerange,0.001,0.001);

move_num=floor((diff(timerange)-window_length)/step);
window_length=window_length*1000;
step_num=floor(step*1000);
for i=1:move_num
    temp1=(i-1)*step_num+1;
    temp2=temp1+window_length-1;
    temp_data1=data1(temp1:temp2);
    temp_data2=data2(temp1:temp2);
    [Cxy(:,i),f]=cohere(temp_data1,temp_data2,NFFT,1000,floor(NFFT/4),0,'linear');
    
end
time(1)=time1(1)+window_length*0.001/2;

for i=2:move_num
    time(i)=time(i-1)+step;
end
