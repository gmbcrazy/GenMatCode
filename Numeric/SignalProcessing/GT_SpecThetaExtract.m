function [ThetaSpec,ThetaPhase,LFPOutput] = GT_SpecThetaExtract(processeddatadir,FileIndex,samprate,varargin)
%   GT_WaveLet get wavelet Power in time&frequency domain representation
%   
%   INPUTS: index=> [animal#,YYMMDD], session index
%           files=> 3 coloum matrix

%           Animal   Date     Session
%            4      150626       34
%            4      150626       35
%            4      150626       36
%            4      150626       37
%            4      150626       38
%            4      150626       39
%            4      150626       40
%            4      150626       41
%            4      150626       42
%           processeddatadir=> processed data directory
%           timerange=> Analysis period in seconds [5;30] refers to 5-30s 
%           samprateD=> sampling rate of the data (Hz)
%           varargin{1}  WaveParam=>wavelet parameter structure.
%           varargin{2}  SavePath=> Path to save the data.
%           varargin{3}  FigureP=>0 Plot Figure and Save.

% % Default setting
%WaveParam.ntw=100;      smoothing time-window 100
%WaveParam.nsw=3;        smoothing fre-window 3
%WaveParam.smoothW=10;   smoothing Power
%WaveParam.DownSample=5; DownSampling
%WaveParam.wname='morl'; Wavelet Name
%WaveParam.samprateD=samprateD;
%WaveParam.Freq=[1:150]; Frequeny band interested
% % Default setting

% % WaveParam.range=[-2 2];
% % WaveParam.DownSample=5;
% % WaveTick=[0 20 40];
% % timerange=[0;length(RawData)]/raweeg{1}{end}{2}.samprateD;
% % F=WaveParam.Freq;
% % wname=WaveParam.wname;
% % samprateD=WaveParam.samprateD;
% % ntw=WaveParam.ntw;
% % nsw=WaveParam.nsw;


%   OUTPUTS: allcounts=> inst freq count histogram 
%           allpower=> z-score histogram 
%           stats=> matrix of statistics, each row an index included in the
%           session. Column 1-3 is the index of the animal
%           [animal#,YYMMDD,recoring#], 4 is the number of broadgamma periods
%           in that recording, 5 is the number of broadgamma peaks in the
%           recording.  
%   NOTE:   counts is normalized by the total number of broadgamma
%           inst freq in the session. Power is a normalized z-score

%   Coded by Lu Zhang
%   Last updated: (26th Sept 2017)

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

SavePath=[];
% Default setting
elseif nargin==4
WaveParam=varargin{1};
WaveParam.samprate=samprate;
SavePath=[];
FigureP=0;
elseif nargin==5
WaveParam=varargin{1};
WaveParam.samprate=samprate;
SavePath=varargin{2};
FigureP=0;

elseif nargin==6
WaveParam=varargin{1};
WaveParam.samprate=samprate;
SavePath=varargin{2};
FigureP=varargin{3};

else
    
end
% % WaveParam.range=[-2 2];
% % WaveParam.DownSample=5;
% % WaveTick=[0 20 40];
% % timerange=[0;length(RawData)]/raweeg{1}{end}{2}.samprateD;
Xleft=0.08;
Xright=0.05;
Xwidth=[0.34 0.15 0.1];
XInt=(1-Xleft-Xright-sum(Xwidth))/(length(Xwidth)-1);

Ytop=0.05;
Ylow=0.05;
YInt=0.05;
PageNum=5;
Ywidth=(1-Ytop-Ylow-(PageNum-1)*YInt)/PageNum;



clear Temp2 AlignS1 Temp4 Temp5
Page=1;iPlotTemp=1;
for i = 1:size(FileIndex,1) % for each file
    tic

ThetaSpec{i}={};
ThetaPhase{i}={};
LFPOutput{i}={};
    
animaldir = [processeddatadir, 't',num2str(FileIndex(i,1)), '_', num2str(FileIndex(i,2)) , '\'];
clear eeg thetas theta LFP LFPtheta
    f=FileIndex(i,3);
load([animaldir,'eeg',num2str(f),'.mat']); %broadgamma periods start/end indices
load([animaldir,'thetas',num2str(f),'.mat']); %theta periods start/end indices
load([animaldir,'fileinfo',num2str(f),'.mat']); %theta periods start/end indices

index=FileIndex(i,1:2);


Output(i).FileInfo=fileinfo;
LFP=eeg{index(1)}{index(2)}{end}.data;
thetas = thetas{index(1)}{index(2)}{f}; %main theta structure

Duration=round(sum((thetas.endind-thetas.startind+1)/samprate));
NumThetaPeriod=length(thetas.startind);

DurationTotal(i)=Duration;
NumThetaPeriodTotal(i)=NumThetaPeriod;

Infoshow{i}=['Animal-' num2str(fileinfo.Animal) ' Date-' num2str(fileinfo.Date) ' File-' ...
    num2str(f) ' Depth-' num2str(fileinfo.Depth) ' Stim-' fileinfo.Stimulation ' NumThetaP-' num2str(NumThetaPeriod) ' ' num2str(Duration) 'Sec'];
Saveshow{i}=['Animal-' num2str(fileinfo.Animal) ' Date-' num2str(fileinfo.Date) ' File-' ...
    num2str(f) ' Depth-' num2str(fileinfo.Depth)];

if f<10
   ff=['0' num2str(f)];
else
    ff=num2str(f);
end

if index(1)<10
    tt=['0' num2str(index(1))];
else
    tt=num2str(index(1));

end

tempName=['theta' tt '-' num2str(index(2)) '-' ff,'.mat'];
% 
% if index(1)<10
%    tempName=['theta0' num2str(index(1)) '-' num2str(index(2)) '-' num2str(f),'.mat'];
% else
%    tempName=['theta' num2str(index(1)) '-' num2str(index(2)) '-' num2str(f),'.mat']; 
% end

load([animaldir,'EEG\',tempName]); %theta periods start/end indices
LFPtheta=theta{index(1)}{index(2)}{f}.data;
clear Istart Iend 



if isempty(thetas.startind)
continue
end


clear thetamax_ts
%%%%%%%%ii loops      multiple theta period in one recording file
for ii=1:length(thetas.startind)

    %%%%%%%%Inlcuding 1s before the theta start and 1s after theta ends
    %%%%%%%%to avoid edge effects in time of Wavelet
    Istart(ii)=max(thetas.startind(ii)-samprate,1);
    Iend(ii)=min(thetas.endind(ii)+samprate,length(LFPtheta(:,1)));
    tempI=Istart(ii):Iend(ii);
    TimeExclude=[thetas.startind(ii)-Istart(ii) Iend(ii)-thetas.endind(ii)]/samprate;
    TimeInclude=([Istart(ii) Iend(ii)]-Istart(ii))/samprate;
    TimeInclude=[TimeInclude(1)+TimeExclude(1) TimeInclude(2)-TimeExclude(2)];
    
    
    LFPtemp=LFP(tempI);
    LFPthetatemp=LFPtheta(tempI,:);
    
    LFPtemp=zscore(decimate(LFPtemp,WaveParam.DownSample));
    LFPthetatemp=downsample(LFPthetatemp,WaveParam.DownSample);
        
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
   S1Power=zscore(S1Power,0,2);  %%%%%%%%%%%%%normalize over time
% S1Power=zscore(S1Power,0,1);  %%%%%%%%%%%%%normalize over frequency
end


Time=([1:length(LFPtemp)]-1)/samprateD;
FPlot=F(end:-1:1);





temp=LFPthetatemp(:,2);
len_t=length(temp);
         thetamax_ts=[];
         for j=1:len_t
             if j==1&&temp(j)<-3.141
                 thetamax_ts=[thetamax_ts,j];
             elseif j==len_t&&temp(j)<-3.141
                 thetamax_ts=[thetamax_ts,j];
             elseif j~=1&&j~=len_t
                 if (temp(j-1)-temp(j))>6.0&&(temp(j+1)-temp(j))>0
                     thetamax_ts=[thetamax_ts,j-1+(pi-temp(j-1))/((pi-temp(j-1))+(pi+temp(j)))];

                 end
             else
                 
             end
         end
thetamax_ts=(thetamax_ts-1)/samprateD;
thetamax_ts(thetamax_ts>TimeInclude(2))=[];
thetamax_ts(thetamax_ts<TimeInclude(1))=[];

thetamax_ind=round(thetamax_ts*samprateD);
% thetamax_ts=round(thetamax_ts);
% % figure;
% % % plot(LFPthetatemp(:,2));hold on;plot(thetamax_ind,-pi,'r.')
% % plot(LFPthetatemp(:,1));hold on;plot(thetamax_ind,0,'r.')

BackW=round(WaveParam.Range*samprateD);
ForW=BackW;

if ii==1
    tempPhase=LFPthetatemp(:,2);
else
    tempPhase=[tempPhase;LFPthetatemp(:,2)];
end



for iii=1:(length(thetamax_ind)-1)
    
    s=round(max(thetamax_ind(iii),1));
    o=round(min(thetamax_ind(iii+1),len_t));
    ThetaSpec{i}{end+1,1}=S1Power(:,s:o)';
    ThetaPhase{i}{end+1,1}=LFPthetatemp(s:o,2);
    LFPOutput{i}{end+1,1}=LFPtemp(s:o);
end



end
%%%%%%%%ii loops      multiple theta period in one recording file
    ThetaSpecDay=ThetaSpec{i};
    ThetaPhaseDay=ThetaPhase{i};
    InfoShowDay=Infoshow{i}
   if ~isempty(SavePath)
     save([SavePath Saveshow{i} '.mat'],'ThetaSpecDay','ThetaPhaseDay','InfoShow');
   end
    toc

end
% %    if ~isempty(SavePath)
% %      save([SavePath 'Animal-' num2str(fileinfo.Animal) 'Date-' num2str(fileinfo.Date) 'All.mat'],'ThetaSpec','ThetaPhase');
% %    end
% % 



