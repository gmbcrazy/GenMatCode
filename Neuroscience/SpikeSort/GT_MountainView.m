function [Metric,templates,CorrectI]=GT_MountainView(Pathf,PathMda,varargin)
% % Pathf='Y:\singer\LuZhang Temp Data\MoutainLab\Output\ms3--d6\';
% % clear Amp Overlap OverlapR Non2 Imax I InvalidISIr


%%%%%%%%%This function extract sorting parameters from Mountainlab and set
%%%%%%%%%threshold for qualified cluster; visualise waveforms; 
%%%%%%%%%Lu Zhang 11/6/2017


%%Input
%%Pathf=varargin{1}
%%%%%%%%%%Pathf->folder for storing mountainlab output with firings.mda,etc with inside
%%%%%%%%%%ParaTh->Vector for Parameters 
%%ParaTh(1) %>=x of isolation (against other units) score was set as threshold
%%ParaTh(2) %<=x of noiseoverlaps (against random noise) score was set as threshold
%%ParaTh(3) %>=x of Peak Signal/Noise ratio as threshold
%%ParaTh(4) %<x of spikes falling into refactory period as threhsold
%%ParaTh(5) %Sampling rate
%%ParaTh(6) %RefactoryPeriod
%%ParaTh(7) %bin size in seconds for ratehistogram

%%PlotP=varargin{2}
%%PlotP =1  %plot and save waveforms;


%%Output
%%Metric -> Sorting Parameters readout from Mountainlab Sorting, firings.mda + isi +firing rate parameters
%%templates ->Averaged Waveform readout from Mountainlab Sorting, templates.mda
%%CorrectI ->Unit Index survived from sorting quality control, threshold with ParaTh


%%%default settings
thIsolation=0.95;   %%%%%>=0.95 of isolation (against other units) score was set as threshold
thNoise=0.1;        %%%%%<=0.1 of noiseoverlaps (against random noise) score was set as threshold
thSNR=1;            %%%%%>=1 of Peak Signal/Noise ratio as threshold
ISIth=0.001;        %%%%%<0.001 of spikes falling into refactory period as threhsold
SamplingR=20000;    %%%%%Sampling rate
RefactoryPeriod=0.001; %%RefactoryPeriod
RateBin=20;  %%bin size in seconds for ratehistogram
%%%default settings
DefaultP=[thIsolation thNoise thSNR ISIth SamplingR RefactoryPeriod RateBin];


if nargin<2 
   PathMda=Pathf;
   ParaTh=DefaultP;
   PlotP=1;
elseif nargin<3 
ParaTh=DefaultP;
PlotP=1;
elseif nargin==3
ParaTh=varargin{1};
PlotP=1;
else
ParaTh=varargin{1};
PlotP=varargin{2};
end

if isempty(ParaTh)
   ParaTh=DefaultP;
end


