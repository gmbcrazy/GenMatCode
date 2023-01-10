function [Output,OutputTotal] = GT_CrossFre(processeddatadir,FileIndex,samprate,varargin)
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
%           varargin{1}  Param=>wavelet parameter structure.
%           varargin{2}  SavePath=> Path to save the data.
%           varargin{3}  FigureP=>0 Plot Figure and Save.

% % Default setting
%Param.ntw=100;      smoothing time-window 100
%Param.nsw=3;        smoothing fre-window 3
%Param.smoothW=10;   smoothing Power
%Param.DownSample=5; DownSampling
%Param.wname='morl'; Wavelet Name
%Param.samprateD=samprateD;
%Param.Freq=[1:150]; Frequeny band interested
% % Default setting

% % Param.range=[-2 2];
% % Param.DownSample=5;
% % WaveTick=[0 20 40];
% % timerange=[0;length(RawData)]/raweeg{1}{end}{2}.samprateD;
% % F=Param.Freq;
% % wname=Param.wname;
% % samprateD=Param.samprateD;
% % ntw=Param.ntw;
% % nsw=Param.nsw;


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
measure='esc';
% sig_mod=RawData;
plt='n';
waitbar=0;
width  = 7;

if nargin<4
% Default setting
Param.FrePhase=[4:0.5:40];      %Fre for phase signal
Param.FreAmp=[10:0.5:200];      %Fre for Amplitude signal
Param.DownSample=5; %DownSampling
Param.samprate=samprate;
% Param.width=7;
Param.nfft=2048;
Param.num_shf=0;
Param.alpha=0.05;
Param.measure='pac';

SavePath=[];
% Default setting
elseif nargin==4
Param=varargin{1};
Param.samprate=samprate;
SavePath=[];
FigureP=0;
elseif nargin==5
Param=varargin{1};
Param.samprate=samprate;
SavePath=varargin{2};
FigureP=0;

elseif nargin==6
Param=varargin{1};
Param.samprate=samprate;
SavePath=varargin{2};
FigureP=varargin{3};

else
    
end
% % Param.range=[-2 2];
% % Param.DownSample=5;
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

animaldir = [processeddatadir, 't',num2str(FileIndex(i,1)), '_', num2str(FileIndex(i,2)) , '\'];
clear eeg thetas theta LFP LFPtheta
    f=FileIndex(i,3);
load([animaldir,'eeg',num2str(f),'.mat']); %broadgamma periods start/end indices
load([animaldir,'thetas',num2str(f),'.mat']); %theta periods start/end indices
load([animaldir,'fileinfo',num2str(f),'.mat']); %theta periods start/end indices

index=FileIndex(i,1:2);
Output(i).FileInfo=fileinfo;
Output(i).FileIndex=FileIndex(i,:);


LFP=eeg{index(1)}{index(2)}{end}.data;
thetas = thetas{index(1)}{index(2)}{f}; %main theta structure

Duration=round(sum((thetas.endind-thetas.startind+1)/samprate));
NumThetaPeriod=length(thetas.startind);

DurationTotal(i)=Duration;
NumThetaPeriodTotal(i)=NumThetaPeriod;

Infoshow{i}=['Animal-' num2str(fileinfo.Animal) ' Date-' num2str(fileinfo.Date) ' File-' ...
    num2str(f) ' Depth-' num2str(fileinfo.Depth) ' Stim-' fileinfo.Stimulation ' NumThetaP-' num2str(NumThetaPeriod) ' ' num2str(Duration) 'Sec'];

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
Output(i).S1=[];
Output(i).Famp=[];
Output(i).Fphase=[];
Output(i).Duration=[];

fprintf(1,['no theta period detected in File ' Infoshow{i}])
fprintf(1, '\n');
continue

else
    iPlot=iPlotTemp-(Page-1)*PageNum;
    if iPlot>PageNum
       iPlot=iPlot-PageNum;
       Page=Page+1;
    end
    iPlotTemp=iPlotTemp+1;

end


clear thetamax_ts
%%%%%%%%ii loops      multiple theta period in one recording file
Output(i).Duration=[];

for ii=1:length(thetas.startind)
    tic

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
    
    LFPtemp=zscore(decimate(LFPtemp,Param.DownSample));
    LFPthetatemp=downsample(LFPthetatemp,Param.DownSample);
        
    samprateD=samprate/Param.DownSample;
[S1Power, Fphase, Famp] = find_pac_shf (LFPtemp, samprateD, Param.measure, ...
    LFPtemp, Param.FrePhase, Param.FreAmp, plt, waitbar, width, Param.nfft, Param.num_shf, Param.alpha);

Output(i).Duration=[Output(i).Duration;length(LFPtemp)/samprateD];


%%%%%%%%%Results for Multiple Theta Periods in One File
if ii==1
Temp2=S1Power*Output(i).Duration(ii);
else
Temp2=Temp2+S1Power*Output(i).Duration(ii);
end
%%%%%%%%%Results for Multiple Theta Periods in One File






    toc

end
%%%%%%%%ii loops      multiple theta period in one recording file
Output(i).Famp=Famp;
Output(i).Fphase=Fphase;
Output(i).S1=Temp2/sum(Output(i).Duration);
clear Temp2;

% % %%%%%%%%%Total Results for Multiple Files 



% % if FigureP==1
% % figure(Page);
% % 
% % subplot('position',[Xleft 1-Ytop-iPlot*Ywidth-(iPlot-1)*YInt Xwidth(1) Ywidth]);
% % imagesc(Output(i).Fphase,Output(i).Famp,Output(i).S1);axis xy;
% % if iPlot==PageNum
% %    set(gca,'ylim',Output(i).Fphase([1 end]),'clim',[-0.1 0.4],'box','off','tickdir','out');hold on
% % else 
% %    set(gca,'ylim',Output(i).Fphase([1 end]),'clim',[-0.1 0.4],'box','off','tickdir','out','xticklabel',[]);hold on
% % end
% % plot(Range,Temp5*150+50,'b','linewidth',1)
% % colormap(jet)
% % 
% % text(Range(1),max(Param.Freq)+5,Infoshow{i},'horizontalalignment','left','verticalalignment','bottom','fontsize',7);
% % 
% % papersizePX=[0 0 18 15];
% % set(gcf, 'PaperUnits', 'centimeters');
% % set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));
% % 
% % end

