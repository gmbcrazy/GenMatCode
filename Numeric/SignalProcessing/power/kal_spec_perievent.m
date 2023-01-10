function power_all=kal_spec_perievent(path_filename,AD_name,reference_name,hf_num,timerange,F,KalmanInput,fre)
% timerange=[1125.68;1128.68];
% path_filename='E:\research\data\xk128\04-f.nex';


[bin_x,T]=rate_historam(path_filename,AD_name,timerange,1/fre,1/fre);

bin_x=zscore(bin_x);

% lowf=49;
% highf=51;

% [b,a]=ellip(5,0.5,20,[lowf/500,highf/500],'stop');
% bin_x=filtfilt(b,a,bin_x);



[ref,T]=rate_historam(path_filename,reference_name,timerange,1/fre,1/fre);
% [raster,time,ts_origin]=perievent_raster_file(path_filename,AD_name,reference_name,timerange,0.001,[-0.4;0.4]);

hf_num=400;
ref_index=find(ref>0);
start_index=ref_index-hf_num;
over_index=ref_index+hf_num;

invalid1=find(start_index<=15);
invalid2=find(over_index>(length(bin_x)-15));
invalid=union(invalid1,invalid2);

start_index(invalid)=[];
over_index(invalid)=[];


[S,F,T]=spec_kal(path_filename,AD_name,KalmanInput,fre,timerange,F);
% S_smooth=smoothts(abs(S.Power),'b',9);
S_smooth=S.Power;
power_all=zeros(length(F),2*hf_num+1);
for i=1:length(start_index)
    power_all=power_all+(S_smooth(start_index(i):over_index(i),:)');  
end

power_all=abs(power_all)/length(start_index);
% 
% figure
% imagesc(-400:400,F,smoothts(log(power_all),'b',9));axis xy
% 
% hold on;
% 
% plot(time*1000,mean(raster)*500+100,'color',[1 0 0],'linewidth',4)
% set(gca,'color',[1 1 1],'xcolor',[1 1 1],'ycolor',[1 1 1],'ylim',[30 200],'ytick',[100 150 200],'clim',[-12 0]);