%%%%%%%%%%%%%%%making new sub folder matlab to save graphs
if PlotP==1
PathSave=[Pathf 'matlab\'];
A = exist(PathSave);
if A~=7
mkdir(PathSave);
end
clear A
end
%%%%%%%%%%%%%%%making new sub folder matlab to save graphs



thIsolation=ParaTh(1);   
thNoise=ParaTh(2);     
thSNR=ParaTh(3);        
ISIth=ParaTh(4);     
SamplingR=ParaTh(5);  
RefactoryPeriod=ParaTh(6); 
RateBin=ParaTh(7);  




Metric=GT_MountainResult([Pathf 'cluster_metrics.json']);
templates=readmda([Pathf 'templates.mda']);
Metric.ParaTh=ParaTh;


FileMdaMat=dir([PathMda '*sessionID*']);
load([PathMda FileMdaMat.name]);
Session=unique(SessionID);
for i=1:length(Session)
    Duration(i)=sum(SampleN(SessionID==Session(i)));
end
Duration=(cumsum(Duration)-1)/SamplingR;
Duration=[0 Duration];


% Filtered=readmda('Y:\singer\LuZhang Temp Data\MoutainLab\Output\ms3--d6\filtwhiten.mda');
t1=min(Metric.t1_sec);
t2=max(Metric.t2_sec);
timerange=[t1;t2];

R=readmda([Pathf 'firings.mda']);
[UniUnitID,I1]=unique(R(3,:));
ChI=R(1,I1);
clear dataHist dataHisttime
h=waitbar(0,'Calculate RateHistogram');
for i=1:length(UniUnitID)
   TS{i}=(R(2,R(3,:)==i)-1)/SamplingR;
   ISI=diff(TS{i});
   TStime{i}=TS{i}(1:end-1);
   InterRecordingISI=[];
   for j=1:length(Session)
       Ix=find(TStime{i}>=Duration(j)&TStime{i}<=Duration(j+1));
       InterRecordingISI=[InterRecordingISI max(Ix)];
   end
   ISI(InterRecordingISI)=[];

   InvalidISIr(i)=sum(ISI<=RefactoryPeriod)/length(ISI);
   [dataHist(i,:),dataHisttime]=GT_RateHist(TS{i},timerange,RateBin);
waitbar(i/length(UniUnitID),h);
end
close(h);

[CorrR,CorrPval]=corr(dataHist',dataHisttime(:),'rows','pairwise');

Metric.InvalidISIr=InvalidISIr;
Metric.CorrTime=[CorrR(:) CorrPval(:)];
Metric.ChI=ChI;

for i=1:size(templates,1)
    for j=1:size(templates,3)
        Amp(i,j)=max(abs(squeeze(templates(i,:,j))));
    end
end
Metric.Amp=Amp;
TSNum=Metric.num_events;



NumShow=4;
[~,I]=sort(Amp,1,'descend');
Imax=I(1:NumShow,:);
for i=1:size(Imax,2)
    if isempty(intersect(Imax(:,i)',ChI(i)))
       Imax(end,i)=ChI(i);
    end
end




if PlotP==1

Ynum=ceil(length(TS).^0.5);
Xnum=Ynum;

Xleft=0.01;
Xright=0.01;
XInt=0.01;
Xwidth=(1-Xleft-Xright-XInt*(Xnum-1))/Xnum;

Ytop=0.1;
Ylow=0.01;
YInt=0.01;
Ywidth=(1-Ytop-Ylow-(Ynum-1)*YInt)/Ynum;


ColorCh=jet;
% close
if size(ColorCh,1)<64
else
   ColorCh=ColorCh(1:2:64,:);
end
figure;
xN=1;yN=0;
subplot('position',[1-(Xwidth+XInt)*Xnum/2 1-Ytop+0.02 Xwidth*Xnum/2 Ywidth/4]);
imagesc([1:32]);axis xy
text(0,1,'1','fontsize',12,'horizontalalignment','right');
text(33,1,'32','fontsize',12,'horizontalalignment','left');
text(16,1.5,'Channels','fontsize',12,'horizontalalignment','center','verticalalignment','bottom');

set(gca,'clim',[1 32],'xtick',[],'ytick',[],'box','off');colormap(ColorCh);
for i=1:size(templates,3)
    subplot('position',[Xleft+(xN-1)*(XInt+Xwidth) 1-(yN+1)*Ywidth-yN*YInt-Ytop Xwidth Ywidth]);
    PIndex=sort(Imax(:,i));
    [~,ChIMax(i),~]=intersect(PIndex,ChI(i));

    GT_wavePlot(squeeze(templates(PIndex,:,i)),ChIMax(i),ColorCh(PIndex,:));hold on;
    Temp=max(squeeze(templates(ChI(i),:,i)));
    text(20,Temp+0.5,['Unit ' showNum(Metric.label(i),0) '-' showNum(Metric.overlap_cluster(i),0)],'fontsize',6,'horizontalalignment','left');
%     text(50,Temp+0.5,['-' showNum(Metric.overlap_cluster(i),0)],'fontsize',6,'horizontalalignment','left');

    Temp=min(squeeze(templates(ChI(i),:,i)));

    text(30,Temp+1,['iso' showNum(Metric.isolation(i),2)],'fontsize',5,'horizontalalignment','left');
    text(80,Temp+1,['noise' showNum(Metric.noise_overlap(i),2)],'fontsize',5,'horizontalalignment','left');
    text(30,Temp,['SNR' showNum(Metric.peak_snr(i),2)],'fontsize',5,'horizontalalignment','left');
    text(80,Temp,['Fre' showNum(Metric.firing_rate(i),0)],'fontsize',5,'horizontalalignment','left');

    
    if mod(xN,Xnum)==0
       xN=1;
       yN=yN+1;
    else
       xN=xN+1;

    end

    
end
papersizePX=[0 0 40 30];
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));

%     saveas(gcf,[PathSave 'TempLatesAll.fig'],'fig');
    saveas(gcf,[PathSave 'TempLatesAll.png'],'png');
    close all

Ynum=2;
Xnum=2;

Xleft=0.1;
Xright=0.01;
XInt=0.1;
Xwidth=(1-Xleft-Xright-XInt*(Xnum-1))/Xnum;

Ytop=0.01;
Ylow=0.1;
YInt=0.1;
Ywidth=(1-Ytop-Ylow-(Ynum-1)*YInt)/Ynum;

colorH=[40 180 70]/255;
alpha=0.5;



figure;
subplot('position',[Xleft 1-Ywidth-Ytop Xwidth Ywidth]);

histPlotLUPerc(Metric.isolation,[0:0.01:1],colorH,alpha);hold on;
plot([thIsolation thIsolation],[0 1],'r');set(gca,'ylim',[0 0.5],'xlim',[0.8 1],'box','off');
xlabel('Isolation With Other Units');
ylabel('Probability');

subplot('position',[Xleft+Xwidth+XInt 1-Ywidth-Ytop Xwidth Ywidth]);
hist(Metric.noise_overlap,[0:0.1:1])
histPlotLUPerc(Metric.noise_overlap,[0:0.01:1],colorH,alpha);hold on;
plot([thNoise thNoise],[0 1],'r');set(gca,'ylim',[0 0.4],'xlim',[0 0.6],'box','off');
xlabel('Isolation With Noise');
ylabel('Probability');

% figure;
% hist(Metric.peak_noise,1:0.2:8)
subplot('position',[Xleft Ylow Xwidth Ywidth]);
histPlotLUPerc(Metric.peak_snr,[0:0.2:8],colorH,alpha);hold on
plot([thSNR thSNR],[0 1],'r');set(gca,'ylim',[0 0.6],'xlim',[0 8],'box','off');
xlabel('Peak SignalNoiseRatio');
ylabel('Probability');

subplot('position',[Xleft+Xwidth+XInt Ylow Xwidth Ywidth]);
histPlotLUPerc(InvalidISIr,[0:0.0002:0.005],colorH,alpha);hold on;
plot([ISIth ISIth],[0 1],'r');set(gca,'ylim',[0 0.8],'xlim',[0 0.005],'box','off');
xlabel('Invalid(>1ms) ISI Ratio ');
ylabel('Probability');
   set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));

