path_filename='J:\6-xk128\103005\nex_1_finish\lab02-xk128-103005006-f.nex';

timerange=[190;220];
CausalityParameter.MORDER_band=[10;10];
CausalityParameter.fre_band=[0;50];
CausalityParameter.NFFT=512;
CausalityParameter.fs=1000;
CausalityParameter.downsample=10;
% 
Data_name(1).Name='scsig053ats';
Data_name(2).Name='AD27_ad_000';
% 
% [sig041a_theta,sig041a_time]=rate_historam(path_filename,Data_name(1).Name,timerange,0.001,0.001);
% [AD47_theta,AD47_theta_t]=rate_historam(path_filename,Data_name(2).Name,t
% imerange,0.001,0.001);
% [Pxy_theta,F_theta_csd]=cohere(AD47_theta,sig041a_theta,NFFT,adfreq,window_long,0,'linear');
% figure;plot(F_theta_csd,Pxy_theta);axis([fre_band(1) fre_band(2) 0 0.5]);title('coherence');


causality_theta=Causality_Pair(path_filename,Data_name,timerange,CausalityParameter);
figure;plot(causality_theta.F,causality_theta.F1to2,'b',causality_theta.F,causality_theta.F2to1,'r');


Lag_range=[-0.2;0.2];
Lag_step=0.005;
CauCohLag=CauCoh_Timelag_Pair(path_filename,Data_name,timerange,CausalityParameter,Lag_range,Lag_step);

figure;
imagesc(CauCohLag.Timelag(end:(-1):1),CauCohLag.F_cau,CauCohLag.F1to2);axis xy

figure;
imagesc(CauCohLag.Timelag(end:(-1):1),CauCohLag.F_cau,CauCohLag.F2to1);axis xy