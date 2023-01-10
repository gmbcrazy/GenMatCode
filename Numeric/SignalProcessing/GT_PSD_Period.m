function [Output,OutputTotal] = GT_PSD_Period(processeddatadir,FileIndex,psdParameter,KeyWord,varargin)

%   PowerSpectrumDensity
%   
%   INPUTS: 
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
%           samprate=> sampling rate of the data (Hz)
%           KeyWord=> an string as 'thetas', 'nonthetas' to load time
%           periods in preprocessing data; and set analysis period as
%           in start and end period in variables loaded 

%           varargin{1}  WaveParam=>wavelet parameter structure.
%           varargin{2}  SavePath=> Path to save the data.
%           varargin{3}  FigureP=>0 Plot Figure and Save.

% % Default setting
%WaveParam.ntw=100;      smoothing time-window 100
%WaveParam.nsw=3;        smoothing fre-window 3
%WaveParam.smoothW=10;   smoothing Power
%WaveParam.DownSample=5; DownSampling
%WaveParam.wname='morl'; Wavelet Name
%WaveParam.samprate=samprate;
%WaveParam.Freq=[1:150]; Frequeny band interested
% % Default setting

% % WaveParam.range=[-2 2];
% % WaveParam.DownSample=5;
% % WaveTick=[0 20 40];
% % timerange=[0;length(RawData)]/raweeg{1}{end}{2}.samprate;
% % F=WaveParam.Freq;
% % wname=WaveParam.wname;
% % samprate=WaveParam.samprate;
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
% Fs=psdParameter.Fs;
% window=psdParameter.window;
% noverlap=psdParameter.noverlap;
% nfft=psdParameter.nfft;


% % Xleft=0.08;
% % Xright=0.05;
% % Xwidth=[0.34 0.15 0.1];
% % XInt=(1-Xleft-Xright-sum(Xwidth))/(length(Xwidth)-1);
% % 
% % Ytop=0.05;
% % Ylow=0.05;
% % YInt=0.05;
% % PageNum=5;
% % Ywidth=(1-Ytop-Ylow-(PageNum-1)*YInt)/PageNum;

if nargin==4
   PlotP=0;
else
   SavePath=varargin{1};
   PlotP=1;
end


iii=1;

tempPxxAll=[];
clear Temp2 AlignS1 Temp4 Temp5
Page=1;iPlotTemp=1;
for i = 1:size(FileIndex,1) % for each file

