function [Cau,time]=Causality_vs_time(filename,data_name,timerange,window_length,step,NFFT,fre_band,MORDER_band) 
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
    Data=[];
    Data(1,:)=temp_data1;
    Data(2,:)=temp_data2;
%     tic
    Cau(i).Data=causality_try1to1(Data,fre_band,1000,NFFT,MORDER_band);
%     [Cxy(:,i),f]=cohere(temp_data1,temp_data2,NFFT,round(1/bin_width),NFFT);
%     toc
end

time(1)=time1(1)+window_length*0.001/2;

for i=2:move_num
    time(i)=time(i-1)+step;
end
