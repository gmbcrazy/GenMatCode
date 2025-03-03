function [timeTS_s,timeTS_o,timeAD_s,timeAD_o,power]=Lag_power_time_SF2paper1(filename,data_name,timerange,fre_range)

% filename='J:\single theta new\lab01-17-062205-nex\lab01-17-062205-finished\07-08.nex'
% % data_name(1).Name='scsig033ats';
% data_name(2).Name='AD18_ad_000';
% timerange=[0;2395];
% fre_range=[5;10];
% nLags=50;

[power_AD,time]=PowerAmp_time_eeglab(filename,data_name,timerange,fre_range);

time_step=mean(diff(time));

s_power(1,:)=smoothts(power_AD(1,:),'b',100);
% % s_power(2,:)=smoothts(smoothts(power_AD(2,:),'b',3),'g',5,1);
s_power(2,:)=(smoothts(power_AD(2,:),'b',100));

% s_power(1,:)=power_AD(1,:);
% s_power(2,:)=power_AD(2,:);
power.Power=s_power;
power.Time=time;
% crosscorr(power_AD(1,:),power_AD(2,:), nLags);

threshold=mean(s_power')+0.25*std(s_power');

% threshold=mean(s_power')+0.01*std(s_power');

for i=1:length(s_power(:,1))
power_start=zeros(size(s_power(i,:)));
power_over=power_start;

if length(strfind(data_name(i).Name,'AD'))>=1

sup_th_index=find(s_power(i,:)>max(threshold(i),2));
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
window_theta_th_s=500;
window_theta_th_o=2000;

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
%        while iii<(length(sup_th_index)-1)
%              if sup_th_index(iii+1)-sup_th_index(iii)>=window_theta_th
%                 Over_t{i}=[Over_t{i} sup_th_index(iii)];
%                 ii=iii+1;
%                 break
%             else
%                 iii=iii+1;
%              end
%              if iii==length(sup_th_index)
%                 Over_t{i}=[Over_t{i} sup_th_index(iii)];
%              end
%        end
   else
       ii=ii+window_theta_th_s;
   end
end

%     if ~isempty(sup_th_index)
%        diff_index=diff(sup_th_index);
%        temp_index1=[1 find(diff_index>4)+1];
%        temp_index2=[find(diff_index>4) length(sup_th_index)];
%        start_index=sup_th_index(temp_index1);
%        over_index=sup_th_index(temp_index2);
%        clear temp_index1 temp_index2
%     
%     check_index=diff(start_index);
%     invalid_index=find(check_index<1);
%     invalid_index_s=[];
%     invalid_index_o=[];
% 
%     if ~isempty(invalid_index)
%        invalid_index_s=invalid_index+1;    
%        invalid_index_o=invalid_index;    
% 
%     end
%     start_index(invalid_index_s)=[];
%     over_index(invalid_index_o)=[];
% 
%        power_start(start_index)=1;
%        power_over(over_index)=1;
%     end
%     Power_start(i,:)=power_start;
%     Power_over(i,:)=power_over;
%     
%     
%     Start_t{i}=start_index;
%     Over_t{i}=over_index;
  

end
for i=1:length(s_power(:,1))

    if length(Over_t{i})>=2
        check_index=diff(Start_t{i});
        invalid=find(check_index<20);
        Start_t{i}(invalid+1)=[];
        Over_t{i}(invalid)=[];
    
    end

end


for i=1:length(Start_t{2})
    
    [m,position]=min(abs(Start_t{1}-Start_t{2}(i)));
    timeTS_s(i)=time(Start_t{1}(position));
    timeAD_s(i)=time(Start_t{2}(i));
    
    [m,position]=min(abs(Over_t{1}-Over_t{2}(i)));
%     power_lag_over(i)=Over_t{1}(i)-Over_t{2}(position);
    timeTS_o(i)=time(Over_t{1}(position));
    timeAD_o(i)=time(Over_t{2}(i));

end