%     saveas(gcf,[PathSave 'SortingPara.fig'],'fig');
    saveas(gcf,[PathSave 'SortingPara.png'],'png');

end
    close all



CorrectI=find(Metric.noise_overlap<thNoise&Metric.isolation>thIsolation...
    &Metric.peak_snr>thSNR&InvalidISIr(:)<=ISIth);

fprintf([num2str(length(CorrectI)) ' units survived from ' num2str(length(Metric.noise_overlap))])
fprintf('\n')

Ynum=length(CorrectI);
Xnum=1;
Xleft=0.01;
Xright=0.01;
XInt=0.01;
Xwidth=(1-Xleft-Xright-XInt*(Xnum-1))/Xnum;
Ytop=0.01;
Ylow=0.01;
YInt=0.01;
Ywidth=(1-Ytop-Ylow-(Ynum-1)*YInt)/Ynum;
xN=1;yN=0;



NumShow=6;
[~,I]=sort(Amp,1,'descend');
Imax=I(1:NumShow,:);
for i=1:size(Imax,2)
    if isempty(intersect(Imax(:,i)',ChI(i)))
       Imax(end,i)=ChI(i);
    end
end

Ynum=ceil(length(CorrectI)^0.5);
Xnum=Ynum;

Xleft=0.01;
Xright=0.01;
XInt=0.01;
Xwidth=(1-Xleft-Xright-XInt*(Xnum-1))/Xnum;

Ytop=0.1;
Ylow=0.01;
YInt=0.01;
Ywidth=(1-Ytop-Ylow-(Ynum-1)*YInt)/Ynum;
if PlotP==1

figure;
xN=1;yN=0;
subplot('position',[1-(Xwidth+XInt)*Xnum/2 1-Ytop+0.02 Xwidth*Xnum/2 Ywidth/4]);
imagesc([1:32]);axis xy
text(0,1,'1','fontsize',12,'horizontalalignment','right');
text(33,1,'32','fontsize',12,'horizontalalignment','left');
text(16,1.5,'Channels','fontsize',12,'horizontalalignment','center','verticalalignment','bottom');

set(gca,'clim',[1 32],'xtick',[],'ytick',[],'box','off');colormap(ColorCh);
for j=1:length(CorrectI)
    i=CorrectI(j);
    subplot('position',[Xleft+(xN-1)*(XInt+Xwidth) 1-(yN+1)*Ywidth-yN*YInt-Ytop Xwidth Ywidth]);
    PIndex=sort(Imax(:,i));
    [~,ChIMax(i),~]=intersect(PIndex,ChI(i));

    GT_wavePlot(squeeze(templates(PIndex,:,i)),ChIMax(i),ColorCh(PIndex,:));hold on;
    Temp=max(squeeze(templates(ChI(i),:,i)));
    text(20,Temp+0.5,['Unit ' showNum(Metric.label(i),0) '-' showNum(Metric.overlap_cluster(i),0)],'fontsize',6,'horizontalalignment','left');
    text(100,Temp+0.5,[showNum(Metric.num_events(i),0) ' spikes'],'fontsize',6,'horizontalalignment','left');

    %     text(50,Temp+0.5,['-' showNum(Metric.overlap_cluster(i),0)],'fontsize',6,'horizontalalignment','left');

    Temp=min(squeeze(templates(ChI(i),:,i)));

    text(30,Temp+1,['iso' showNum(Metric.isolation(i),2)],'fontsize',5,'horizontalalignment','left');
    text(80,Temp+1,['noise' showNum(Metric.noise_overlap(i),2)],'fontsize',5,'horizontalalignment','left');
    text(30,Temp,['SNR' showNum(Metric.peak_snr(i),2)],'fontsize',5,'horizontalalignment','left');

    
    if mod(xN,Xnum)==0
       xN=1;
       yN=yN+1;
    else
       xN=xN+1;

    end

    
end
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));

