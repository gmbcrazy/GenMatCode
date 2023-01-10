function [power_lag_start,power_lag_over]=Lag_power_eeglab(filename,data_name,timerange,fre_range)

% filename='J:\single theta new\lab01-17-062205-nex\lab01-17-062205-finished\07-08.nex'
% % data_name(1).Name='scsig033ats';
% data_name(2).Name='AD18_ad_000';
% timerange=[0;2395];
% fre_range=[5;10];
% nLags=50;

[power_AD,time]=PowerAmp_time_eeglab(filename,data_name,timerange,fre_range);
figure;

% s_power(1,:)=smoothts(power_AD(1,:),'b',1000);
% % s_power(2,:)=smoothts(smoothts(power_AD(2,:),'b',3),'g',5,1);
% s_power(2,:)=(smoothts(power_AD(2,:),'b',1000));

s_power(1,:)=power_AD(1,:);
s_power(2,:)=power_AD(2,:);
power.Power=s_power;
power.Time=time;
% crosscorr(power_AD(1,:),power_AD(2,:), nLags);

threshold=mean(s_power')+0.25*std(s_power');



for i=1:length(s_power(:,1))
power_start=zeros(size(s_power(i,:)));
power_over=power_start;

if length(strfind(data_name(i).Name,'AD'))>=1

sup_th_index=find(s_power(i,:)>max(threshold(i),0));
else
sup_th_index=find(s_power(i,:)>threshold(i));

end
% if strfind(data_name(i).Name,'AD')
% 
% sup_th_index2=find(s_power(i,:)>4);
% sup_th_index=intersect(sup_th_index,sup_th_index2);
% 
% end
ii=1;
window_theta_th_s=4000;
window_theta_th_o=4000;

Start_t{i}=[];
Over_t{i}=[];

while ii<=(length(sup_th_index)-window_theta_th_s)
    if (sup_th_index(ii+window_theta_th_s)-sup_th_index(ii))<=window_theta_th_s
       Start_t{i}=[Start_t{i} sup_th_index(ii)];
       iii=ii+window_theta_th_o;
       temp=diff(sup_th_index(iii:end));
       iii=min([(find(temp>=window_theta_th_o))+iii-1 length(sup_th_index)]);
       Over_t{i}=[Over_t{i} sup_th_index(iii)];
       ii=iii+1;
   else
       ii=ii+window_theta_th_s;
   end
end

subplot(2,1,i)
plot(s_power(i,:));hold on;
plot([1:10000],threshold(i)*ones(1,10000));


end
for i=1:length(s_power(:,1))

    if length(Over_t{i})>=2
        check_index=diff(Start_t{i});
        invalid=find(check_index<10000);
        Start_t{i}(invalid+1)=[];
        Over_t{i}(invalid)=[];
    
    end

end

end

for i=1:length(s_power(:,1))

    if length(Over_t{i})>=2
        check_index=abs(Start_t{i}(2:end)-Over_t{i}(1:(end-1)));
        invalid=find(check_index<30000);
        Start_t{i}(invalid+1)=[];
        Over_t{i}(invalid)=[];
    
    end

end

end


i=1;
power_lag_start=[];
power_lag_over=[];
temp_s=0;
temp_o=0;
while i<=length(Start_t{1})
    [m,position_s]=min(abs(Start_t{1}(i)-Start_t{2}));
    [m,position_o]=min(abs(Over_t{1}(i)-Over_t{2}));

    if (~isempty(position_s))&(~isempty(position_o))&(position_s~=temp_s)&(position_o~=temp_o)
        
      if  abs(Start_t{1}(i)-Start_t{2}(position_s))<80000
    power_lag_start=[power_lag_start Start_t{1}(i)-Start_t{2}(position_s)];
    power_lag_over=[power_lag_over Over_t{1}(i)-Over_t{2}(position_o)];
    temp_s=position_s;
    temp_o=position_o;
      end
    end

    i=i+1;
end

hold on;
for i=1:length(Start_t{1})
    subplot(2,1,1);hold on;
plot(Start_t{1}(i),0,'go');hold on;
plot(Over_t{1}(i),0,'go');hold on;
end

for i=1:length(Start_t{2})
    subplot(2,1,2);hold on;
plot(Start_t{2}(i),0,'ro');hold on;
plot(Over_t{2}(i),0,'ro');hold on;
end