end

icount=1;
for i=1:length(Output)
    if ~isempty(Output(i).S1)&&icount==1
       TotalS1=Output(i).S1;
       icount=2;
       TotalDuration(i)=sum(Output(i).Duration);
    else
    TotalDuration(i)=sum(Output(i).Duration);
    if TotalDuration(i)~=0
    TotalS1=TotalS1+Output(i).S1*TotalDuration(i);
    end

    end
end
TotalS1=TotalS1/sum(TotalDuration);

OutputTotal.S1=TotalS1;
OutputTotal.Duration=TotalDuration;
OutputTotal.Famp=Famp;
OutputTotal.Fphase=Fphase;
OutputTotal.FileNum=length(Output);
OutputTotal.FileInfo=FileIndex;




% 
% if FigureP==1&&~isempty(SavePath)
% 
% % for Pagei=1:Page
% % figure(Pagei);
% % papersizePX=[0 0 20 24];
% % set(gcf, 'PaperUnits', 'centimeters');
% % set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));
% % 
% % if ~isempty(SavePath)
% % saveas(gcf,[SavePath 'Animal-' num2str(fileinfo.Animal) 'Date-' num2str(fileinfo.Date) ' Page-' num2str(Pagei)],'png'); 
% % end
% % 
% % end
% % 
% % InfoTotal=['NumFile' num2str(OutputTotal.FileNum) ' NumThetaPeriod-' num2str(sum(OutputTotal.NumThetaPeriodTotal)) ' Duration-' num2str(sum(OutputTotal.DurationTotal)) 's'];
% % figure;
% % subplot('position',[0.1 0.58 0.8 0.35]);
% % imagesc(Range,OutputTotal.F,log2(abs(OutputTotal.AlignS1')));axis xy;
% % text(Range(1),max(Param.Freq)+5,InfoTotal,'horizontalalignment','left','verticalalignment','bottom','fontsize',7);
% % set(gca,'ylim',[0;Param.Freq(end)],'clim',[-4 2],'ytick',[0:50:Param.Freq(end)],'box','off','tickdir','out');hold on
% % 
% % 
% % plot(Range,Temp5*100+50,'b','linewidth',2)
% % legend('Averaged LFP theta band')
% % colormap(jet)
% % % contour(Range,F(end:-1:1),SigS2',0.5,'k')
% % xlabel('Time from Theta Trough s');ylabel('Frequency Hz');
% % b=colorbar;set(b,'position',[0.92 0.58 0.02 0.35],'ytick',[-8:2])
% % ylabel(b,'Log Wavelet Power');
% 
% 
% % 
% % if ~isempty(SavePath)
% % saveas(gcf,[SavePath 'Animal-' num2str(fileinfo.Animal) 'Date-' num2str(fileinfo.Date) ' All'],'png'); 
% % close all
% % end
% 
% end
% 
% if ~isempty(SavePath)
% save([SavePath 'Animal-' num2str(fileinfo.Animal) 'Date-' num2str(fileinfo.Date) '.mat'],'Output','OutputTotal');
% end



