fre_band=[0;100]
window_length=60;
step=1;
timerange=[0;1800]
filename='E:\brust theta\lab02\xk128\final_two_days\05-f.nex';
[adfreq,n,ts,fn,AD27]=nex_cont(filename,'AD27_ad_000');
sig=cicular_cic_vs_time(filename,'scsig053ats','AD27theta_ad_000',timerange,window_length,step);


[adfreq,n,ts,fn,AD27]=nex_cont(filename,'AD27_ad_000');
[Temp_B,Temp_f,Temp_t]= specgram(AD27,6000,adfreq,hamming(6000));
subplot(3,1,1);
imagesc(sig.Time,sig.Phase_sample,sig.Density);axis xy;axis([min(timerange) max(timerange) 0 720]);
subplot(3,1,2);
imagesc(Temp_t,Temp_f,20*log(abs(Temp_B)));axis xy;axis([min(timerange) max(timerange) fre_band(1) fre_band(2)]);
subplot(3,1,3);
plot(sig.Time,sig.P);axis xy;axis([min(timerange) max(timerange) 0 1]);






function [a,b]=trans(x,y) 
x=0:0.01:12;
y=sin(x)+1;

[th,r]=cart2pol(x,y);
th1=th*0.7*th;
