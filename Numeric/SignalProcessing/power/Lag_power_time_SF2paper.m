function [timeTS_s,timeTS_o,timeAD_s,timeAD_o]=Lag_power_time_SF2paper(filename,data_name,timerange,fre_range)

% filename='J:\single theta new\lab01-17-062205-nex\lab01-17-062205-finished\07-08.nex'
% % data_name(1).Name='scsig033ats';
% data_name(2).Name='AD18_ad_000';
% timerange=[0;2395];
% fre_range=[5;10];
% nLags=50;

[power_AD,time]=PowerAmp_time(filename,data_name,timerange,fre_range);

time_step=mean(diff(time));

s_power(1,:)=smoothts(power_AD(1,:),'b',3);
s_power(2,:)=smoothts(smoothts(power_AD(2,:),'b',3),'g',5,1);
% s_power(1,:)=power_AD(1,:);
% s_power(2,:)=power_AD(2,:);

% crosscorr(power_AD(1,:),power_AD(2,:), nLags);

threshold=mean(s_power')+1*std(s_power');
for i=1:length(s_power(:,1))
power_start=zeros(size(s_power(i,:)));
power_over=power_start;

if length(strfind(data_name(i).Name,'AD'))>=1

sup_th_index=find(s_power(i,:)>max(threshold(i),4));
else
sup_th_index=find(s_power(i,:)>threshold(i));

end
% if strfind(data_name(i).Name,'AD')
% 
% sup_th_index2=find(s_power(i,:)>4);
% sup_th_index=intersect(sup_th_index,sup_th_index2);
% 
% end
    if ~isempty(sup_th_index)
       diff_index=diff(sup_th_index);
       temp_index1=[1 find(diff_index>4)+1];
       temp_index2=[find(diff_index>4) length(sup_th_index)];
       start_index=sup_th_index(temp_index1);
       over_index=sup_th_index(temp_index2);
       clear temp_index1 temp_index2
    
    check_index=diff(start_index);
    invalid_index=find(check_index<100);
    invalid_index_s=[];
    invalid_index_o=[];

    if ~isempty(invalid_index)
       invalid_index_s=invalid_index+1;    
       invalid_index_o=invalid_index;    

    end
    start_index(invalid_index_s)=[];
    over_index(invalid_index_o)=[];

       power_start(start_index)=1;
       power_over(over_index)=1;
    end
    Power_start(i,:)=power_start;
    Power_over(i,:)=power_over;
    
    
    Start_t{i}=start_index;
    Over_t{i}=over_index;
  

end

for i=1:length(Start_t{1})
    
    [m,position]=min(abs(Start_t{1}(i)-Start_t{2}));
    timeTS_s(i)=time(Start_t{1}(i));
    timeAD_s(i)=time(Start_t{2}(position));
    
    [m,position]=min(abs(Over_t{1}(i)-Over_t{2}));
    power_lag_over(i)=Over_t{1}(i)-Over_t{2}(position);
    timeTS_o(i)=time(Over_t{1}(i));
    timeAD_o(i)=time(Over_t{2}(position));

end
