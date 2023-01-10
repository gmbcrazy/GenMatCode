%path_filename='C:\data\paper\fig1\lab02-xk128-103005006-f.nex';
clear all;
% close all
path_filename='E:\my program\causality\causality threhold\lab04-niu405-160608000-f.nex';

timerange=[605;635];
MORDER_band=[20;20];
fre_band=[0;250];
window_long=256;
NFFT=256;
repeat_num=924;
adfreq=1000;

Data_name(2).Name='scsig049ats';
Data_name(1).Name='AD13_ad_000';

[sig041a_theta,sig041a_time]=rate_histogram(path_filename,Data_name(1).Name,timerange,0.001,0.001);
[AD47_theta,AD47_theta_t]=rate_histogram(path_filename,Data_name(2).Name,timerange,0.001,0.001);

[Pxy_theta,F_theta_csd]=cohere(AD47_theta,sig041a_theta,NFFT,adfreq,window_long,0,'linear');
figure;plot(F_theta_csd,Pxy_theta);axis([fre_band(1) fre_band(2) 0 0.5]);title('coherence');

NFFT=512;
fs=1000;
% 
causality_theta=causality_one2one(path_filename,Data_name,timerange,MORDER_band,NFFT,fre_band,fs);
figure;plot(causality_theta.F,causality_theta.F1to2,'b',causality_theta.F,causality_theta.F2to1,'r');
% % 
shuffle_num=100;
P=0.01;
trial_length=0.001;
% CauCohShuffle_ISI=CauCoh_one2one_shuffleISI(path_filename,Data_name,timerange,MORDER_band,NFFT,fre_band,fs,shuffle_num,P);
% save('E:\my program\causality\causality threhold\threhold.mat');
causality_threshold_trial_1ms=CauCoh_one2one_shuffle_mix(path_filename,Data_name,timerange,MORDER_band,NFFT,fre_band,fs,shuffle_num,P,trial_length);
% save('E:\my program\causality\causality threhold\threhold.mat');

trial_length=0.1;
causality_threshold_trial_100ms=CauCoh_one2one_shuffle_mix(path_filename,Data_name,timerange,MORDER_band,NFFT,fre_band,fs,shuffle_num,P,trial_length);
% save('E:\my program\causality\causality threhold\threhold.mat');
trial_length=1;
causality_threshold_trial_1000ms=CauCoh_one2one_shuffle_mix(path_filename,Data_name,timerange,MORDER_band,NFFT,fre_band,fs,shuffle_num,P,trial_length);


% CausalityParameter.MORDER_band=[25;25];
% CausalityParameter.fre_band=[0;250];
% CausalityParameter.NFFT=512;
% CausalityParameter.fs=1000;
% CausalityParameter.downsample=2;
% 
% ShuffleParameter.shuffle_num=100;
% ShuffleParameter.P_value=0.01;
% ShuffleParameter.trial_length=0.001;
% % CauCohShuffle=CauCoh_Pair_shuffleTrial(path_filename,Data_name,timerange,CausalityParameter,ShuffleParameter)
% 
% CauCohShuffle=CauCoh_Pair_shuffleISI(path_filename,Data_name,timerange,CausalityParameter,ShuffleParameter)








