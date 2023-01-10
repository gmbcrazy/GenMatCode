function [Corr_peak_F,Corr_peak_power,Corr_power_T,Corr_power_F]=corr_spec(path_filename,Data_name,timerange,NFFT,hanning_length,fre_band,fs)

% path_filename='H:\6-xk128\103005\finish\lab02-xk128-103005006-f.nex';  % timerange=[240;270]; 
% timerange=[310;340];
% Data_name(1).Name='scsig053ats';
% Data_name(2).Name='AD27_ad_000';
% fs=1000;
% fre_band=[4;12];
% NFFT=2048;
% hanning_length=512;

[Data(1,:),time]=rate_historam(path_filename,Data_name(1).Name,timerange,1/fs,1/fs);
[Data(2,:),time]=rate_historam(path_filename,Data_name(2).Name,timerange,1/fs,1/fs);


[B1,F1,T1]=specgram(Data(1,:),NFFT,fs,hann(hanning_length),0);
[B2,F2,T2]=specgram(Data(2,:),NFFT,fs,hann(hanning_length),0);

Power1=(abs(B1)).^2;
Power2=(abs(B2)).^2;
f_index=find(F1>=fre_band(1)&F1<=fre_band(2));
F=F1(f_index);

Power1=Power1(f_index,:);
Power2=Power2(f_index,:);

[Peak_power1,Peak_index1]=max(Power1);
[Peak_power2,Peak_index2]=max(Power2);



for i=1:length(T1)
    Peak_f1(i)=F(Peak_index1(i));   
    Peak_f2(i)=F(Peak_index2(i));
end


C1=crosscorr(Peak_f1, Peak_f2);
C2=crosscorr(Peak_power1, Peak_power2);
Corr_peak_F=max(C1);
Corr_peak_power=max(C2);


Power_all1=sum(Power1);
Power_all2=sum(Power2);
C3=crosscorr(Power_all1, Power_all2);
Corr_power_T=max(C3);

Power_all1=sum(Power1');
Power_all2=sum(Power2');
C4=crosscorr(Power_all1, Power_all2);
Corr_power_F=max(C4);
