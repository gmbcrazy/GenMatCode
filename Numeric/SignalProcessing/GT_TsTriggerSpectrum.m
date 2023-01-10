function Output = GT_TsTriggerSpectrum(LFP,refTs,samprate,timerange,varargin)
%   GT_WaveLet get wavelet Power in time&frequency domain representation
%   Extract Wavelet Spectrum Aligned by TimeStamps (refTsTemp) 
%   Coded by Lu Zhang; math2437@hotmail.com
%   Last updated: (13th June 2018)

%Output:
% % Output.AlignS1;    %%%Averaged Spectrum Aligned by refTsTemp
% % Output.AlighNum;   %%%event Num, refTsTemp
% % Output.F;    %%%Frequency 
% % Output.AlignLFP=Temp5; %%%%Averaged LFPs Aligned by refTsTemp
% % Output.Duration=sum(Duration); %%%%%%Total Duration of Analysis Period
% % Output.NumAnaPeriod=NumAnaPeriod; %%%%%%Total Num. of Analysis Period

%Input
%LFP: raw LFPs
%refTsTemp: Timestamps in seconds signal such as theta trough, ripple peaks
%samprate: sampling rate;
%timerange: analysis period.[1 40 120;30 88 160] indicate 1-30s,40-88s and 120-160s for three analysis period in total;

% % Default setting
%WaveParam.ntw=100;      smoothing time-window 100
%WaveParam.nsw=3;        smoothing fre-window 3
%WaveParam.smoothW=10;   smoothing Power
%WaveParam.DownSample=5; DownSampling
%WaveParam.wname='morl'; Wavelet Name
%WaveParam.samprateD=samprateD;
%WaveParam.Freq=[1:150]; Frequeny band interested/
% % Default setting


if nargin<5
% Default setting
WaveParam.Range=0.2;      %AlignedWindow Size 0.2s
WaveParam.ntw=100;      %smoothing time-window 100
WaveParam.nsw=3;        %smoothing fre-window 3
WaveParam.smoothW=10;   %smoothing Power
WaveParam.DownSample=5; %DownSampling
WaveParam.wname='morl'; %Wavelet Name
WaveParam.samprate=samprate;
WaveParam.Freq=[1:150]; %Frequeny band interested
WaveParam.Zscore=0; %default 0, raw power is calculated; ~=0, power is normalzied for each frequency respectively
%%%%%%%%%%%%%%%%%%%%%across time;
SavePath=[];
SaveShow=[];

% Default setting
elseif nargin==5
WaveParam=varargin{1};
WaveParam.samprate=samprate;
SavePath=[];
SaveShow=[];
elseif nargin==6
WaveParam=varargin{1};
WaveParam.samprate=samprate;
Param=varargin{2};
   if isfield(Param,'SavePath')
   SavePath=Param.SavePath;
   SaveShow=Param.SaveShow;
   else
   SavePath=[];
   SaveShow=[];
   end

else
    
end

ThetaSpec={};
ThetaPhase={};
LFPOutput={};
RefTimeStamps=[];


tic
Duration=round(diff(timerange));
NumAnaPeriod=length(Duration);

Istart=round(timerange(1,:)*samprate)+1;
Iend=round(timerange(2,:)*samprate)+1;
timerangeI=round(timerange*samprate)+1;

%%%%%%%%ii loops      multiple theta period in one recording file
for ii=1:length(Duration)

    refTsTemp=refTs;
    %%%%%%%%Inlcuding 1s before the theta start and 1s after theta ends
    %%%%%%%%to avoid edge effects in time of Wavelet
    Istart(ii)=max(Istart(ii)-samprate,1);
    Iend(ii)=min(Iend(ii)+samprate,length(LFP(:,1)));
    tempI=Istart(ii):Iend(ii);
    
    TExclude=[timerangeI(1,ii)-Istart(ii) Iend(ii)-timerangeI(2,ii)]/samprate;
    TimeInclude(:,ii)=[Istart(ii);Iend(ii)]/samprate;
    TInclude=([Istart(ii) Iend(ii)]-Istart(ii))/samprate;
    TInclude=[TInclude(1)+TExclude(1) TInclude(2)-TExclude(2)];
 
    LFPtemp=LFP(tempI);

    LFPtemp=zscore(decimate(LFPtemp,WaveParam.DownSample));
    len_t=length(LFPtemp);
    samprateD=samprate/WaveParam.DownSample;
    
