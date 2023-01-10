function [Pxx,F]=pwelchTrial(Data1,psdParameter)

ValidIndex=1:length(Data1);

Fs=psdParameter.Fs;
window=psdParameter.window;
noverlap=psdParameter.noverlap;
nfft=psdParameter.nfft;

if isfield(psdParameter,'Timerange')
Time=psdParameter.Timerange;
else
Time=[0;200000];
end

numTrial=0;
Sxx=zeros(length(Data1),nfft);
for i=1:length(Data1)
    
if isempty(Data1(i).Data)
   ValidIndex(i)=0;
   continue
end

    

if isempty(Time)
   Temp1=Data1(i).Data;


else



    if Time(1)>=0
        TempTime=Data1(i).Time-Data1(i).Time(1);
    else
        TempTime=Data1(i).Time-Data1(i).Time(end);
    end

   Temp_index=find(TempTime>=Time(1)&TempTime<=Time(2));
%    Temp1=detrend(zscore(Data1(i).Data));
%    Temp2=detrend(zscore(Data2(i).Data));
   
%    Temp1=Temp1(Temp_index);
     Temp1=Data1(i).Data(Temp_index);

%    Temp2=Temp2(Temp_index);

end


% figure;
% plot(Temp1,'r.')

if length(Temp1)<nfft
   ValidIndex(i)=0;
   continue
%    Add=Temp1;
%    Temp1=[Temp1;Add];  
end

% [temp1,temp2,temp3,temp4,temp5] = welchCohLuTrial({Temp1(:),Temp2(:)},window,noverlap,nfft,Fs);
% [~,temp2,~,temp4,temp5] = welchCohLuTrial({Temp1(:)},window,noverlap,nfft,Fs);
% [~,temp2,~,k,w,options] = GT_welchCohLuTrial({Temp1(:)},window,noverlap,nfft,Fs);
% [temp2,k,temp4,temp5] = GT_welchPsdTrial({Temp1(:)},window,noverlap,nfft,Fs);
[Pxx(i,:),F] = pwelch(Temp1(:),window,noverlap,nfft,Fs);


% [Sxy(i,:),Sxx(i,:),Syy(i,:),w,options] = welchCohLuTrial({Temp1(:),Temp2(:)},window,noverlap,nfft,Fs);

end
% Sxy=Sxy/numTrial;
% Sxx=Sxx/numTrial;
% Syy=Syy/numTrial;
% 
% [Pxy,f,xunits] = computepsd(Sxy,w,options.range,options.nfft,options.Fs,esttype);
% [Pxx,f,units] = computepsd(Sxx,w,options.range,options.nfft,options.Fs,esttype);
% [Pyy,f,xunits] = computepsd(Syy,w,options.range,options.nfft,options.Fs,esttype);
%  Cxy = (abs(Pxy).^2)./(Pxx.*Pyy); % Cxy


