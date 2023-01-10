



clear all;
% close all
path_filename='E:\my program\causality\causality threhold\lab04-niu405-160608000-f.nex';

timerange=[605;665];
MORDER_band=[20;20];
fre_band=[0;250];
window_long=256;
NFFT=256;
repeat_num=924;
adfreq=1000;

Data_name(1).Name='scsig049ats';
Data_name(2).Name='AD13_ad_000';
ref_name='AD13ripplenor_maxts_hf_n';
range=[-0.5;0.5];

[sig041a_theta,sig041a_time]=rate_histogram(path_filename,Data_name(1).Name,timerange,0.001,0.001);
[AD47_theta,AD47_theta_t]=rate_histogram(path_filename,Data_name(2).Name,timerange,0.001,0.001);

[Pxy_theta,F_theta_csd]=cohere(AD47_theta,sig041a_theta,NFFT,adfreq,window_long,0,'linear');
figure;plot(F_theta_csd,Pxy_theta);axis([fre_band(1) fre_band(2) 0 0.5]);title('coherence');

NFFT=512;
fs=1000;
% 
causality_ripple=Causality_one2one_ripple(path_filename,Data_name,ref_name,timerange,MORDER_band,NFFT,fre_band,fs,range);
figure;plot(causality_ripple.F,causality_ripple.F1to2,'b',causality_ripple.F,causality_ripple.F2to1,'r');
% % 
shuffle_num=100;
P=0.01;
trial_length=0.001;
CauCohShuffle=Causality_one2one_ripple_shuffle(path_filename,Data_name,ref_name,timerange,MORDER_band,NFFT,fre_band,fs,range,shuffle_num,P);