F=WaveParam.Freq;
wname=WaveParam.wname;
ntw=WaveParam.ntw;
nsw=WaveParam.nsw;
bin_width=1/samprateD;
fc = centfrq(wname);
scales=sort(fc./F.*samprateD);
S1Power = waveletLU(LFPtemp,scales,wname,'ntw',ntw,'nsw',nsw);
if WaveParam.Zscore
   S1Power=zscore(S1Power,0,2); %%%%%%%%%%%%%normalize over time
% S1Power=zscore(S1Power,0,1);  %%%%%%%%%%%%%normalize over frequency
end

Time=([1:length(LFPtemp)]-1)/samprateD;
FPlot=F(end:-1:1);

refTsTemp=refTsTemp-Istart(ii)/samprate;
refTsTemp(refTsTemp>TInclude(2))=[];
refTsTemp(refTsTemp<TInclude(1))=[];

refTsTemp_ind=round(refTsTemp*samprateD);

BackW=round(WaveParam.Range*samprateD);
ForW=BackW;

% % refTsTemp=refTsTemp+TimeInclude(1,ii);
% % refTsTemp=refTsTemp(:);


if ii==1
Temp2=zeros(BackW+ForW+1,size(S1Power,1),1);
Temp4=zeros(BackW+ForW+1,1);

for iii=1:(length(refTsTemp_ind))
    s=round(max(refTsTemp_ind(iii)-BackW,1));
    o=round(min(refTsTemp_ind(iii)+ForW,len_t));
    l=round(o-s);
    s1=round(max(s-refTsTemp_ind(iii)+BackW,1));
    
    if iii==1
Temp2(s1:(s1+l),:,1)=S1Power(:,s:o)';
Temp4(s1:(s1+l),1)=LFPtemp(s:o,1);
    else
Temp2(s1:(s1+l),:,end+1)=S1Power(:,s:o)';
Temp4(s1:(s1+l),end+1)=LFPtemp(s:o,1);
       
    end
% Temp5=Temp5+Temp4;

end

else
 for iii=1:(length(refTsTemp_ind))
    s=round(max(refTsTemp_ind(iii)-BackW,1));
    o=round(min(refTsTemp_ind(iii)+ForW,len_t));
    l=round(o-s);
    s1=round(max(s-refTsTemp_ind(iii)+BackW,1));
    
    Temp2(s1:(s1+l),:,end+1)=S1Power(:,s:o)';
    Temp4(s1:(s1+l),end+1)=LFPtemp(s:o,1);
       
end



end


%%%%%%%%%Results for Multiple Theta Periods in One File
if ii==1
%    Temp2File=Temp2;
%    Temp4File=Temp4;
   
AlignS1=sum(Temp2,3);
Temp5=sum(Temp4,2);
tempN(ii)=size(Temp2,3);

else
    
AlignS1=AlignS1+sum(Temp2,3);
Temp2File=Temp5+sum(Temp4,2);
tempN(ii)=size(Temp2,3);

% % %     cat(3,Temp2File,Temp2);
% % %     Temp4File=cat(2,Temp4File,Temp4);
end

%%%%%%%%%Results for Multiple Theta Periods in One File





end
%%%%%%%%ii loops      multiple theta period in one recording file
   


AlignS1=AlignS1/sum(tempN);
% mean(Temp2File,3)
Temp5=Temp5/sum(tempN);
% Temp5=mean(Temp4File,2);
Range=[(-BackW):1:ForW]/samprateD;
Output.AlignS1=AlignS1;
Output.AlighNum=sum(tempN);
Output.F=FPlot;
Output.AlignLFP=Temp5;
% % AlignSample(i)=Output(i).AlighNum;
Output.Duration=sum(Duration);
Output.NumAnaPeriod=NumAnaPeriod;



if ~isempty(SavePath)
   save([SavePath SaveShow '.mat'],'Output');
end
toc




