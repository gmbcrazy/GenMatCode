function [Output,FPlot]= GT_LFPCoh_WL(LFP1,LFP2,samprate,PeriodCom,varargin)
%   GT_WaveLet get wavelet Power in time&frequency domain representation
%   Extract Wavelet Spectrum Aligned by TimeStamps (NeuronTs) 
%   Noted that NeuronTs is MultiUnit timestamps, NeuronTsID is vector of
%   same length NeuronTs; NeuronTs(i) is a spike fired by Unit NeuronTsID(i)
%   NeuronTs, and NeuronTsID is used in Busgyi Data. 


%   Coded by Lu Zhang; math2437@hotmail.com
%   Last updated: (18th June 2018)

%Output: iCell indicate the iCell th neuron in unique(NeuronTsID)
% % Output(iCell).AlignS1;    %%%Averaged Spectrum Aligned by refTsTemp
% % Output(iCell.AlighNum;   %%%event Num, refTsTemp
% % Output(iCell.F;    %%%Frequency 
% % Output(iCell.AlignLFP=Temp5; %%%%Averaged LFPs Aligned by refTsTemp
% % Output(iCell.Duration=sum(Duration); %%%%%%Total Duration of Analysis Period
% % Output(iCell.NumAnaPeriod=NumAnaPeriod; %%%%%%Total Num. of Analysis Period

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
% SavePath=[];
% SaveShow=[];

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


tic
F=WaveParam.Freq;
wname=WaveParam.wname;
ntw=WaveParam.ntw;
nsw=WaveParam.nsw;


LFP1=zscore(decimate(LFP1,WaveParam.DownSample));
LFP2=zscore(decimate(LFP2,WaveParam.DownSample));

len_t=length(LFP2);
samprateD=samprate/WaveParam.DownSample;
Time=([1:len_t]-1)/samprateD;



    
% % S1Power = waveletLU(LFPtemp,scales,wname,'ntw',ntw,'nsw',nsw);
bin_width=1/samprateD;
fc = centfrq(wname);
scales=sort(fc./F.*samprateD);
[WCOH,WCS,CWT_S1,CWT_S2]=wcoherLU(LFP1,LFP2,scales,wname,'ntw',ntw,'nsw',nsw);

for iCom=1:length(PeriodCom)
    timerange=PeriodCom{iCom};
NeedTimeIndex=[];
for i=1:size(timerange,1)
    t1=find(Time>=timerange(1,i)&Time<=timerange(2,i));
    NeedTimeIndex=[NeedTimeIndex;t1(:)];
end

 Output(iCom).Coh=nanmean(abs(WCOH(:,NeedTimeIndex)),2);
 Output(iCom).WCS=nanmean(WCS(:,NeedTimeIndex),2);
 Output(iCom).S1=nanmean(CWT_S1(:,NeedTimeIndex),2);
 Output(iCom).S2=nanmean(CWT_S2(:,NeedTimeIndex),2);

 FPlot=F(end:-1:1);
 Output(iCom).Fplot=FPlot;
end
% % % 
% % % 
if ~isempty(SavePath)
   save([SavePath SaveShow '.mat'],'Output');
end
toc




