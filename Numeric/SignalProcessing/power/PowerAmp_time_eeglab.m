function [power_AD,time]=PowerAmp_time_eeglab(path_filename,Data_name,timerange,fre_range)

for i=1:length(Data_name)
    [raw_AD,time]=rate_historam(path_filename,Data_name(i).Name,timerange,0.001,0.001);
    lowf=fre_range(1);
    highf=fre_range(2);
    [filterAD,filtwts] = eegfilt(raw_AD,1000,lowf,highf,0,500,0);
    analytic_sf=hilbert(zscore(filterAD));
    power_AD(i,:)=abs(analytic_sf)';
    
    power_AD(i,:)=smoothts(power_AD(i,:),'b',6000);
%     power_AD(i,:)=smoothts(power_AD(i,:),'g',5,20);

    
    if strfind(Data_name(i).Name,'AD')

    lowf=2;
    highf=4;
    [filterAD_delta,filtwts] = eegfilt(raw_AD,1000,lowf,highf,0,1000,0);
    analytic_sf_delta=hilbert(zscore(filterAD_delta));
    power_AD_delta(i,:)=abs(analytic_sf_delta)';
    power_AD_delta(i,:)=smoothts(power_AD_delta(i,:),'b',6000);
%     power_AD_delta(i,:)=smoothts(power_AD_delta(i,:),'g',5,20);

    power_AD(i,:)=power_AD(i,:)./power_AD_delta(i,:);

    power_AD(i,:)=smoothts(power_AD(i,:),'b',6000);
    else
%     
    [power_AD(i,:),time]=rate_historam(path_filename,Data_name(i).Name,timerange,0.001,0.001);
    power_AD(i,:)=power_AD(i,:)*1000;
    power_AD(i,:)=smoothts(power_AD(i,:),'b',6000);


    end
% figure;plot(T,power_AD(i,:));
% power_AD(i,:)=power_AD(i,:).^2;
% power_AD(i,:)=smoothts(power_AD(i,:),'b',2000);

% power_AD(i,:)=smoothts(power_AD(i,:),'b',6000);

%     time=T;

end

%     power_AD=power_AD.^2;


% figure
% plot(power_AD')
% power_AD


