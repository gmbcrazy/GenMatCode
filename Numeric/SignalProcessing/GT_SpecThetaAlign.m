function [Output,OutputTotal] = GT_SpecThetaAlign(processeddatadir,FileIndex,samprate,FbandC_All,varargin)
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
% Default setting
elseif nargin==5
WaveParam=varargin{1};
WaveParam.samprate=samprate;
SavePath=[];
FigureP=0;
elseif nargin==6
WaveParam=varargin{1};
WaveParam.samprate=samprate;
SavePath=varargin{2};
FigureP=0;

elseif nargin==7
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
Output(i).AlignS1=[];
Output(i).F=[];
Output(i).Theta=[];
Output(i).Range=[];
Output(i).R=R_Fall;
Output(i).Rbin=Rbin_Fall;
Output(i).Rmean=Rmean_Fall;
Output(i).Rstd=Rstd_Fall;

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
% S1Power=zscore(S1Power,0,2);  %%%%%%%%%%%%%normalize over time
S1Power=zscore(S1Power,0,1);  %%%%%%%%%%%%%normalize over frequency

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


if ii==1
Temp2=zeros(BackW+ForW+1,size(S1Power,1),1);
% Temp2(:,:)=nan;
Temp4=zeros(BackW+ForW+1,1);
% Temp4(:,:)=nan;

for iii=1:(length(thetamax_ind))
    s=round(max(thetamax_ind(iii)-BackW,1));
    o=round(min(thetamax_ind(iii)+ForW,len_t));
    l=round(o-s);
    s1=round(max(s-thetamax_ind(iii)+BackW,1));
    
    if iii==1
Temp2(s1:(s1+l),:,1)=S1Power(:,s:o)';
Temp4(s1:(s1+l),1)=LFPthetatemp(s:o,1);
    else
Temp2(s1:(s1+l),:,end+1)=S1Power(:,s:o)';
Temp4(s1:(s1+l),end+1)=LFPthetatemp(s:o,1);
       
    end
% Temp5=Temp5+Temp4;

end

else
 for iii=1:(length(thetamax_ind))
    s=round(max(thetamax_ind(iii)-BackW,1));
    o=round(min(thetamax_ind(iii)+ForW,len_t));
    l=round(o-s);
    s1=round(max(s-thetamax_ind(iii)+BackW,1));
    
    Temp2(s1:(s1+l),:,end+1)=S1Power(:,s:o)';
    Temp4(s1:(s1+l),end+1)=LFPthetatemp(s:o,1);
       
end

end



% % % FbandC_All=[20 40 60 80;40 60 80 100];
ColorStep=1/(size(FbandC_All,2)+3);
% ColorAll=[176 19 82;245 150 14;10 240 14;16 178 197;40 40 255;35 17 151]/255;
% ColorAll=colormap(jet);
ColorAll=jet(size(FbandC_All,2));

% % close;

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





for iband=1:size(FbandC_All,2)
    
FbandC=FbandC_All(:,iband);
IndexF=find(FPlot>=FbandC(1)&FPlot<FbandC(2));
if ii==1
a=mean(S1Power(IndexF,:),1);
P2band{iband}=a(:);
else
a=mean(S1Power(IndexF,:),1);
P2band{iband}=[P2band{iband};a(:)];
clear a
end

% % 
end


    toc

end
%%%%%%%%ii loops      multiple theta period in one recording file


% % %%%%%%%%%Total Results for Multiple Files 
% % if iPlot==1
% %    Temp2All=Temp2File;
% %    Temp4All=Temp4File;
% % else
% %    Temp2All=cat(3,Temp2All,Temp2File);
% %    Temp4All=cat(2,Temp4All,Temp4File);
% % end
% % %%%%%%%%%Total Results for Multiple Files 



AlignS1=AlignS1/sum(tempN);
% mean(Temp2File,3)
Temp5=Temp5/sum(tempN);
% Temp5=mean(Temp4File,2);
Range=[(-BackW):1:ForW]/samprateD;


