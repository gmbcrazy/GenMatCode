function [power_AD,Spec,time]=PowerAmp_time_spec(path_filename,Data_name,timerange,fre_range)

for i=1:length(Data_name)
    [raw_AD,time]=rate_historam(path_filename,Data_name(i).Name,timerange,0.001,0.001);
%     lowf=fre_range(1);
%     highf=fre_range(2);
%     [filterAD,filtwts] = eegfilt(raw_AD,1000,lowf,highf,0,500,0);
%     analytic_sf=hilbert(zscore(filterAD));
%     power_AD(i,:)=abs(analytic_sf).^2';
%     raw_AD=zscore(raw_AD);
    NFFT=2048;
    Fs=1000;
    WINDOW=hanning(512);
    NOVERLAP=400;
    
    
    NFFT=2048;
    Fs=1000;
    WINDOW=hanning(1024);
    NOVERLAP=824;

    
    raw_AD=detrend(raw_AD,'constant');
    [B,F,T] = specgram(raw_AD,NFFT,Fs,WINDOW,NOVERLAP);
    if strfind(Data_name(i).Name,'AD')

    F_index=find(F>=fre_range(1)&F<=fre_range(2));
 
    F_delta=find(F>=2&F<=4);
    power_AD(i,:)=sum(abs(B(F_index,:)))./sum(abs(B(F_delta,:)));
else
    F_index=find(F>=fre_range(1)&F<=fre_range(2));
    power_AD(i,:)=sum(abs(B(F_index,:)));
 
    
end
% figure;plot(T,power_AD(i,:));

% s_power(2,:)=smoothts(smoothts(power_AD(2,:),'b',3),'g',5,1);


Spec(i).Power=20*log10(abs(B)/500);
Spec(i).F=F;
Spec(i).Time=T+timerange(1);
time=T+timerange(1);
end
% power_AD(1,:)=smoothts(power_AD(1,:),'b',40);
% power_AD(2,:)=smoothts(power_AD(2,:),'b',40);
