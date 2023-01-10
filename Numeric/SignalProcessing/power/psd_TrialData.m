function [Sxx,w,options,ValidIndex,WinNum]=psd_TrialData(Data1,psdParameter)

%%%Calculate Power Spectrum Density for Trial Data, edited by Lu Zhang, subfunction GT_welchPsdTrial is modifed from MATLAB original function WELCH 

%%%%%Data1 is the structure varaiable of time series by trials
%%%%%%%%%%Data1(i).Data is the EEG time series in trial i
%%%%%%%%%%Data1(i).Time is the sampling time of Data1(i).Data
%%%%%%%%%%Data1(i).Time(1) should be 0, indicate the 0s from the trial istart.

%%%Noted that, for each trial, Data preprocessing is used, detrend and zscore, at line 65-75

%%%%%psdParameter parameter structure to calculate psd
%%%%%%%%%%psdParameter.Timerange, Analysis period within the trial [1;20] indicate only data recorded between 1s after trial onset and 20s after trial onset is used.
%%%%%%%%%%psdParameter.Fs, sampling rate of Data1(i).Data
%%%%%%%%%%psdParameter.window, window length, value 2000 with sampling rate of 1000Hz, corresponds to 2000/1000 = 2s of window length
%%%%%%%%%%psdParameter.noverlap, no. of overlap of sliding window
%%%%%%%%%%psdParameter.nfft, NFFT

%%%%%%%%Output Sxx is the periodogram output different from the output of MATLAB function WELCH.
%%%%%%%%here Sxx is sum of results of every sliding window, while that of WELCH is the average.
%%%%%%%%WinNum is a vector, where WinNum(i) is the num. of sliding window in that trial.
%%%%%%%%ValidIndex indicate valid trial ID in this calculation.
%%%%%%%%other output: w, options, refers to WELCH





%%[Sxx,k,w,options] = GT_welchPsdTrial(Data1,varargin)

ValidIndex=1:length(Data1);

Fs=psdParameter.Fs;
window=psdParameter.window;
noverlap=psdParameter.noverlap;
nfft=psdParameter.nfft;

if isfield(psdParameter,'Timerange')
Time=psdParameter.Timerange;
else
Time=[0;200000000];
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


%%%%%%%%%%Data preprocessing is used, detrend and zscore
if isempty(Temp1)
   Temp1=zscore(detrend(Temp1));
%    Temp2=zscore(detrend(Data2(i).Data));
%    Temp1=(Data1(i).Data);
  
end
%%%%%%%%%%Data preprocessing is used, detrend and zscore




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
[temp2,k,temp4,temp5] = GT_welchPsdTrial({Temp1(:)},window,noverlap,nfft,Fs);
% [Sxx,k,w,options] = GT_welchSpecTrial({Temp1(:)},window,noverlap,nfft,Fs);


if ~isempty(temp2)
   Sxx(i,:)=temp2;
   w=temp4;
   options=temp5;
   WinNum(i)=k;
else
   ValidIndex(i)=0;

      
end

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