Output(i).AlignS1=AlignS1;
Output(i).AlighNum=sum(tempN);
Output(i).F=FPlot;
Output(i).Theta=Temp5;
AlignSample(i)=Output(i).AlighNum;
Output(i).Duration=sum(Duration);
Output(i).NumThetaPeriod=NumThetaPeriod;

clear tempN


if FigureP==1
figure(Page);

subplot('position',[Xleft 1-Ytop-iPlot*Ywidth-(iPlot-1)*YInt Xwidth(1) Ywidth]);
imagesc(Range,FPlot,((AlignS1')));axis xy;
if iPlot==PageNum
   set(gca,'ylim',[0;WaveParam.Freq(end)],'clim',[-1 2],'ytick',[0:50:WaveParam.Freq(end)],'box','off','tickdir','out');hold on
else 
   set(gca,'ylim',[0;WaveParam.Freq(end)],'clim',[-1 2],'ytick',[0:50:WaveParam.Freq(end)],'box','off','tickdir','out','xticklabel',[]);hold on
end
plot(Range,Temp5*150+50,'b','linewidth',1)
colormap(jet)

text(Range(1),max(WaveParam.Freq)+5,Infoshow{i},'horizontalalignment','left','verticalalignment','bottom','fontsize',7);

% legend('Averaged LFP theta band')

% contour(Range,F(end:-1:1),SigS2',0.5,'k')
if iPlot==PageNum
xlabel('Time from Theta Trough s');

elseif iPlot==round(PageNum/2)
ylabel('Frequency Hz');
end
% b=colorbar;set(b,'position',[0.92 0.3 0.02 0.4],'ytick',[-6:1:1])
% ylabel(b,'Log Wavelet Power')
papersizePX=[0 0 18 15];
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));

end


if iPlot==1
   PhaseTotal=tempPhase(:);
   P2Total=[];
   for iband=1:size(FbandC_All,2)
       P2Total=[P2Total P2band{iband}];
   end
else
   PhaseTotal=[PhaseTotal;tempPhase(:)];
   
   P3Total=[];
   for iband=1:size(FbandC_All,2)
       P3Total=[P3Total P2band{iband}];
   end
   P2Total=[P2Total;P3Total];
   clear P3Total
end


if FigureP==1
figure(Page);
subplot('position',[Xleft+Xwidth(1)+XInt 1-Ytop-iPlot*Ywidth-(iPlot-1)*YInt Xwidth(2) Ywidth]);
end
LimM=2;
R_Fall=[];
Rstd_Fall=[];
Rbin_Fall=[];
Rmean_Fall=[];
tempFF=mean(FbandC_All);
tempFF=tempFF([1 end]);
for iband=1:size(FbandC_All,2)
%     ColorFbandC=ColorStep*(iband-1)+[0 0 0]; 
   P2band{iband}=P2band{iband}-min(P2band{iband});
   P2band{iband}=P2band{iband}/sum(P2band{iband})*length(P2band{iband});
   [R,Rstd,Rbin,Rmean]=HistPolarData(tempPhase,P2band{iband},10);
   R_Fall=[R_Fall R(:)];
   Rstd_Fall=[Rstd_Fall Rstd(:)];
   Rbin_Fall=[Rbin_Fall Rbin(:)];
   Rmean_Fall=[Rmean_Fall Rmean(:)];

%     LimM=max(LimM,max(R_Fall(:,iband)+Rstd_Fall(:,iband)));
%     LimM=ceil(LimM/1)*1;

Output(i).R=R_Fall;
Output(i).Rbin=Rbin_Fall;
Output(i).Rmean=Rmean_Fall;
Output(i).Rstd=Rstd_Fall;
Output(i).Range=Range;
Output(i).FileInfo=FileIndex(i,:);

if FigureP==1

ColorFbandC=ColorAll(iband,:);
polar_errorArea(Rbin_Fall(:,iband)'+pi,R_Fall(:,iband)',Rstd_Fall(:,iband)',ColorFbandC,0,LimM+2,Rmean_Fall(1,iband)'+pi);hold on
end
% text(LimM,LimM,['Freq ' num2str(FbandC(1)) '-' num2str(FbandC(2)) 'Hz'],'horizontalalignment','right')
% % 
end

if FigureP==1
figure(Page);

subplot('position',[Xleft+sum(Xwidth(1:2))+2*XInt 1-Ytop-iPlot*Ywidth-(iPlot-1)*YInt Xwidth(3) Ywidth]);
for iband=1:size(FbandC_All,2)
%     ColorFbandC=ColorStep*(iband-1)+[0 0 0];
    ColorFbandC=ColorAll(iband,:);
polar_errorArea(Rbin_Fall(:,iband)'+pi,R_Fall(:,iband)',Rstd_Fall(:,iband)',ColorFbandC,0,LimM,Rmean_Fall(1,iband)'+pi,2);hold on
legendN{iband}=[num2str(FbandC_All(1,iband)) '-' num2str(FbandC_All(2,iband)) 'Hz'];
end



if iPlot==1
% t1=legend(legendN,'fontsize',5);
% set(t1,'position',[0.88 0.95 0.08 0.01]);
b=colorbar;
set(gca,'clim',tempFF)
set(b,'location','northoutside','position',[Xleft+sum(Xwidth(1:2))+2*XInt++Xwidth(3)/2 1-Ytop-iPlot*Ywidth-(iPlot-1)*YInt+Ywidth/10*9 Xwidth(3)/2 Ywidth/20],...
    'xtick',[10:40:250],'xlim',tempFF,'fontsize',6);
xlabel(b,'Freq Hz','fontsize',6,'verticalalignment','bottom')

end

% ylabel('Vector Length');
if iPlot==PageNum
xlabel('Theta Phase degree')
end
set(gca,'box','off','tickdir','out');hold on

end
end

IndexEmpty=[];
for i=1:length(Output)
    if isempty(Output(i).F) 
       IndexEmpty=[IndexEmpty;i];
    end
end

Output(IndexEmpty)=[];


% TotalAlignS1=mean(Temp2All,3);
% TotalTheta=mean(Temp4All,2);
TotalAlignS1=zeros(size(Output(1).AlignS1));
TotalTheta=zeros(size(Output(1).Theta));
for i=1:length(Output)
    TotalAlignS1=TotalAlignS1+Output(i).AlignS1*AlignSample(i);
    TotalTheta=TotalTheta+Output(i).Theta*AlignSample(i);
end
TotalTheta=TotalTheta/sum(AlignSample);
TotalAlignS1=TotalAlignS1/sum(AlignSample);


OutputTotal.AlignS1=TotalAlignS1;
OutputTotal.Theta=TotalTheta;
OutputTotal.F=FPlot;


   
R_Fall=[];
Rstd_Fall=[];
Rbin_Fall=[];
Rmean_Fall=[];

for iband=1:size(FbandC_All,2)
   P2Total(:,iband)=P2Total(:,iband)-min(P2Total(:,iband));
   P2Total(:,iband)=P2Total(:,iband)/sum(P2Total(:,iband))*length(P2Total(:,iband));
   [R,Rstd,Rbin,Rmean]=HistPolarData(PhaseTotal,P2Total(:,iband),10);
   
   R_Fall=[R_Fall R(:)];
   Rstd_Fall=[Rstd_Fall Rstd(:)];
   Rbin_Fall=[Rbin_Fall Rbin(:)];
   Rmean_Fall=[Rmean_Fall Rmean(:)];

end
OutputTotal.R=R_Fall;
OutputTotal.Rbin=Rbin_Fall;
OutputTotal.Rmean=Rmean_Fall;
OutputTotal.Rstd=Rstd_Fall;
OutputTotal.DurationTotal=DurationTotal;
OutputTotal.NumThetaPeriodTotal=NumThetaPeriodTotal;
OutputTotal.FileNum=length(Output);
OutputTotal.Range=Range;
OutputTotal.FileInfo=FileIndex;


if FigureP==1&&~isempty(SavePath)

for Pagei=1:Page
figure(Pagei);
papersizePX=[0 0 20 24];
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));

