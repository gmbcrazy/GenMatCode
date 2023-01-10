fnam='E:\Presentation\Wavelet\';

% close all
clear all
% fileName='F:\Lu Data\Mouse011\step3\LDL\07062013\NaviReward-M11-070613002-f.nex'
% WaveParam.timerange=[410;510];

% fileName='F:\Lu Data\Mouse014\ldl\LDL no object\06082013\NaviReward-M14-060813004-f.nex'
% WaveParam.timerange=[410;510];


% fileName='F:\Lu Data\Mouse014\ldl\LDL no object\18072013\NaviReward-M14-180713002-f.nex'
% fileName='F:\Lu Data\Mouse027\ldl no odor\24062014\NaviReward-M27-240614002-f.nex'
fileName='F:\Lu Data\Mouse011\step3\LDL\07062013\NaviReward-M11-070613002-f.nex'
WaveParam.timerange=[40;230];
WaveParam.Freq=[1:0.5:20];

% WaveParam.wname='morl';
% WaveParam.Samplingrate=1000;
% WaveParam.ntw=21;
% WaveParam.nsw=3;
% WaveParam.range=[-2 2];
% WaveParam.DownSample=5;

% ntw=21;
% 
% fileName='F:\Lu Data\Mouse023\LDL no odor\10042014\NaviReward-M23-100414002-f.nex'
% WaveParam.timerange=[510;520];


timeshow=[WaveParam.timerange(1)+2;WaveParam.timerange(2)-2];

WaveParam.Freq=[2:0.5:40];
WaveParam.Freq=[1:0.5:20];
WaveParam.Freq=[1:0.5:20];

ntw=50;
nsw=5;
% wname='cmor1-1.5';
wname='morl';

fc = centfrq(wname);
Rate=5;
F=WaveParam.Freq;
scales=sort(fc./F./0.001/Rate);  
scales=sort(fc./F./0.001/Rate);  
Chan{1}.Name='HippCh8AD';
Chan{2}.Name='CereCh11AD';
Chan{3}.Name='VelocitySmooth';



for i=1:length(Chan)
    Data{i}=smrORnex_cont(fileName,Chan{i},WaveParam.timerange);
    Data{i}.Time=downsample(Data{i}.Time,Rate);
    Data{i}.Data=downsample(Data{i}.Data,Rate);
