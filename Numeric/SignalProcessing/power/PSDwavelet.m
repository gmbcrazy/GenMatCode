function [PSD,Fplot] = PSDwavelet(LFP,samprate,timerange,varargin)
%   GT_WaveLet get wavelet Power in time&frequency domain representation
%   Extract Wavelet Spectrum for Each Single Theta Circle and Normalize
%   Spectrum by Theta Phase.
%   Coded by Lu Zhang; math2437@hotmail.com
%   Last updated: (24th April 2018)

%Output:
%sample is the vectorized spectrum normalized in theta phase
%ThetaTS(i) is timeStamps(theta trough) of sample(:,i)


%LFP: raw LFPs
%LFP: filtered LFPs in theta Band
%thetaphase: phase of filtered LFPs, usually calculated by hilbert transform;
%samprate: sampling rate;
%timerange: analysis period.[1 40 120;30 88 160] indicate 1-30s,
%40-88s and 120-160s for three analysis period in total;

% % Default setting
%WaveParam.ntw=100;      smoothing time-window 100
%WaveParam.nsw=3;        smoothing fre-window 3
%WaveParam.smoothW=10;   smoothing Power
%WaveParam.DownSample=5; DownSampling
%WaveParam.wname='morl'; Wavelet Name
%WaveParam.samprateD=samprateD;
%WaveParam.Freq=[1:150]; Frequeny band interested
% % Default setting


if nargin<4
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
PhaseNum=20;
PhaseStep=2*pi/PhaseNum;
PhaseBin=-pi:PhaseStep:pi;
SavePath=[];
SaveShow=[];

% Default setting
elseif nargin==4
WaveParam=varargin{1};
WaveParam.samprate=samprate;
SavePath=[];
SaveShow=[];

PhaseNum=20;
PhaseStep=2*pi/PhaseNum;
PhaseBin=-pi:PhaseStep:pi;
elseif nargin==5
WaveParam=varargin{1};
WaveParam.samprate=samprate;
Param=varargin{2};
PhaseBin=Param.PhaseBin;
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
ThetaTimeStamps=[];

if isempty(timerange)
    sample=[];
    ThetaTS=[];
    F=WaveParam.Freq;
    Fplot=F(end:-1:1);
    
% %     if ~isempty(SavePath)
% % % %     save([SavePath SaveShow '.mat'],'sample','ThetaTS','LFPOutput','WaveParam','PhaseBin','timerange');
% %     save([SavePath SaveShow '.mat'],'sample','ThetaTS','LFPOutput','WaveParam','PhaseBin','Fplot','Div','timerange');
% %     end
    return
end

tic
Duration=round(diff(timerange));
NumThetaPeriod=length(Duration);

% Istart=round(timerange(1,:)*samprate)+1;
% Iend=round(timerange(2,:)*samprate)+1;
% timerangeI=round(timerange*samprate)+1;

PSD=[];
LFPtemp=decimate(LFP,WaveParam.DownSample);
samprateD=samprate/WaveParam.DownSample;
F=WaveParam.Freq;
wname=WaveParam.wname;
ntw=WaveParam.ntw;
nsw=WaveParam.nsw;
bin_width=1/samprateD;
fc = centfrq(wname);
scales=sort(fc./F.*samprateD);
S1Power = waveletLU(LFPtemp,scales,wname,'ntw',ntw,'nsw',nsw);
time=([1:size(S1Power,2)]-1)/samprateD;
NeedI=[];

timeI=round(timerange*samprateD);
I1=timeI(timeI(1,:)<1);
timeI(:,I1)=[];
I2=timeI(timeI(2,:)>=length(LFPtemp));
timeI(2,I2)=length(LFPtemp);


for ii=1:length(Duration)
%     NeedI=[NeedI find(time<=timerange(2,ii)>time>=timerange(1,ii))];
    NeedI=[NeedI timeI(1,ii):timeI(2,ii)];
end
PSD=nanmean(S1Power(:,NeedI),2);

%%%%%%%%ii loops      multiple theta period in one recording file
   
Fplot=WaveParam.Freq(end:-1:1);
    
if ~isempty(SavePath)
   save([SavePath SaveShow '.mat'],'PSD','Fplot');
end


toc