if ~isempty(SavePath)
saveas(gcf,[SavePath 'Animal-' num2str(fileinfo.Animal) 'Date-' num2str(fileinfo.Date) ' Page-' num2str(Pagei)],'png'); 
end

end

InfoTotal=['NumFile' num2str(OutputTotal.FileNum) ' NumThetaPeriod-' num2str(sum(OutputTotal.NumThetaPeriodTotal)) ' Duration-' num2str(sum(OutputTotal.DurationTotal)) 's'];
figure;
subplot('position',[0.1 0.58 0.8 0.35]);
imagesc(Range,OutputTotal.F,((OutputTotal.AlignS1')));axis xy;
text(Range(1),max(WaveParam.Freq)+5,InfoTotal,'horizontalalignment','left','verticalalignment','bottom','fontsize',7);
set(gca,'ylim',[0;WaveParam.Freq(end)],'clim',[-1 2],'ytick',[0:50:WaveParam.Freq(end)],'box','off','tickdir','out');hold on


plot(Range,Temp5*100+50,'b','linewidth',2)
legend('Averaged LFP theta band')
colormap(jet)
% contour(Range,F(end:-1:1),SigS2',0.5,'k')
xlabel('Time from Theta Trough s');ylabel('Frequency Hz');
b=colorbar;set(b,'position',[0.92 0.58 0.02 0.35],'ytick',[-8:2])
ylabel(b,'Log Wavelet Power');


for iband=1:size(FbandC_All,2)
% LimM=0.4;
ColorFbandC=ColorAll(iband,:);

subplot('position',[0.08 0.1 0.38 0.38])
polar_errorArea(OutputTotal.Rbin(:,iband)+pi,OutputTotal.R(:,iband),OutputTotal.Rstd(:,iband),ColorFbandC,0,LimM+2,OutputTotal.Rmean(1,iband)+pi)
end

for iband=1:size(FbandC_All,2)
subplot('position',[0.58 0.1 0.38 0.38])

ColorFbandC=ColorAll(iband,:);

polar_errorArea(OutputTotal.Rbin(:,iband)+pi,OutputTotal.R(:,iband),OutputTotal.Rstd(:,iband),ColorFbandC,0,LimM,OutputTotal.Rmean(1,iband)+pi,2)
ylabel('Normalized LFP Power');xlabel('Theta Phase degree')
set(gca,'box','off','tickdir','out');hold on

legendNTotal{iband}=[num2str(FbandC_All(1,iband)) '-' num2str(FbandC_All(2,iband)) 'Hz'];
end
% t1=legend(legendNTotal,'fontsize',8);
% set(t1,'position',[0.75 0.43 0.2 0.05]);
b=colorbar;
set(gca,'clim',tempFF)
set(b,'location','northoutside','position',[0.77 0.45 0.19 0.02],...
    'xtick',[10:40:250],'xlim',tempFF,'fontsize',6);
xlabel(b,'Freq Hz','fontsize',6,'verticalalignment','bottom')

papersizePX=[0 0 16 16];
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));

if ~isempty(SavePath)
saveas(gcf,[SavePath 'Animal-' num2str(fileinfo.Animal) 'Date-' num2str(fileinfo.Date) ' All'],'png'); 
close all
end

end

if ~isempty(SavePath)
save([SavePath 'Animal-' num2str(fileinfo.Animal) 'Date-' num2str(fileinfo.Date) '.mat'],'Output','OutputTotal');
end



