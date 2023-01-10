function GT_MountainOutput(Pathf,varargin)
% Pathf='Y:\singer\LuZhang Temp Data\MoutainLab\Output\ms3--d6\';
% % clear Amp Overlap OverlapR Non2 Imax I InvalidISIr


%%%%%%%%%This function extract Final Sorted Resutls and sorting parameters from Mountainlab and set
%%%%%%%%%threshold for qualified cluster; visualise waveforms; 
%%%%%%%%%Lu Zhang 11/6/2017


%%Input
%%Pathf=varargin{1}
%%PathMda=varargin{2};

%%%%%%%%%%Pathf->folder for storing mountainlab output with firings.mda,etc with inside
%%%%%%%%%%ParaMda->folder for storing raw ~.mda and ~.txt with information
%%%%%%%%%%of recording sessions

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


if nargin<2 
   PathMda=Pathf;
else
   PathMda=varargin{1};
end




%%%%%%%%%%%%%%%making new sub folder matlab to save sorted files
PathSave=[Pathf 'Sorted\'];
A = exist(PathSave);
if A~=7
mkdir(PathSave);
end
clear A
%%%%%%%%%%%%%%%making new sub folder matlab to save sorted files






%%%%%%%%%%%%load initial sorting results/parameters from Mountainlab
load([Pathf 'MTresults.mat']);
ParaTh=Metric.ParaTh;
thIsolation=ParaTh(1);   
thNoise=ParaTh(2);     
thSNR=ParaTh(3);        
ISIth=ParaTh(4);     
SamplingR=ParaTh(5);  
RefactoryPeriod=ParaTh(6); 
RateBin=ParaTh(7);  
%%%%%%%%%%%%load initial sorting results/parameters from Mountainlab




%%%%%%%%%%%%get sample num. for each recording session
FileMdaMat=dir([PathMda '*sessionID*']);
load([PathMda FileMdaMat.name]);

Session=unique(SessionID);
for i=1:length(Session)
    Duration(i)=sum(SampleN(SessionID==Session(i)));
end
%%%%%%%%%%%%get sample num. for each recording session



t1=min(Metric.t1_sec);
t2=max(Metric.t2_sec);
timerange=[t1;t2];

%%%%%%%%%%%%load final sorting results
R=readmda([Pathf 'firings.curated.mda']);
[UniUnitID,I1]=unique(R(3,:));
ChI=R(1,I1);
clear dataHist dataHisttime
h=waitbar(0,'Calculate RateHistogram');
for i=1:length(UniUnitID)
   TS{i}=(R(2,R(3,:)==UniUnitID(i))-1)/SamplingR;
   [dataHist(i,:),dataHisttime]=GT_RateHist(TS{i},timerange,RateBin);
   waitbar(i/length(UniUnitID),h);
end
close(h);
%%%%%%%%%%%%load final sorting results


[~,i1,i2]=intersect(UniUnitID,Metric.label);
TS=TS(i1);
dataHist=dataHist(i1,:);
UniUnitID=UniUnitID(i1);
ChI=ChI(i1);


Sub=fieldnames(Metric);
MetricNew=Metric;
MetricNew=struct([]);
for i=1:length(Sub)
    if strcmp(Sub{i},'CorrTime')||strcmp(Sub{i},'InvalidISIr')
       continue
    end
    if strcmp(Sub{i},'WaveAlignedTime')
       MetricNew.WaveAlignedTime=Metric.WaveAlignedTime;
       continue
    end
    
    if strcmp(Sub{i},'Amp')
       MetricNew.Amp=Metric.Amp(:,i2);
       continue
    end
    if strcmp(Sub{i},'ParaTh')
       MetricNew.ParaTh=Metric.ParaTh;
       continue
    end
    if strcmp(Sub{i},'WaveAligned')
       MetricNew.WaveAligned=Metric.WaveAligned(i2,:);
       continue
    end
    MetricNew=setfield(MetricNew,{1},Sub{i},getfield(Metric,{1},Sub{i},{i2}));
end
[CorrR,CorrPval]=corr(dataHist',dataHisttime(:),'rows','pairwise');
MetricNew.CorrTime=[CorrR(:) CorrPval(:)];
for i=1:length(i2)
    MetricNew.t1_sec(i)=TS{i}(1);
    MetricNew.t2_sec(i)=TS{i}(end);
    MetricNew.dur_sec(i)=MetricNew.t2_sec(i)-MetricNew.t1_sec(i);
    MetricNew.num_events(i)=length(TS{i});
end
    MetricNew.firing_rate=MetricNew.num_events./MetricNew.dur_sec;

RecordingO=cumsum(Duration);
RecordingS=[1 RecordingO(1:end-1)+1];

for i=1:length(UniUnitID)
    temp1=R(2,R(3,:)==UniUnitID(i));
    ISI=[];
    for j=1:length(Duration)
        TSnew{j}(i).TS=temp1((temp1>=RecordingS(j)&temp1<=RecordingO(j)));
        TSnew{j}(i).TS=(TSnew{j}(i).TS-RecordingS(j))/SamplingR;
        TSnew{j}(i).UnitLabel=UniUnitID(i);
        if length(TSnew{j}(i).TS)>1
        ISI=[ISI;diff(TSnew{j}(i).TS(:))];
        end
    end
    MetricNew.InvalidISIr(i)=sum(ISI<=RefactoryPeriod)/length(ISI);
end

 for j=1:length(Duration)
     Neuron=TSnew{j};
     DurationT=(Duration(j)-1)/SamplingR;
     save([PathSave 'recording' num2str(Session(j)) '.mat'],'Neuron','DurationT');
 end
 MetricSorted=MetricNew;
 save([PathSave 'MTresultsSorted.mat'],'MetricSorted');
 
 
 

Ynum=1;
Xnum=3;

Xleft=0.1;
Xright=0.01;
XInt=0.05;
Xwidth=(1-Xleft-Xright-XInt*(Xnum-1))/Xnum;

Ytop=0.01;
Ylow=0.1;
YInt=0.01;
Ywidth=(1-Ytop-Ylow-(Ynum-1)*YInt)/Ynum;

 
papersizePX=[0 0 30 10];
figure;
subplot('position',[Xleft Ylow Xwidth Ywidth]);
plot(MetricSorted.WaveAlignedTime*1000000,MetricSorted.WaveAligned','color',[0.7 0.7 0.7]);
xlabel('Time from Negative Peak ms');
set(gca,'xlim',[-400 800],'xtick',[-400:200:800],'box','off')
ylabel('Z-Score')

DisX=[0:5:500];
subplot('position',[Xleft+(XInt+Xwidth)*1 Ylow Xwidth Ywidth]);
histPlotLU(MetricSorted.WFExpWidth,DisX,[0.7 0.7 0.7],0.6);
xlabel('WaveWidth 1/e Negative Peak ms');
ylabel('Unit Counts');
set(gca,'xlim',[0 DisX(end)],'xtick',[0:200:DisX(end)],'box','off')


DisX=[0:50:1000];
subplot('position',[Xleft+(XInt+Xwidth)*2 Ylow Xwidth Ywidth]);
histPlotLU(MetricSorted.WFTrough2Peak,DisX,[0.7 0.7 0.7],0.6);
xlabel('Trough to Peak Duration ms');
ylabel('Unit Counts');
set(gca,'xlim',[0 DisX(end)],'xtick',[0:200:DisX(end)],'box','off')


set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));
saveas(gcf,[PathSave 'WFduration.png'],'png');
close all


Ynum=length(UniUnitID);

Xleft=0.02;
Xright=0.02;
XInt=0.02;
Xwidth=(1-Xleft-Xright-XInt*(Xnum-1))/sum(Duration).*Duration;

Ytop=0.02;
Ylow=0.02;
YInt=0.005;
Ywidth=(1-Ytop-Ylow-(Ynum-1)*YInt)/Ynum;

clear dataHist;

papersizePX=[0 0 20 length(UniUnitID)*1];
h=waitbar(0,'Calculate RateHistogram');

figure;
% xN=1;yN=0;

for j=1:length(Duration)
        timerange=[0 (Duration(j)-1)/SamplingR];

        for i=1:length(UniUnitID)
            if j==1&&i==round(length(UniUnitID)/2)
               ylabel('FiringRate');
            end
        [dataHist{j}(i,:),dataHisttime]=GT_RateHist(TSnew{j}(i).TS,timerange,RateBin);
        subplot('position',[Xleft+sum(Xwidth(1:j-1))+(j-1)*XInt 1-Ytop-(i-1)*(Ywidth+YInt) Xwidth(j) Ywidth]);
        bar(dataHisttime,dataHist{j}(i,:));
        set(gca,'xlim',timerange,'xtick',[],'ytick',[],'box','off','ylim',[0 max(max(dataHist{j}(i,:)),0.001)]);
        
            if i==length(UniUnitID)&&j==round(length(Duration)/2)
               xlabel('Time');
            end
            waitbar(((j-1)*length(UniUnitID)+i)/(length(UniUnitID)*length(Duration)),h);

        end
end
    
close(h)
set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',papersizePX,'PaperSize',papersizePX(3:4));
saveas(gcf,[PathSave 'RateHist.png'],'png');
close all


 
 
 
 
 
 
 
 
 
 
 
 
 
 