animaldir = [processeddatadir, 't',num2str(FileIndex(i,1)), '_', num2str(FileIndex(i,2)) , '\'];
clear eeg PeriodsNeed theta LFP LFPtheta
    f=FileIndex(i,3);
load([animaldir,'eeg',num2str(f),'.mat']); %broadgamma periods start/end indices
%%%%%%%
PeriodsNeed=load([animaldir,KeyWord,num2str(f),'.mat'],KeyWord); %theta periods start/end indices
PeriodsNeed=getfield(PeriodsNeed,KeyWord);
%%%%%%%
load([animaldir,'fileinfo',num2str(f),'.mat']); %theta periods start/end indices

index=FileIndex(i,1:2);


Output(i).FileInfo=fileinfo;
LFP=eeg{index(1)}{index(2)}{end}.data;
samprate=eeg{index(1)}{index(2)}{end}.samprate;
PeriodsNeed = PeriodsNeed{index(1)}{index(2)}{f}; %main theta structure

Duration=round(sum((PeriodsNeed.endind-PeriodsNeed.startind+1)/samprate));
NumThetaPeriod=length(PeriodsNeed.startind);

DurationTotal(i)=Duration;
NumThetaPeriodTotal(i)=NumThetaPeriod;

Infoshow{i}=['Animal-' num2str(fileinfo.Animal) ' Date-' num2str(fileinfo.Date) ' File-' ...
    num2str(f) ' Depth-' num2str(fileinfo.Depth) ' Stim-' fileinfo.Stimulation ' NumThetaP-' num2str(NumThetaPeriod) ' ' num2str(Duration) 'Sec'];

clear Istart Iend 

Page=1;iPlotTemp=1;
PageNum=5;

if isempty(PeriodsNeed.startind)
    
% Output(i).Theta=[];
% Output(i).Range=[];
% Output(i).R=R_Fall;
% Output(i).Rbin=Rbin_Fall;
% Output(i).Rmean=Rmean_Fall;
% Output(i).Rstd=Rstd_Fall;

fprintf(1,['no ' KeyWord ' period detected in File ' Infoshow{i}])
fprintf(1, '\n');
continue

else
Output(iii).FileInfo=fileinfo;
Output(iii).S1=[];
Output(iii).F=[];

    iPlot=iPlotTemp-(Page-1)*PageNum;
    if iPlot>PageNum
       iPlot=iPlot-PageNum;
       Page=Page+1;
    end
    iPlotTemp=iPlotTemp+1;

end


clear thetamax_ts

if findstr(KeyWord,'ripple')    %%%%%%%%ripple events
   for ii=1:length(PeriodsNeed.startind)

    
    %%%%%%%%Inlcuding 1s before the period start and 1s after theta ends
    %%%%%%%%to avoid edge effects in time of Wavelet
    Istart(ii)=PeriodsNeed.midind(ii)-psdParameter.nfft;  
    Iend(ii)=PeriodsNeed.endind(ii)+psdParameter.nfft;      
    tempI=Istart(ii):Iend(ii);    
    tempI(tempI<1)=[];
    tempI(tempI>length(LFP))=[];
    LFPtemp=LFP(tempI);
    Data1(ii).Data=LFPtemp;
    Data1(ii).Time=(tempI-1)/psdParameter.Fs;
   end

else            %%%%%%%%theta/nontheta periods
%%%%%%%%ii loops      multiple analysis periods period in one recording file
for ii=1:length(PeriodsNeed.startind)

    
    %%%%%%%%Inlcuding 1s before the period start and 1s after theta ends
    %%%%%%%%to avoid edge effects in time of Wavelet
    Istart(ii)=PeriodsNeed.startind(ii);
    Iend(ii)=PeriodsNeed.endind(ii);
    tempI=Istart(ii):Iend(ii);    
    LFPtemp=LFP(tempI);
    Data1(ii).Data=LFPtemp;
    Data1(ii).Time=(tempI-1)/psdParameter.Fs;
end
end
%%%%%%%%ii loops      multiple analysis periods period in one recording file

%     [~,Sxx,~,k,w,options] = GT_welchCohLuTrial(LFPtemp(:),window,noverlap,nfft,Fs);
[Sxx{iii},w,options,~,WinNum{iii}]=psd_TrialData(Data1,psdParameter);
clear Data1

temp=repmat(WinNum{iii},size(Sxx{iii},2),1);

Sxx{iii}=sum(Sxx{iii},1);

WinNumSum(iii)=sum(WinNum{iii});
% [Pxx,f,~] = computepsd(Sxx{i}(:),w,options.range,options.nfft,options.Fs,'psd');
[Pxx,f,~] = computepsd(Sxx{iii}(:)/WinNumSum(iii),w,options.range,options.nfft,options.Fs);

Output(iii).S1=Pxx;
Output(iii).F=f;
Output(iii).Duration=sum(Duration);
Output(iii).NumThetaPeriod=NumThetaPeriod;

if iii==1
   tempPxxAll=Sxx{iii}(:);
else
   tempPxxAll=tempPxxAll+Sxx{iii}(:);
end
clear tempN
iii=iii+1;
end

if ~isempty(tempPxxAll)
[PxxTotal,f,~] = computepsd(tempPxxAll(:)/sum(WinNumSum),w,options.range,options.nfft,options.Fs);
end

OutputTotal.S1=PxxTotal;
OutputTotal.F=f;

figure;
subplot('position',[0.1 0.1 0.88 0.88])
if PlotP==1
   for i=1:length(Output)
       plot(f,log(Output(i).S1));set(gca,'xlim',[0 200]);hold on
       LegendN{i}=['Animal-' num2str(Output(i).FileInfo.Animal) ...
           ' Date-' num2str(Output(i).FileInfo.Date) ' File-' num2str(Output(i).FileInfo.File)];
   end
    LegendN{end+1}='Whole';
    plot(f,log(OutputTotal.S1),'r','linewidth',2);
       
set(gca,'xlim',[0 200],'xtick',[0:20:200]);hold on
b=legend(LegendN,'fontsize',8);
set(b,'position',[0.7 0.8 0.1 0.1]);

xlabel('Frequency Hz')
ylabel('Log Normalized PSD');

papersizePX=[0 0 10 10];
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));

saveas(gcf,[SavePath 'PSD-Animal-' num2str(fileinfo.Animal) 'Date-' num2str(fileinfo.Date)],'png'); 
close all

end







