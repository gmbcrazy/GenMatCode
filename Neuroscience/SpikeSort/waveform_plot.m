AD(1,:)=AD09_ad_000';
AD(2,:)=AD09ripple_normalized_ad_000';

wave_form=scsig017_wf_st_00_W;
timestamps=scsig017_wf_st_00;
time_start=643472;
time_over=643568;
spike_index=find(timestamps*1000>=time_start&timestamps*1000<(time_over-1.4));
figure;
subplot((length(AD(:,1))+1),1,1);
for i=1:length(spike_index)
    temp_time=0.000025*31+timestamps(spike_index(i));
    plot(timestamps(spike_index(i)):0.000025:temp_time,wave_form(:,spike_index(i)),'k');hold on;
end
set(gca,'XLimMode','man');
set(gca,'XLim',[time_start*0.001 time_over*0.001]);

AD_s_index=ceil(time_start)+1;
AD_e_index=floor(time_over)+1;


for i=2:(length(AD(:,1))+1)
    subplot((length(AD(:,1))+1),1,i);
    plot(time_start*0.001:0.001:time_over*0.001,AD(i-1,AD_s_index:AD_e_index),'k');
    set(gca,'XLimMode','man');
    set(gca,'XLim',[time_start*0.001 time_over*0.001]);
end

    

AD_new=AD09ripple_normalized_ad_000';
AD_start=[951105 1099620 874975];
AD_length=150;
figure;
for i=1:length(AD_start)
    subplot(length(AD_start),1,i);
    AD_over=AD_start(i)+AD_length;
    AD_s_index=AD_start(i)+1;
    AD_e_index=AD_over+1;

    plot(AD_start(i)*0.001:0.001:AD_over*0.001,AD_new(AD_s_index:AD_e_index),'k');
    set(gca,'XLimMode','man');
    set(gca,'XLim',[AD_start(i)*0.001 AD_over*0.001]);
end

    

rate_historam('C:\Documents and Settings\linlab-zhanglu\Desktop\g\lab04-02-020205001-f.nex','scsig017ats',[300;600],0.01,0.01);

