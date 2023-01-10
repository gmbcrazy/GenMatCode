function [power_AD,time]=PowerAmp_time(path_filename,Data_name,timerange,fre_range)

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
    NOVERLAP=200;
    
    
    NFFT=2048;
    Fs=1000;
    WINDOW=hanning(1024);
    NOVERLAP=512;

    
    NFFT=2048;
    Fs=1000;
    WINDOW=hanning(1024);
    NOVERLAP=824;

    
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
%     time=T;

end

time=T+time(1);