%     saveas(gcf,[PathSave 'TempLatesValid.fig'],'fig')
    saveas(gcf,[PathSave 'TempLatesValid.png'],'png')
    close all

figure; 
xN=1;yN=0;
for j=1:length(CorrectI)
    i=CorrectI(j);
    subplot('position',[Xleft+(xN-1)*(XInt+Xwidth) 1-(yN+1)*Ywidth-yN*YInt-Ytop Xwidth Ywidth]);
    bar(dataHisttime,(dataHist(i,:)));
    text(1,max(dataHist(i,:)),['Unit' num2str(UniUnitID(i))],'fontsize',5,'horizontalalignment','left');
    text(length(dataHisttime)/4*RateBin,max(dataHist(i,:)),['r=' showNum(CorrR(i),2)],'fontsize',5,'horizontalalignment','left');
    text(length(dataHisttime)/2*RateBin,max(dataHist(i,:)),['p=' showNum(CorrPval(i),2)],'fontsize',5,'horizontalalignment','left');
    set(gca,'ylim',[0 max(dataHist(i,:))+nanstd(dataHist(i,:))/4],'ytick',[],'xlim',dataHisttime([1 end]),'xtick',[]);
    if mod(xN,Xnum)==0
       xN=1;
       yN=yN+1;
    else
       xN=xN+1;
    end
    set(gca,'xlim',timerange,'ytick',[],'box','off');
end
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));

%     saveas(gcf,[PathSave 'FiringRateValid.fig'],'fig');
    saveas(gcf,[PathSave 'FiringRateValid.png'],'png');
     close all

    
    
CheckPairs=[];    
for j=1:length(CorrectI)
    i=CorrectI(j);
    if isempty(intersect(Metric.overlap_cluster(i),CorrectI))
    else
       CheckPairs=[CheckPairs;[i Metric.overlap_cluster(i)]];
    end
  
