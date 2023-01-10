function [Cxy,F,ValidIndex]=coh_NaviSmr(Data1,Data2,psdParameter)

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


for i=1:length(Data1)
    
if isempty(Data1(i).Data)
   ValidIndex(i)=0;
   continue
end

    
% figure;
% plot(Data1(i).Data);

if isempty(Time)
   Temp1=Data1(i).Data;
   Temp2=Data2(i).Data;


else



    if Time(1)>=0
        TempTime=Data1(i).Time-Data1(i).Time(1);
    else
         TempTime=Data1(i).Time-Data1(i).Time(end);
    end

   Temp_index=find(TempTime>=Time(1)&TempTime<=Time(2));
   Temp1=detrend(zscore(Data1(i).Data));
   Temp2=detrend(zscore(Data2(i).Data));
   
   Temp1=Temp1(Temp_index);
   Temp2=Temp2(Temp_index);

end

if isempty(Temp1)
   Temp1=zscore(detrend(Data1(i).Data));
   Temp2=zscore(detrend(Data2(i).Data));

end




% figure;
% plot(Temp1,'r.')

if length(Temp1)<nfft
   ValidIndex(i)=0;
   continue
%    Add=Temp1;
%    Temp1=[Temp1;Add];  
end


   [Cxy(:,i),F] = mscohere(Temp1,Temp2,window,noverlap,nfft,Fs);
% qbias=0;
% confn=0;
% qplot=0;
% dt=1/Fs;
% NW=5;
%    [F, Cxy(:,i), ph, ci, phi] = cmtmPH(Temp1,Temp2,dt,NW,qbias,confn,qplot,nfft);
    
   
% [Cxy(:,i),F] = mscohere(Data1(i).Data(max(end-3000,1):end),Data2(i).Data(max(end-3000,1):end),window,noverlap,nfft,Fs);

end

if length(ValidIndex)==(length(Cxy(1,:))+1)
   Cxy(:,end+1)=0;
end

ValidIndex(ValidIndex==0)=[];