%     ArtI=intersect(ArtI,[1:length(Data{i}.Data)]');
%     IArtI=setdiff(1:length(Data{i}.Data),ArtI);
%     meanN=mean(Data{i}.Data(IArtI));
%     stdN=std(Data{i}.Data(IArtI));
%     AddSig=random('norm',meanN,stdN,length(ArtI),1);
%     AddSig=AddSig(:);
%     Data{i}.Data(ArtI)=AddSig;
%     l(i)=length(Data{i}.Data);
end

mccount=100;
[WCOH,WCS,CWT_S1,CWT_S2]=wcoherLU(Data{1}.Data,Data{2}.Data,scales,wname,'ntw',ntw,'nsw',nsw);


cfs_s1=cwt(Data{1}.Data,scales,wname);
cfs_s1=abs(cfs_s1);

% cfs_s10   = cfs_s1;
% cfs_s1    = smoothCFS(abs(cfs_s1).^2,flag_SMOOTH,NSW,NTW);
[NumStim, nm, nl, TSStim, names, NaviType] = nex_marker2(fileName, 'FirstStim');
TSStim=TSStim(:);
timerange=[TSStim(1:end-1)'+2;TSStim(2:end)'-0.1];
    SDatatemp=smrORnex_cont(fileName,Chan{1},timerange);
SData=[];
    for i=1:length(SDatatemp) 
    SData=[SData;downsample(SDatatemp(i).Data(:),Rate)];
    end
Pvalue=0.95;
sig1 = wavesigfLU(SData,WaveParam.Freq,1000/Rate,Pvalue);
% sig1 = wavesigfLU(Data{1}.Data,WaveParam.Freq,1000,Pvalue);
std(SData)
std(Data{1}.Data)
imagesc(Data{1}.Time,F(end:-1:1),log(abs(cfs_s1)));axis xy

    wtcsig=(sig1(:))*(ones(1,length(Data{1}.Time)));
    wtcsig=cfs_s1./wtcsig;
    
    figure;
    imagesc(Data{1}.Time,F(end:-1:1),log(abs(CWT_S1)));axis xy
    wtcsig=(sig1(:))*(ones(1,length(Data{1}.Time)));

        wtcsig=CWT_S1./wtcsig;

    hold on
contour(Data{1}.Time,F(end:-1:1),wtcsig,[1 1],'k');

SimuLength=1000;
mccount=10;
Pvalue=0.95;
sig1 = wcoherSigfLU(Data{1}.Data,Data{2}.Data,scales,wname,ntw,nsw,mccount,SimuLength,Pvalue);

figure;
plot(sig1,'r');hold on

Xedge_blank_left=0.06;
Xedge_blank_right=0.01;
format short
XInterval=0.04;
XIndividual=1;
XWidth=(1-XInterval*(XIndividual-1)-Xedge_blank_left-Xedge_blank_right)/XIndividual;

Yedge_blank_low=0.08;
Yedge_blank_above=0.04;
YIndividual=3;

YInterval=0.03;
YWidth=(1-Yedge_blank_low-Yedge_blank_above-YInterval*(YIndividual-1))/YIndividual;
distri_Speed=0:1:25;

figure;
temp_x=Xedge_blank_left;
temp_y=Yedge_blank_low+(YIndividual-1)*YInterval+(YIndividual-1)*YWidth;  
subplot('position',[temp_x,temp_y,XWidth,YWidth]);
imagesc(Data{1}.Time,F(end:-1:1),log(abs(CWT_S1)));axis xy
set(gca,'clim',[-3 1],'ylim',[0 WaveParam.Freq(end)],'xlim',timeshow)
colorbar

temp_x=Xedge_blank_left;
temp_y=Yedge_blank_low+(YIndividual-2)*YInterval+(YIndividual-2)*YWidth;  
subplot('position',[temp_x,temp_y,XWidth,YWidth]);
imagesc(Data{1}.Time,F(end:-1:1),log(abs(CWT_S2)));axis xy
set(gca,'clim',[-6 -2],'ylim',[0 WaveParam.Freq(end)],'xlim',timeshow)
colorbar

hold on

% plot(Data{3}.Time,Data{3}.Data,'color',[0.1 0.1 0.1],'linewidth',2)

temp_x=Xedge_blank_left;
temp_y=Yedge_blank_low+(YIndividual-3)*YInterval+(YIndividual-3)*YWidth;  
subplot('position',[temp_x,temp_y,XWidth,YWidth]);
% imagesc(Data{1}.Time,F(end:-1:1),log(abs(CWT_S2)));axis xy
% set(gca,'clim',[-6 -2],'ylim',[0 WaveParam.Freq(end)],'xlim',timeshow)
% colorbar
imagesc(Data{1}.Time,F(end:-1:1),abs(WCOH));axis xy
set(gca,'clim',[0 1],'ylim',[0 WaveParam.Freq(end)],'xlim',timeshow);
colorbar

    wtcsig=(sig1(:))*(ones(1,length(Data{1}.Time)));
    wtcsig=abs(WCOH)./wtcsig;
    hold on
contour(Data{1}.Time,F(end:-1:1),wtcsig,[1 1],'k');
% contour(Data{1}.Time,F,wtcsig,[1 1],'k');


set(gcf, 'PaperUnits', 'centimeters');
set(gcf,'PaperPosition',[0 0 20 14],'PaperSize',[20 14]);

figure;
plot(F(end:-1:1),mean(abs(WCOH)'))

% saveas(gcf,[fnam fileName((end-15):(end-6)) '.png'],'png');