end
end


UniqueChI=unique(Metric.ChI);

close all

if PlotP==1
for j=1:length(UniqueChI)

    Temp1=intersect(find(Metric.ChI==UniqueChI(j)),CorrectI);    

if ~isempty(Temp1)

papersizePXX=[0 0 20 length(Temp1)*2];

figure;
subplot('position',[0.01 0.01 0.98 0.8]);
for i=1:length(Temp1)
GT_wavePlot(squeeze(templates(:,:,Temp1(i)))-20*(i-1),Metric.ChI(Temp1(i)));hold on;
text(4,-20*(i-1)+5,['Unit' num2str(Temp1(i))],'fontsize',6)
text(100,-20*(i-1)+5,['SpikeCounts ' showNum(Metric.num_events(Temp1(i)),0)],'fontsize',6)
end
set(gca,'ylim',[-20*length(Temp1) 5],'xlim',[1 34*32],'xcolor',[0.99 0.99 0.99],'ycolor',[0.99 0.99 0.99]);
title(['Principal WaveForm Channel' num2str(UniqueChI(j))],'color','r','fontsize',12);

set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePXX,'PaperSize',papersizePXX(3:4));
saveas(gcf,[PathSave 'WholeWF_Ch' num2str(UniqueChI(j)) '.png'],'png');
    close all

end

end



end


clear temp1 NegWaveP WaveForm WaveAligned
for i=1:length(Metric.ChI)
    temp1=templates(Metric.ChI(i),:,i);
    temp1=zscore(templates(Metric.ChI(i),:,i));
    [~,I]=max(abs(temp1));
    NegWaveP(i)=-sign(temp1(I));
    WaveForm(i,:)=temp1*NegWaveP(i);
end
WaveAligned=alignWaveForm(WaveForm);
[~,p]=min(mean(WaveAligned));
PreP=8;PostP=20;
WavePlot=WaveAligned(:,p-PreP:p+PostP);

Metric.WaveAlignedTime=[-PreP:PostP]/SamplingR;
Metric.WaveAligned=WavePlot;

for i=1:size(WavePlot,1)
[Metric.WFExpWidth(i),Metric.WFTrough2Peak(i)]=wave_width_exp(WavePlot(i,:));
end
Metric.WFExpWidth=Metric.WFExpWidth(:)/SamplingR*1000000;
Metric.WFTrough2Peak=Metric.WFTrough2Peak(:)/SamplingR*1000000;

save([Pathf 'MTresults.mat'],'templates','ChI','Metric','CorrectI');


if PlotP==1
papersizePX=[0 0 20 10];
figure;
subplot('position',[0.05 0.1 0.4 0.85]);
plot([-PreP:PostP]/SamplingR*1000000,WavePlot(CorrectI,:)','color',[0.7 0.7 0.7]);
xlabel('Time from Negative Peak ms');
set(gca,'xlim',[-400 800],'xtick',[-400:200:800],'box','off')
ylabel('Z-Score')

DisX=[0:50:1000];
subplot('position',[0.55 0.1 0.4 0.85]);
histPlotLU(Metric.WFTrough2Peak(CorrectI),DisX,[0.7 0.7 0.7],0.6);
xlabel('Trough to Peak Duration ms');
ylabel('Unit Counts');
set(gca,'xlim',[0 1000],'xtick',[0:200:1000],'box','off')

set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));
saveas(gcf,[PathSave 'WFduration.png'],'png');
close all

end

% % % % % Temp1=intersect([204:226],CorrectI)    
% % % % % figure;
% % % % % for i=1:length(Temp1)
% % % % % GT_wavePlot(squeeze(templates(:,:,Temp1(i)))-20*(i-1),ChI(Temp1(i)));hold on;
% % % % % text(4,-20*(i-1)+3,num2str(Temp1(i)),'fontsize',6)
% % % % % text(100,-20*(i-1)+3,showNum(Metric.num_events(Temp1(i)),0),'fontsize',6)
% % % % % end
% % % % % set(gca,'ylim',[-20*16 5],'xlim',[1 34*32])

    

