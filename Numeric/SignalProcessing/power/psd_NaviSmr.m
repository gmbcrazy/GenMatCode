function [power,f,ValidIndex]=psd_NaviSmr(Data,psdParameter)

ValidIndex=1:length(Data);
    
Fs=psdParameter.Fs;
window=psdParameter.window;
noverlap=psdParameter.noverlap;
nfft=psdParameter.nfft;
if isfield(psdParameter,'Timerange')
Time=psdParameter.Timerange;
else
Time=[0;200000];
end

for i=1:length(Data)
    
    
% figure;
% plot(Data(i).Data);

if isempty(Data(i).Data)
   ValidIndex(i)=0;
   continue
end


if isempty(Time)
   Temp1=Data(i).Data;


else

   if Time(1)>=0
   TempTime=Data(i).Time-Data(i).Time(1);
    else
   TempTime=Data(i).Time-Data(i).Time(end);
   end
    Temp_index=find(TempTime>=Time(1)&TempTime<=Time(2));
    Temp1=Data(i).Data(Temp_index);

end

if isempty(Temp1)
   Temp1=Data(i).Data;
end

% % figure;
% % plot(Temp1,'r.')
% 
%    Temp1=zscore(detrend(Temp1));
% 
h = spectrum.welch('Hann',window,100*noverlap/window);

if length(Temp1)<nfft
   ValidIndex(i)=0;
   continue
%    Add=Temp1;
%    Temp1=[Temp1;Add];  
end


% hpsd = psd(h,Temp1,'NFFT',nfft,'Fs',Fs);
% power(:,i)=hpsd.Data(:);
% f=hpsd.Frequencies;



nw=3;
[P,s,ci] = pmtmPH(Temp1,1/Fs,nw,0,nfft);

 power(:,i)=P(:);
 f=s;






end
if length(ValidIndex)==(length(power(1,:))+1)
   power(:,end+1)=0;
end
ValidIndex(ValidIndex==0)=[];
ValidIndex;

