%path_filename='C:\data\paper\fig1\lab02-xk128-103005006-f.nex';
clear all;
% close all
path_filename='E:\my program\causality\causality threhold\lab04-niu405-160608000-f.nex';
path_filename='D:\ZZ_Day12_20120826_DLS_done.nex';

timerange=[5;35];%%%%Analysis Period
bin_width=0.001;  %%%0.001s for ratehistogram
fre_band=[0;250];
window_long=256;  %%%%%window length(by sampling points) for coherence computing
NFFT=256;
repeat_num=200;   %%%%%overlaping of two neigbouring window (by sampling points) for coherence computing
%%%%%%%%%%%%%%%%%%%%%%noted repeat_num must < window_long
adfreq=1/bin_width;

% Data_name(1).Name='scsig049ats';
% Data_name(2).Name='AD13_ad_000';
Data_name(1).Name='scsig079U_1';
Data_name(2).Name='scsig077U_2';
% 

%%%step1
%%%%%reading data from nex as histogram for either LFPs or Spike Trains
[Data1,DataTime1]=RateHist(path_filename,Data_name(1).Name,timerange,bin_width);
[Data2,DataTime2]=RateHist(path_filename,Data_name(2).Name,timerange,bin_width);
%%%%%reading data from nex as histogram 


%%%%%plot the signal histogram
figure;plot(DataTime1,Data1,'g');hold on;plot(DataTime2,Data2,'k');  

%%%step2, needs step1 
%%%%%coherence
[Coh,FreCoh]=mscohere(Data1,Data2,window_long,repeat_num,NFFT,adfreq);
%%%%%coherence
figure;plot(FreCoh,Coh);
axis([fre_band(1) fre_band(2) 0 0.5]);title('coherence');
xlabel('Frequency')
% 

%%%step3; not necessary running step1,2 first.
%%%Causality
CausalityParameter.MORDER_band=[20;20];  %%%%order of prediction model
CausalityParameter.fre_band=[0;250];     %%%%frequency band to compute
CausalityParameter.NFFT=512;    
CausalityParameter.fs=1000;              %%%%sampling Rate
CausalityParameter.downsample=4;         %%%%downsampling rate




causality_theta=Causality_Pair(path_filename,Data_name,timerange,CausalityParameter);
figure;plot(causality_theta.F,causality_theta.F1to2,'b',causality_theta.F,causality_theta.F2to1,'r');
title('Granger Causality');xlabel('Frequency')
legend({['from ' Data_name(1).Name ' to ' Data_name(2).Name],['from ' Data_name(2).Name ' to ' Data_name(1).Name]})
% % 



%%%%%%%%%%%significance of coherence and causality
%%%%%%%%%%permutation test, based on shuffling of raw data by trials
ShuffleParameter.shuffle_num=100;
ShuffleParameter.P_value=0.01;
ShuffleParameter.trial_length=0.1;%%%%%%%length of trials for shuffling, 100ms in this case

CauCohShuffle_100ms=CauCoh_Pair_shuffleTrial(path_filename,Data_name,timerange,CausalityParameter,ShuffleParameter)
%%%%%%%%%%







