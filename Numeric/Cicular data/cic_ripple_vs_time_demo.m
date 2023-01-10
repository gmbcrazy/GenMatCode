path_name='H:\lab04-02-012905\Dr.lin sorted\lab04-02-012905005-f.nex';
timerange=[0;1200];
window_length=5;
step=1;

data_name='scsig017ats';
AD_name='AD08ripple_ad_000';
ref_name='AD08ripplenor_maxts_hf';
AD_or='AD08_ad_000';
raster_range=[-0.05;0.05];
bin_width=0.001;
duration=window_length;
fre_band=[0;100];
cic_sig083a_ts_all=cic_ripple_vs_time(path_name,data_name,AD_name,timerange,window_length,step,0);
cic_sig083a_n_ts_all=cic_ripple_vs_time(path_name,data_name,AD_name,timerange,window_length,step,1);

cic_sig083a_ts_ripple=cic_ripple_vs_time2(path_name,data_name,AD_name,timerange,window_length,step,0);
cic_sig083a_n_ts_ripple=cic_ripple_vs_time2(path_name,data_name,AD_name,timerange,window_length,step,1);
[perievent_raster,perievent_raster_time,time,ts_origin]=perievent_raster_vs_time(path_name,data_name,ref_name,timerange,bin_width,raster_range,step,duration);

[adfreq,n,ts,fn,AD27]=nex_cont(path_name,AD_or);
[Temp_B,Temp_f,Temp_t]= specgram(AD27,2046,adfreq,hamming(2046));
figure;
imagesc(Temp_t,Temp_f,20*log(abs(Temp_B)));axis xy;axis([timerange(1) timerange(2) fre_band(1) fre_band(2)]);colorbar;
figure;
subplot(2,1,1);
imagesc(cic_sig083a_ts_all.Time,10:10:720,cic_sig083a_ts_all.Density);axis([timerange(1) timerange(2) 0 720]);colorbar;
subplot(2,1,2)
imagesc(cic_sig083a_ts_ripple.Time,10:10:720,cic_sig083a_ts_ripple.Density);axis([timerange(1) timerange(2) 0 720]);colorbar;

figure;
subplot(2,1,1);
imagesc(cic_sig083a_n_ts_all.Time,10:10:720,cic_sig083a_n_ts_all.Density);axis([timerange(1) timerange(2) 0 720]);colorbar;
subplot(2,1,2)
imagesc(cic_sig083a_n_ts_ripple.Time,10:10:720,cic_sig083a_n_ts_ripple.Density);axis([timerange(1) timerange(2) 0 720]);colorbar;
figure;
imagesc(perievent_raster_time,time,perievent_raster);axis xy;axis([timerange(1) timerange(2) raster_range(1) raster_range(2)]);colorbar;



