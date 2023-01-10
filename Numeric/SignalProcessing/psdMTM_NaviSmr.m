function [S, f, Serr,ValidIndex]=psdMTM_NaviSmr(Data1,psdParameter,computeIndex)

% params.fpass=[0 50];



%       data1 (in form samples x trials) -- required
%       data2 (in form samples x trials) -- required
%       movingwin (in the form [window winstep] -- required
%       params: structure with fields tapers, pad, Fs, fpass, err, trialave
%       - optional
%           tapers : precalculated tapers from dpss or in the one of the following
%                    forms: 
%                    (1) A numeric vector [TW K] where TW is the
%                        time-bandwidth product and K is the number of
%                        tapers to be used (less than or equal to
%                        2TW-1). 
%                    (2) A numeric vector [W T p] where W is the
%                        bandwidth, T is the duration of the data and p 
%                        is an integer such that 2TW-p tapers are used. In
%                        this form there is no default i.e. to specify
%                        the bandwidth, you have to specify T and p as
%                        well. Note that the units of W and T have to be
%                        consistent: if W is in Hz, T must be in seconds
%                        and vice versa. Note that these units must also
%                        be consistent with the units of params.Fs: W can
%                        be in Hz if and only if params.Fs is in Hz.
%                        The default is to use form 1 with TW=3 and K=5
%                     Note that T has to be equal to movingwin(1).
%
%	        pad		    (padding factor for the FFT) - optional (can take values -1,0,1,2...). 
%                    -1 corresponds to no padding, 0 corresponds to padding
%                    to the next highest power of 2 etc.
%			      	 e.g. For N = 500, if PAD = -1, we do not pad; if PAD = 0, we pad the FFT
%			      	 to 512 points, if pad=1, we pad to 1024 points etc.
%			      	 Defaults to 0.
%           Fs   (sampling frequency) - optional. Default 1.
%           fpass    (frequency band to be used in the calculation in the form
%                                   [fmin fmax])- optional. 
%                                   Default all frequencies between 0 and Fs/2
%           err  (error calculation [1 p] - Theoretical error bars; [2 p] - Jackknife error bars
%                                   [0 p] or 0 - no error bars) - optional. Default 0.
%           trialave (average over trials when 1, don't average when 0) - optional. Default 0





ValidIndex=1:length(computeIndex);

Fs=psdParameter.Fs;
window=psdParameter.window;
noverlap=psdParameter.noverlap;
nfft=psdParameter.nfft;

if isfield(psdParameter,'Timerange')
Time=psdParameter.Timerange;
else
Time=[0;200000];
end

computData1=[];
Marker=[];
for i=1:length(computeIndex)
    
    
        TempCData1=Data1(computeIndex(i)).Data;

if isempty(TempCData1)
   ValidIndex(i)=0;
   continue
end

    
% figure;
% plot(TempCData1);

if isempty(Time)
   Temp1=TempCData1;


else



    if Time(1)>=0
       TempTime=Data1(computeIndex(i)).Time-Data1(computeIndex(i)).Time(1);
    else
       TempTime=Data1(computeIndex(i)).Time-Data1(computeIndex(i)).Time(end);
    end

   Temp_index=find(TempTime>=Time(1)&TempTime<=Time(2));
   Temp1=TempCData1;
   
   Temp1=Temp1(Temp_index);

end

if isempty(Temp1)
   Temp1=zscore(detrend(TempCData1));
end




% figure;
% plot(Temp1,'r.')

if length(Temp1)<nfft
   ValidIndex(i)=0;
   continue

end

% computData1(:,i)=Temp1;
% computData2(:,i)=Temp2;
computData1=[computData1;Temp1];
Marker=[Marker;length(Temp1)];

% params1.tapers=[4 7];
% params1.pad=round(nfft/512);
% params1.Fs=psdParameter.Fs;
% params1.err=[2 0.05];
% params1.fpass=[0 params1.Fs/2];
% params1.nfft=nfft;
% 
% movingwin=[window window-noverlap]/params1.Fs;
% [C(:,i),phi,S1(:,i),S2(:,i),f]=coherencyc(Temp1,Temp2,params1);

end

sMarkers=zeros(length(Marker),2);
sMarkers(:,2)=cumsum(Marker);
sMarkers(:,1)=[1;sMarkers(1:(end-1),2)+1];

ValidIndex=ValidIndex(ValidIndex~=0);
% params.tapers=[1.5 2];
params1.pad=round(nfft/2/512);
params1.Fs=psdParameter.Fs;
params1.err=[1 0.05];
params1.fpass=[0 Fs/2];
params1.nfft=nfft;

movingwin=[window window-noverlap]/params1.Fs;

% 
% params1.tapers=[3 5];
% params1.fpass=[0 25];
% [S1, f1, Serr1 ]= mtspectrumc_unequal_length_trials(computData1, movingwin, params1, sMarkers );
% 
% 
% params1.tapers=[10 5];
% params1.fpass=[25 params1.Fs/2];
% [S2, f2, Serr2 ]= mtspectrumc_unequal_length_trials(computData1, movingwin, params1, sMarkers );
% 
% S=[S1;S2];
% f=[f1';f2'];
% Serr=[Serr1';Serr2'];


params1.tapers=psdParameter.tapers;
params1.fpass=[0 params1.Fs/2];
[S, f, Serr]= mtspectrumc_unequal_length_trials(computData1, movingwin, params1, sMarkers );


ValidIndex(ValidIndex==0)=[];
ValidIndex=computeIndex(ValidIndex);


% [C,Phimn,Smn,Smm,f]=coherencyc(computData1,computData2,params1);


